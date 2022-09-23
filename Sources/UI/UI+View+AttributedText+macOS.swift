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
        
    unowned var kkDelegate: KKAttributedTextViewDelegate?
    
    override var frame: CGRect {
        set(value) {
            if super.frame != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
            }
        }
        get { return super.frame }
    }
    override var isFlipped: Bool {
        return true
    }
    
    private unowned var _view: UI.View.AttributedText?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.drawsBackground = false
        self.isBordered = false
        self.isBezeled = false
        self.isEditable = false
        self.isSelectable = false
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
        self._view = view
        self.update(text: view.text, alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(text: NSAttributedString, alignment: UI.Text.Alignment?) {
        self.attributedStringValue = text
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
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

#endif
