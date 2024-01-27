//
//  KindKit
//

#if os(iOS)

import UIKit
import UniformTypeIdentifiers
import KindEvent
import KindMonadicMacro

@Monadic
public final class PickerViewController : UIViewController {
    
    @MonadicField
    public var mimeTypes: [MimeType] = [] {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicField
    public var allowsMultipleSelection: Bool = false {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicSignal
    public let onFinish = Signal< Void, [URL] >()
    
    private var _delegate: Delegate!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        self._delegate = Delegate(self)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        let vc: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            vc = UIDocumentPickerViewController(
                forOpeningContentTypes: self.mimeTypes.compactMap(\.uniformType)
            )
        } else {
            vc = UIDocumentPickerViewController(
                documentTypes: self.mimeTypes.map(\.value),
                in: .import
            )
        }
        vc.allowsMultipleSelection = self.allowsMultipleSelection
        vc.delegate = self._delegate
        
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
}

extension PickerViewController {
    
    final class Delegate : NSObject, UINavigationControllerDelegate, UIDocumentPickerDelegate {
        
        unowned(unsafe) let viewController: PickerViewController
        
        init(_ viewController: PickerViewController) {
            self.viewController = viewController
            
            super.init()
        }
        
        func documentPicker(
            _ controller: UIDocumentPickerViewController,
            didPickDocumentsAt urls: [URL]
        ) {
            self.viewController.onFinish.emit(urls)
        }
        
    }
    
}

#endif
