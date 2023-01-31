//
//  KindKit
//

#if os(iOS)

import UIKit
import MessageUI

public extension UI {
    
    final class MailComposeViewController : MFMailComposeViewController {
        
        public let onFinish: (Result) -> Void
        
        public init(
            subject: String,
            toRecipients: [String]? = nil,
            ccRecipients: [String]? = nil,
            bccRecipients: [String]? = nil,
            body: Body,
            attachments: [Attachment],
            onFinish: @escaping (Result) -> Void
        ) {
            self.onFinish = onFinish
            super.init(nibName: nil, bundle: nil)
            self.mailComposeDelegate = self
            self.setSubject(subject)
            self.setToRecipients(toRecipients)
            self.setCcRecipients(ccRecipients)
            self.setBccRecipients(bccRecipients)
            switch body {
            case .raw(let data): self.setMessageBody(data, isHTML: false)
            case .html(let data): self.setMessageBody(data, isHTML: true)
            }
            for attachment in attachments {
                self.addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.filename)
            }
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

public extension UI.MailComposeViewController {
    
    enum Body {
        
        case raw(String)
        case html(String)
        
    }
    
    struct Attachment {
        
        public let data: Data
        public let mimeType: String
        public let filename: String
        
        public init(
            data: Data,
            mimeType: String,
            filename: String
        ) {
            self.data = data
            self.mimeType = mimeType
            self.filename = filename
        }
        
    }
    
    enum Result {
        
        case cancelled
        case saved
        case sent
        case error(Swift.Error)
        
    }
    
}

extension UI.MailComposeViewController : MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        switch result {
        case .cancelled:
            self.onFinish(.cancelled)
        case .saved:
            self.onFinish(.saved)
        case .sent:
            self.onFinish(.sent)
        case .failed:
            if let error = error {
                self.onFinish(.error(error))
            }
        @unknown default:
            break
        }
        self.dismiss(animated: true)
    }
    
}

#endif
