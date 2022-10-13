//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Switch {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Switch
        typealias Content = KKSwitchView

        static var reuseIdentificator: String {
            return "UI.View.Switch"
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

final class KKSwitchView : UIView {
    
    unowned var kkDelegate: KKSwitchViewDelegate?
    override var frame: CGRect {
        set {
            guard super.frame != newValue else { return }
            super.frame = newValue
            if let view = self._view {
                self.kk_update(cornerRadius: view.cornerRadius)
                self.kk_updateShadowPath()
            }
        }
        get { return super.frame }
    }
    
    private unowned var _view: UI.View.Switch?
    private var _switch: UISwitch
    
    override init(frame: CGRect) {
        self._switch = UISwitch()
        
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self._switch.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
        self.addSubview(self._switch)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let switchSize = self._switch.sizeThatFits(bounds.size)
        self._switch.frame = CGRect(
            x: bounds.midX - (switchSize.width / 2),
            y: bounds.midY - (switchSize.height / 2),
            width: switchSize.width,
            height: switchSize.height
        )
    }
    
}

extension KKSwitchView {
    
    func update(view: UI.View.Switch) {
        self._view = view
        self.update(thumbColor: view.thumbColor)
        self.update(offColor: view.offColor)
        self.update(onColor: view.onColor)
        self.update(value: view.value)
        self.update(locked: view.isLocked)
        self.kk_update(color: view.color)
        self.kk_update(border: view.border)
        self.kk_update(cornerRadius: view.cornerRadius)
        self.kk_update(shadow: view.shadow)
        self.kk_update(alpha: view.alpha)
        self.kk_updateShadowPath()
        self.kkDelegate = view
    }
    
    func update(locked: Bool) {
        self._switch.isEnabled = locked == false
    }
    
    func update(thumbColor: UI.Color?) {
        self._switch.thumbTintColor = thumbColor?.native
    }
    
    func update(offColor: UI.Color?) {
        self._switch.tintColor = offColor?.native
    }
    
    func update(onColor: UI.Color?) {
        self._switch.onTintColor = onColor?.native
    }
    
    func update(value: Bool) {
        self._switch.isOn = value
    }
    
    func cleanup() {
        self.kkDelegate = nil
        self._view = nil
    }
    
}

private extension KKSwitchView {
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.changed(self, value: self._switch.isOn)
    }
    
}

#endif
