//
//  KindKit
//

#if os(macOS)

import AppKit
import KindGraphics
import KindMath

extension SwitchView {
    
    struct Reusable : IReusable {
        
        typealias Owner = SwitchView
        typealias Content = KKSwitchView

        static var reuseIdentificator: String {
            return "SwitchView"
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

final class KKSwitchView : NSView {
    
    weak var kkDelegate: KKSwitchViewDelegate?
    let kkSwitch: NSSwitch
    
    override var isFlipped: Bool {
        return true
    }
    
    override init(frame: NSRect) {
        self.kkSwitch = NSSwitch()
        
        super.init(frame: frame)
        
        self.wantsLayer = true
        
        self.kkSwitch.target = self
        self.kkSwitch.action = #selector(self._changed(_:))
        self.addSubview(self.kkSwitch)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        
        let bounds = self.bounds
        let switchSize = self.kkSwitch.sizeThatFits(bounds.size)
        self.kkSwitch.frame = CGRect(
            x: bounds.midX - (switchSize.width / 2),
            y: bounds.midY - (switchSize.height / 2),
            width: switchSize.width,
            height: switchSize.height
        )
    }
    
}

extension KKSwitchView {
    
    func update(view: SwitchView) {
        self.update(frame: view.frame)
        self.update(value: view.value)
        self.update(thumbColor: view.thumbColor)
        self.update(offColor: view.offColor)
        self.update(onColor: view.onColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(value: Bool) {
        self.kkSwitch.state = value == true ? .on : .off
    }
    
    func update(thumbColor: Color?) {
        // self.kkSwitch.thumbTintColor = thumbColor?.native
    }
    
    func update(offColor: Color?) {
        // self.kkSwitch.tintColor = offColor?.native
    }
    
    func update(onColor: Color?) {
        // self.kkSwitch.onTintColor = onColor?.native
    }
    
    func update(color: Color?) {
        guard let layer = self.layer else { return }
        layer.backgroundColor = color?.native.cgColor
    }
    
    func update(alpha: Double) {
        self.alphaValue = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.kkSwitch.isEnabled = locked == false
    }
    
    func cleanup() {
    }
    
}

private extension KKSwitchView {
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.changed(self, value: self.kkSwitch.state == .on)
    }
    
}

#endif
