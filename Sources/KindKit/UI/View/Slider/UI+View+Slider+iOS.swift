//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Slider {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Slider
        typealias Content = KKSliderView

        static var reuseIdentificator: String {
            return "UI.View.Slider"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content(frame: .zero)
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.kk_cleanup()
        }
        
    }
    
}

final class KKSliderView : UISlider {
    
    weak var kkDelegate: KKSliderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(self._handleBeginEditing(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(self._handleEditing(_:)), for: .valueChanged)
        self.addTarget(self, action: #selector(self._handleEndEditing(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(self._handleEndEditing(_:)), for: .touchUpOutside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let bounds = CGRectInset(self.bounds, -10, -15)
        return CGRectContainsPoint(bounds, point)
    }
    
}

extension KKSliderView {
    
    func kk_update(view: UI.View.Slider) {
        self.kk_update(frame: view.frame)
        self.kk_update(transform: view.transform)
        self.kk_update(value: view.value, limit: view.limit)
        self.kk_update(progressColor: view.progressColor)
        self.kk_update(trackColor: view.trackColor)
        self.kk_update(thumbColor: view.thumbColor)
        self.kk_update(thumbImage: view.thumbImage)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func kk_update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func kk_update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func kk_update(value: Double, limit: Range< Double >) {
        self.minimumValue = Float(limit.lowerBound)
        self.maximumValue = Float(limit.upperBound)
        self.value = Float(value)
    }
    
    func kk_update(progressColor: UI.Color?) {
        self.minimumTrackTintColor = progressColor?.native
    }
    
    func kk_update(trackColor: UI.Color?) {
        self.maximumTrackTintColor = trackColor?.native
    }
    
    func kk_update(thumbImage: UI.Image?) {
        self.setThumbImage(thumbImage?.native, for: .normal)
    }
    
    func kk_update(thumbColor: UI.Color?) {
        self.thumbTintColor = thumbColor?.native
    }
    
    func kk_update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func kk_cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKSliderView {
    
    @objc
    func _handleBeginEditing(_ sender: Any) {
        self.kkDelegate?.startEditing(self)
    }
    
    @objc
    func _handleEditing(_ sender: Any) {
        self.kkDelegate?.editing(self, value: Double(self.value))
    }
    
    @objc
    func _handleEndEditing(_ sender: Any) {
        self.kkDelegate?.endEditing(self)
    }
    
}

#endif
