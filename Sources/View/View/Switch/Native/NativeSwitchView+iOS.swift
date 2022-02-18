//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension SwitchView {
    
    struct Reusable : IReusable {
        
        typealias Owner = SwitchView
        typealias Content = NativeSwitchView

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

final class NativeSwitchView : UIView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: SwitchViewDelegate?
    
    private unowned var _view: View?
    private var _switch: UISwitch!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self._switch = UISwitch()
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

extension NativeSwitchView {
    
    func update(view: SwitchView) {
        self._view = view
        self.update(thumbColor: view.thumbColor)
        self.update(offColor: view.offColor)
        self.update(onColor: view.onColor)
        self.update(value: view.value)
        self.update(locked: view.isLocked)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(thumbColor: Color) {
        self._switch.thumbTintColor = thumbColor.native
    }
    
    func update(offColor: Color) {
        self._switch.tintColor = offColor.native
    }
    
    func update(onColor: Color) {
        self._switch.onTintColor = onColor.native
    }
    
    func update(value: Bool) {
        self._switch.isOn = value
    }
    
    func cleanup() {
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativeSwitchView {
    
    @objc
    func _changed(_ sender: Any) {
        self.customDelegate?.changed(value: self._switch.isOn)
    }
    
}

#endif
