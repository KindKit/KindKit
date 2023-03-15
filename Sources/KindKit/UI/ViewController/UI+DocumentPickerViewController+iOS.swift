//
//  KindKit
//

#if os(iOS)

import UIKit
import UniformTypeIdentifiers

public extension UI {
    
    final class DocumentPickerViewController : UIViewController {
        
        public let mimeTypes: [MimeType]
        public let allowsMultipleSelection: Bool
        public let onSelect: ([URL]) -> Void
        
        public init(
            mimeTypes: [MimeType],
            allowsMultipleSelection: Bool,
            onSelect: @escaping ([URL]) -> Void
        ) {
            self.mimeTypes = mimeTypes
            self.allowsMultipleSelection = allowsMultipleSelection
            self.onSelect = onSelect
            super.init(nibName: nil, bundle: nil)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func viewDidLoad() {
            let vc: UIDocumentPickerViewController
            if #available(iOS 14.0, *) {
                vc = UIDocumentPickerViewController(forOpeningContentTypes: self.mimeTypes.compactMap({
                    $0.uniformType
                }))
            } else {
                vc = UIDocumentPickerViewController(documentTypes: self.mimeTypes.map({
                    $0.value
                }), in: .import)
            }
            vc.allowsMultipleSelection = self.allowsMultipleSelection
            vc.delegate = self
            
            self.addChild(vc)
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)

        }
        
    }
    
}

extension UI.DocumentPickerViewController : UINavigationControllerDelegate {
}

extension UI.DocumentPickerViewController : UIDocumentPickerDelegate {
    
    public func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        self.onSelect(urls)
    }
    
}

#endif
