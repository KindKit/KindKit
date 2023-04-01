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
    
    let kkStepper: UIStepper
    
    override init(frame: CGRect) {
        self.kkStepper = UIStepper()
        
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.kkStepper.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
        self.addSubview(self.kkStepper)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let switchSize = self.kkStepper.sizeThatFits(bounds.size)
        self.kkStepper.frame = CGRect(
            x: bounds.midX - (switchSize.width / 2),
            y: bounds.midY - (switchSize.height / 2),
            width: switchSize.width,
            height: switchSize.height
        )
    }
    
}

extension KKStepperView {
    
    func update(view: UI.View.Stepper) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
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
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(minValue: Double) {
        self.kkStepper.minimumValue = Double(minValue)
    }
    
    func update(maxValue: Double) {
        self.kkStepper.maximumValue = Double(maxValue)
    }
    
    func update(stepValue: Double) {
        self.kkStepper.stepValue = Double(stepValue)
    }
    
    func update(value: Double) {
        self.kkStepper.value = Double(value)
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(isAutorepeat: Bool) {
        self.kkStepper.autorepeat = isAutorepeat
    }
    
    func update(isWraps: Bool) {
        self.kkStepper.wraps = isWraps
    }
    
    func update(locked: Bool) {
        self.kkStepper.isEnabled = locked == false
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKStepperView {
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.changed(self, value: Double(self.kkStepper.value))
    }
    
}

#endif
