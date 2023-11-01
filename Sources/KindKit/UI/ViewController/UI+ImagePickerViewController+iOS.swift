//
//  KindKit
//

#if os(iOS)

import UIKit
import PhotosUI
import MobileCoreServices

extension UI {
    
    public final class ImagePickerViewController : UIViewController {
        
        public let configuration: Configuration
        public let onSelect: ([Item]) -> Void
        
        private var _pipeline: ICancellable?
        
        public init(
            configuration: Configuration,
            onSelect: @escaping ([Item]) -> Void
        ) {
            self.configuration = configuration
            self.onSelect = onSelect
            super.init(nibName: nil, bundle: nil)
        }
        
        public convenience init(
            mode: Configuration.Mode,
            onSelect: @escaping (Item) -> Void
        ) {
            self.init(
                configuration: .init(
                    mode: mode,
                    preferredLimit: 1
                ),
                onSelect: { result in
                    onSelect(result[0])
                }
            )
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            self._pipeline?.cancel()
        }
        
        public override func viewDidLoad() {
            if #available(iOS 14.0, *) {
                var configuration = PHPickerConfiguration()
                configuration.filter = self.configuration.mode.phPickerFilter
                configuration.selectionLimit = self.configuration.preferredLimit
                configuration.preferredAssetRepresentationMode = .automatic
                
                let vc = PHPickerViewController(configuration: configuration)
                vc.delegate = self
                
                self.addChild(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
            } else {
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.mediaTypes = self.configuration.mode.mediaTypes
                vc.delegate = self
                
                self.addChild(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
            }
        }
        
    }
    
}

extension UI.ImagePickerViewController : UINavigationControllerDelegate {
}

extension UI.ImagePickerViewController : UIImagePickerControllerDelegate {
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        var uiImage = info[.editedImage] as? UIImage
        if uiImage == nil {
            uiImage = info[.originalImage] as? UIImage
        }
        self.dismiss(animated: true)
        if let uiImage = uiImage {
            let image = UI.Image(uiImage).unrotate()
            self.onSelect([ .image(image) ])
        } else {
            self.onSelect([ .error(.unknown) ])
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
}

@available(iOS 14.0, *)
extension UI.ImagePickerViewController : PHPickerViewControllerDelegate {
    
    public func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        guard results.isEmpty == false else {
            self.dismiss(animated: true)
            return
        }
        self._pipeline = Flow.Builder< [PHPickerResult], Never >()
            .dispatch(global: .userInitiated)
            .each()
            .fifo(
                pipeline: Flow.Builder< PHPickerResult, Never >()
                    .completion({ (input: PHPickerResult, completion: @escaping (Item) -> Void) in
                        let itemProvider = input.itemProvider
                        if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier, completionHandler: { url, error in
                                if let originUrl = url {
                                    guard let copyUrl = Self.fileStorage.append(url: originUrl) else {
                                        completion(.error(.unknown))
                                        return
                                    }
                                    completion(.video(TemporaryFile(url: copyUrl)))
                                } else {
                                    completion(.error(.unknown))
                                }
                            })
                        } else if itemProvider.canLoadObject(ofClass: UIImage.self) == true {
                            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { value, error in
                                if let uiImage = value as? UIImage {
                                    let image = UI.Image(uiImage).unrotate()
                                    completion(.image(image))
                                } else {
                                    completion(.error(.unknown))
                                }
                            })
                        } else {
                            completion(.error(.unsupportedType))
                        }
                    })
                    .pipeline()
            )
            .dispatch(.main)
            .pipeline(
                onReceive: { [weak self] input in
                    self?.onSelect(input)
                },
                onCompleted: { [weak self] in
                    guard let self = self else { return }
                    self._pipeline = nil
                    self.dismiss(animated: true)
                }
            )
            .perform(results)
    }
    
}

extension UI.ImagePickerViewController {
    
    public struct Configuration {
        
        public let mode: Mode
        public let preferredLimit: Int
        
        public init(
            mode: Mode = .image,
            preferredLimit: Int = 1
        ) {
            self.mode = mode
            if Self.isLimitSupported == true {
                self.preferredLimit = preferredLimit
            } else {
                self.preferredLimit = 1
            }
        }
        
    }
    
    public enum Item {
        
        case image(UI.Image)
        case video(TemporaryFile)
        case error(Error)
        
    }
    
    public enum Error : Swift.Error {
        
        case unknown
        case unsupportedType
        
    }
    
}

public extension UI.ImagePickerViewController.Configuration {
    
    static var isLimitSupported: Bool {
        if #available(iOS 14.0, *) {
            return true
        }
        return false
    }
    
}

extension UI.ImagePickerViewController.Configuration {
    
    public struct Mode : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.ImagePickerViewController.Configuration.Mode {
    
    static let image = UI.ImagePickerViewController.Configuration.Mode(rawValue: 1 << 0)
    static let video = UI.ImagePickerViewController.Configuration.Mode(rawValue: 1 << 1)
    
}

fileprivate extension UI.ImagePickerViewController {
    
    static let fileStorage: Storage.FileSystem = {
        let storage = Storage.FileSystem(path: [ "KindKit", "ImagePickerTemp" ])!
        storage.clear()
        return storage
    }()
    
}

fileprivate extension UI.ImagePickerViewController.Configuration.Mode {
    
    @available(iOS 14.0, *)
    var phPickerFilter: PHPickerFilter {
        var filters: [PHPickerFilter] = []
        if self.contains(.image) == true {
            filters.append(.images)
        }
        if self.contains(.video) == true {
            filters.append(.videos)
        }
        if filters.count == 1 {
            return filters[0]
        }
        return .any(of: filters)
    }
    
    var mediaTypes: [String] {
        var mediaTypes: [String] = []
        if self.contains(.image) == true {
            mediaTypes.append(kUTTypeQuickTimeImage as String)
        }
        if self.contains(.video) == true {
            mediaTypes.append(kUTTypeMovie as String)
        }
        return mediaTypes
    }
    
}

#endif
