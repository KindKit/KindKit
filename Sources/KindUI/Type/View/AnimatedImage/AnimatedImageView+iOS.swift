//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension AnimatedImageView {
    
    struct Reusable : IReusable {
        
        typealias Owner = AnimatedImageView
        typealias Content = KKAnimatedImageView

        static var reuseIdentificator: String {
            return "AnimatedImageView"
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

final class KKAnimatedImageView : UIImageView {
    
    var kkIsAnimating: Bool {
        return self.isAnimating
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKAnimatedImageView {
    
    func kk_update(view: AnimatedImageView) {
        self.kk_update(frame: view.frame)
        self.kk_update(transform: view.transform)
        self.kk_update(images: view.images)
        self.kk_update(duration: view.duration)
        self.kk_update(repeat: view.repeat)
        self.kk_update(mode: view.mode)
        self.kk_update(tintColor: view.tintColor)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    func kk_update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func kk_update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func kk_update(images: [Image]) {
        self.animationImages = images.map({ $0.native })
        self.image = self.animationImages?.first
    }
    
    func kk_update(duration: TimeInterval) {
        self.animationDuration = duration
    }
    
    func kk_update(repeat: AnimatedImageView.Repeat) {
        switch `repeat` {
        case .loops(let count): self.animationRepeatCount = count
        case .infinity: self.animationRepeatCount = 0
        }
    }
    
    func kk_update(mode: AnimatedImageView.Mode) {
        switch mode {
        case .origin: self.contentMode = .center
        case .aspectFit: self.contentMode = .scaleAspectFit
        case .aspectFill: self.contentMode = .scaleAspectFill
        }
    }
    
    func kk_update(tintColor: Color?) {
        self.tintColor = tintColor?.native
    }
    
    func kk_update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func kk_start() {
        self.startAnimating()
        if self.animationRepeatCount > 0 {
            self.image = self.animationImages?.last
        }
    }
    
    func kk_stop() {
        self.stopAnimating()
    }
    
    func kk_cleanup() {
        self.stopAnimating()
        self.animationImages = []
        self.image = nil
    }
    
}

#endif
