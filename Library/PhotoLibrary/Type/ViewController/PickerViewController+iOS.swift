//
//  KindKit
//

#if os(iOS)

import UIKit
import PhotosUI
import MobileCoreServices
import KindFlow
import KindGraphics
import KindSystem

@MainActor
public final class PickerViewController : UIViewController {
    
    public let configuration: Configuration
    public let onSelect: @Sendable ([Item]) -> Void
    
    private let _fileStorage: FileStorage = {
        let storage = FileStorage(path: [ "KindKit", "ImagePickerTemp" ])!
        storage.clear()
        return storage
    }()
    private var _flow: (CancelTrait & Sendable)?
    
    public init(
        configuration: Configuration,
        onSelect: @escaping @Sendable ([Item]) -> Void
    ) {
        self.configuration = configuration
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(
        mode: Configuration.Mode,
        onSelect: @escaping @Sendable (Item) -> Void
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
        self._flow?.cancel()
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

extension PickerViewController : UINavigationControllerDelegate {
}

extension PickerViewController : UIImagePickerControllerDelegate {
    
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
            let image = Image(uiImage).unrotate()
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
extension PickerViewController : PHPickerViewControllerDelegate {
    
    public func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        guard results.isEmpty == false else {
            self.dismiss(animated: true)
            return
        }
        self._flow = KindFlow.Builder< [PHPickerResult], Never >()
            .dispatch(qos: .userInitiated)
            .each()
            .fifo(
                flow: KindFlow.Builder< PHPickerResult, Never >()
                    .completion({ (input: PHPickerResult, completion: @escaping @Sendable (Item) -> Void) in
                        let itemProvider = input.itemProvider
                        if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier, completionHandler: { url, error in
                                if let originUrl = url {
                                    guard let copyUrl = self._fileStorage.append(url: originUrl) else {
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
                                    let image = Image(uiImage).unrotate()
                                    completion(.image(image))
                                } else {
                                    completion(.error(.unknown))
                                }
                            })
                        } else {
                            completion(.error(.unsupportedType))
                        }
                    })
                    .build()
            )
            .dispatch(queue: .main)
            .hook(
                onValue: { [weak self] input in
                    self?.onSelect(input)
                },
                onCompleted: { [weak self] in
                    guard let self = self else { return }
                    Task(operation: {
                        await MainActor.run(body: {
                            self._flow = nil
                            self.dismiss(animated: true)
                        })
                    })
                }
            )
            .build()
            .perform(results)
    }
    
}

extension PickerViewController {
    
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
    
    public enum Item : Sendable {
        
        case image(Image)
        case video(TemporaryFile)
        case error(Error)
        
    }
    
    public enum Error : Swift.Error, Sendable {
        
        case unknown
        case unsupportedType
        
    }
    
}

public extension PickerViewController.Configuration {
    
    static var isLimitSupported: Bool {
        if #available(iOS 14.0, *) {
            return true
        }
        return false
    }
    
}

extension PickerViewController.Configuration {
    
    public struct Mode : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension PickerViewController.Configuration.Mode {
    
    @inlinable
    static var image: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var video: Self {
        return .init(rawValue: 1 << 1)
    }
    
}

fileprivate extension PickerViewController.Configuration.Mode {
    
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
