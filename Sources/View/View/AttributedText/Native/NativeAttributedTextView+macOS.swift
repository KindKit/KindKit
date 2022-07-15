//
//  KindKitView
//

#if os(macOS)

import AppKit
import KindKitCore
import KindKitMath

extension AttributedTextView {
    
    struct Reusable : IReusable {
        
        typealias Owner = AttributedTextView
        typealias Content = NativeAttributedTextView

        static var reuseIdentificator: String {
            return "AttributedTextView"
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

final class NativeAttributedTextView : NSTextField {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: AttributedTextViewDelegate?
    
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

extension NativeAttributedTextView {
    
    func update(view: AttributedTextView) {
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
        self.customDelegate = view
    }
    
    func update(text: NSAttributedString, alignment: TextAlignment?) {
        self.attributedStringValue = text
        if let alignment = alignment {
            self.alignment = alignment.nsTextAlignment
        }
    }
    
    func update(alignment: TextAlignment?) {
        if let alignment = alignment {
            self.alignment = alignment.nsTextAlignment
        }
    }
    
    func update(lineBreak: TextLineBreak) {
        self.lineBreakMode = lineBreak.nsLineBreakMode
    }
    
    func update(numberOfLines: UInt) {
        self.maximumNumberOfLines = Int(numberOfLines)
    }
    
    func cleanup() {
        self.customDelegate = nil
        self._view = nil
    }
    
}

#endif
