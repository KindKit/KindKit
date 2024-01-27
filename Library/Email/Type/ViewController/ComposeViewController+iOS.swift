//
//  KindKit
//

#if os(iOS)

import UIKit
import MessageUI
import KindEvent
import KindMonadicMacro

@Monadic
@MainActor
public final class ComposeViewController : MFMailComposeViewController {
    
    @MonadicField
    public var subject: String? {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicField
    public var toRecipients: [String] = [] {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicField
    public var ccRecipients: [String] = [] {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicField
    public var bccRecipients: [String] = [] {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicField
    public var body: Body? {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicField
    public var attachments: [Attachment] = [] {
        didSet {
            guard self.isViewLoaded == false else { fatalError("It is possible to set this property only before showing") }
        }
    }
    
    @MonadicSignal
    public let onFinish = Signal< Void, Result >()
    
    private var _delegate: Delegate!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        self._delegate = Delegate(self)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        if let subject = self.subject {
            self.setSubject(subject)
        }
        if self.toRecipients.isEmpty == false {
            self.setToRecipients(self.toRecipients)
        }
        if self.ccRecipients.isEmpty == false {
            self.setCcRecipients(self.ccRecipients)
        }
        if self.bccRecipients.isEmpty == false {
            self.setBccRecipients(self.bccRecipients)
        }
        switch self.body {
        case .raw(let data):
            self.setMessageBody(data, isHTML: false)
        case .html(let data):
            self.setMessageBody(data, isHTML: true)
        case .none:
            break
        }
        for attachment in self.attachments {
            self.addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.filename)
        }
    }
    
}

extension ComposeViewController {
    
    @MainActor
    final class Delegate : NSObject, MFMailComposeViewControllerDelegate {
        
        unowned(unsafe) let viewController: ComposeViewController
        
        init(_ viewController: ComposeViewController) {
            self.viewController = viewController
            
            super.init()
            
            self.viewController.mailComposeDelegate = self
        }
        
        nonisolated func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Swift.Error?
        ) {
            Task(operation: {
                switch result {
                case .cancelled:
                    self.viewController.onFinish.emit(.cancelled)
                case .saved:
                    self.viewController.onFinish.emit(.saved)
                case .sent:
                    self.viewController.onFinish.emit(.sent)
                case .failed:
                    if let error = error {
                        self.viewController.onFinish.emit(.error(error))
                    }
                @unknown default:
                    break
                }
                await self.viewController.dismiss(animated: true)
            })
        }
        
    }
    
}

#endif
