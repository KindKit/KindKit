//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension ControlView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ControlView
        typealias Content = KKControlView
        
        static func name(owner: Owner) -> String {
            return "ControlView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
        }
        
    }
    
}

final class KKControlView : NSView {
    
    weak var kkDelegate: KKControlViewDelegate?
    
    var kkTrackingArea: NSTrackingArea!
    var kkIsEnabled: Bool = true
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        self.kkTrackingArea = NSTrackingArea(
            rect: self.bounds,
            options: [ .enabledDuringMouseDrag, .mouseMoved, .inVisibleRect, .activeInKeyWindow ],
            owner: self
        )
        self.addTrackingArea(self.kkTrackingArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isMousePoint(_ point: NSPoint, in rect: NSRect) -> Bool {
        guard self.kkIsEnabled == true else { return false }
        return super.isMousePoint(point, in: rect)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }

    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }
    
    override func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }
    
    override func otherMouseDown(with event: NSEvent) {
        super.otherMouseDown(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }

    override func otherMouseUp(with event: NSEvent) {
        super.otherMouseUp(with: event)
        self.kkDelegate?.kk_update(mouse: .with(event))
    }
    
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
    }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        self.kkDelegate?.kk_update(keyboard: .with(event))
    }

    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        self.kkDelegate?.kk_update(keyboard: .with(event))
    }

    override func flagsChanged(with event: NSEvent) {
        super.flagsChanged(with: event)
        self.kkDelegate?.kk_update(keyboard: .with(event))
    }
    
}

extension KKControlView {
    
    final func kk_update< LayoutType : ILayout >(view: ControlView< LayoutType >) {
        self.kk_update(frame: view.frame)
        self.kk_update(editing: view.isEditing)
        self.kk_update(enabled: view.isEnabled)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
        view.holder = LayoutHolder(self)
    }
    
    final func kk_cleanup< LayoutType : ILayout >(view: ControlView< LayoutType >) {
        view.holder = nil
        self.kkDelegate = nil
    }
    
}

extension KKControlView {
    
    final func kk_update(editing: Bool) {
        if editing == true {
            self.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
    }
    
    final func kk_update(enabled: Bool) {
        self.kkIsEnabled = enabled
    }
    
    final func kk_update(color: Color) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color.native.cgColor
    }
    
    final func kk_update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
}

#endif
