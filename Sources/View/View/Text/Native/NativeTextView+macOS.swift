//
//  KindKitView
//

#if os(macOS)

import AppKit
import KindKitCore
import KindKitMath

extension TextView {
    
    struct Reusable : IReusable {
        
        typealias Owner = TextView
        typealias Content = NativeTextView

        static var reuseIdentificator: String {
            return "TextView"
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

final class NativeTextView : NSTextField {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: NativeControlViewDelegate?
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
    
    private unowned var _view: View?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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

extension NativeTextView {
    
    func update(view: TextView) {
        self._view = view
        self.update(text: view.text)
        self.update(textFont: view.textFont)
        self.update(textColor: view.textColor)
        self.update(alignment: view.alignment)
        self.update(lineBreak: view.lineBreak)
        self.update(numberOfLines: view.numberOfLines)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
    }
    
    func update(text: String) {
        self.stringValue = text
    }
    
    func update(textFont: Font) {
        self.font = textFont.native
    }
    
    func update(textColor: Color) {
        self.textColor = textColor.native
    }
    
    func update(alignment: TextAlignment) {
        self.alignment = alignment.nsTextAlignment
    }
    
    func update(lineBreak: TextLineBreak) {
        self.lineBreakMode = lineBreak.nsLineBreakMode
    }
    
    func update(numberOfLines: UInt) {
        self.maximumNumberOfLines = Int(numberOfLines)
    }
    
    func cleanup() {
        self._view = nil
    }
    
}

#endif
