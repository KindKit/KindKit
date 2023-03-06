//
//  KindKit
//

#if os(iOS)

import UIKit
import PhotosUI

public extension UI {
    
    final class ImagePickerViewController : UIViewController {
        
        public let onSelect: (UI.Image) -> Void
        
        public init(
            onSelect: @escaping (UI.Image) -> Void
        ) {
            self.onSelect = onSelect
            super.init(nibName: nil, bundle: nil)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func viewDidLoad() {
            if #available(iOS 14.0, *) {
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = 1
                configuration.preferredAssetRepresentationMode = .automatic
                
                let vc = PHPickerViewController(configuration: configuration)
                vc.delegate = self
                
                self.addChild(vc)
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
            } else {
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
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
            self.onSelect(UI.Image(uiImage).unrotate())
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
        guard let itemProvider = results.first?.itemProvider else {
            self.dismiss(animated: true)
            return
        }
        guard itemProvider.canLoadObject(ofClass: UIImage.self) == true else {
            self.dismiss(animated: true)
            return
        }
        itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (uiImage, error) in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                if let uiImage = uiImage as? UIImage {
                    self.onSelect(UI.Image(uiImage).unrotate())
                }
            }
        })
    }
    
}

#endif
