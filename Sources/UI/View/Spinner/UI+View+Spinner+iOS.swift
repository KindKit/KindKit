//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Spinner {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Spinner
        typealias Content = KKSpinnerView

        static var reuseIdentificator: String {
            return "UI.View.Spinner"
        }
        
        static func createReuse(owner: Owner) -> Content {
            return Content()
        }
        
        static func configureReuse(owner: Owner, content: Content) {
            content.update(view: owner)
        }
        
        static func cleanupReuse(content: Content) {
            content.cleanup()
        }
        
    }
    
}

final class KKSpinnerView : UIView {
    
    private var _activityView: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        if #available(iOS 13.0, *) {
            self._activityView = UIActivityIndicatorView(style: .large)
        } else {
            self._activityView = UIActivityIndicatorView(style: .whiteLarge)
        }
        self._activityView.hidesWhenStopped = true
        self._activityView.color = .red
        
        super.init(frame: frame)
        
        self.addSubview(self._activityView)

        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewSize = self.bounds.size
        let viewMinSize = min(viewSize.width, viewSize.height)
        if viewMinSize > .leastNonzeroMagnitude {
            let activitySize = self._activityView.intrinsicContentSize
            let activityMinSize = min(activitySize.width, activitySize.height)
            if activityMinSize > .leastNonzeroMagnitude {
                let scale = viewMinSize / activityMinSize
                self._activityView.transform = CGAffineTransform(
                    scaleX: scale,
                    y: scale
                )
            }
        }
        self._activityView.center = CGPoint(
            x: viewSize.width / 2,
            y: viewSize.height / 2
        )
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            self._activityView.startAnimating()
        } else {
            self._activityView.stopAnimating()
        }
    }
    
}

extension KKSpinnerView {
    
    func update(view: UI.View.Spinner) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(activityColor: view.activityColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(activityColor: UI.Color?) {
        self._activityView.color = activityColor?.native
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
    }
    
}

#endif
