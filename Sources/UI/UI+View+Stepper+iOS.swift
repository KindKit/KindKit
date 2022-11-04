//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Stepper {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Stepper
        typealias Content = KKStepperView

        static var reuseIdentificator: String {
            return "UI.View.Stepper"
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

final class KKStepperView : UIView {
    
    weak var kkDelegate: KKStepperViewDelegate?
    
    private var _stepper: UIStepper!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self._stepper = UIStepper()
        self._stepper.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
        self.addSubview(self._stepper)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let switchSize = self._stepper.sizeThatFits(bounds.size)
        self._stepper.frame = CGRect(
            x: bounds.midX - (switchSize.width / 2),
            y: bounds.midY - (switchSize.height / 2),
            width: switchSize.width,
            height: switchSize.height
        )
    }
    
}

extension KKStepperView {
    
    func update(view: UI.View.Stepper) {
        self.update(minValue: view.minValue)
        self.update(maxValue: view.maxValue)
        self.update(stepValue: view.stepValue)
        self.update(value: view.value)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(isAutorepeat: view.isAutorepeat)
        self.update(isWraps: view.isWraps)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(minValue: Float) {
        self._stepper.minimumValue = Double(minValue)
    }
    
    func update(maxValue: Float) {
        self._stepper.maximumValue = Double(maxValue)
    }
    
    func update(stepValue: Float) {
        self._stepper.stepValue = Double(stepValue)
    }
    
    func update(value: Float) {
        self._stepper.value = Double(value)
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Float) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(isAutorepeat: Bool) {
        self._stepper.autorepeat = isAutorepeat
    }
    
    func update(isWraps: Bool) {
        self._stepper.wraps = isWraps
    }
    
    func update(locked: Bool) {
        self._stepper.isEnabled = locked == false
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKStepperView {
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.changed(self, value: Float(self._stepper.value))
    }
    
}

#endif
