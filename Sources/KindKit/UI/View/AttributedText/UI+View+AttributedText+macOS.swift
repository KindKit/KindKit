//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.AttributedText {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.AttributedText
        typealias Content = KKAttributedTextView

        static var reuseIdentificator: String {
            return "UI.View.AttributedText"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: CGRect.zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKAttributedTextView : NSTextField {
        
    weak var kkDelegate: KKAttributedTextViewDelegate?
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.drawsBackground = true
        self.isBordered = false
        self.isBezeled = false
        self.isEditable = false
        self.isSelectable = false
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    override func alignmentRect(forFrame frame: NSRect) -> NSRect {
        return frame
    }
    
}

extension KKAttributedTextView {
    
    func update(view: UI.View.AttributedText) {
        self.update(frame: view.frame)
        self.update(text: view.text, alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.integral.cgRect
    }
    
    func update(text: NSAttributedString?, alignment: UI.Text.Alignment?) {
        if let text = text {
            self.attributedStringValue = text
        } else {
            self.stringValue = ""
        }
        if let alignment = alignment {
            self.alignment = alignment.nsTextAlignment
        }
    }
    
    func update(alignment: UI.Text.Alignment?) {
        if let alignment = alignment {
            self.alignment = alignment.nsTextAlignment
        }
    }
    
    func update(lineBreak: UI.Text.LineBreak) {
        self.lineBreakMode = lineBreak.nsLineBreakMode
    }
    
    func update(numberOfLines: UInt) {
        self.maximumNumberOfLines = Int(numberOfLines)
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

#endif
