//
//  KindKit
//

#if os(macOS)

import AppKit

extension UI.View.Text {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Text
        typealias Content = KKTextView

        static var reuseIdentificator: String {
            return "UI.View.Text"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKTextView : NSTextField {
    
    unowned var kkDelegate: KKControlViewDelegate?
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.drawsBackground = true
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

extension KKTextView {
    
    func update(view: UI.View.Text) {
        self.update(text: view.text)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(text: String) {
        self.stringValue = text
    }
    
    func update(textFont: UI.Font) {
        self.font = textFont.native
    }
    
    func update(textColor: UI.Color) {
        self.textColor = textColor.native
    }
    
    func update(alignment: UI.Text.Alignment) {
        self.alignment = alignment.nsTextAlignment
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
    
    func update(alpha: Float) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
