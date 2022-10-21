//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.AnimatedImage {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.AnimatedImage
        typealias Content = KKAnimatedImageView

        static var reuseIdentificator: String {
            return "UI.View.AnimatedImage"
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

final class KKAnimatedImageView : UIImageView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimating() {
        super.startAnimating()
        if self.animationRepeatCount > 0 {
            self.image = self.animationImages?.last
        }
    }
    
}

extension KKAnimatedImageView {
    
    func update(view: UI.View.AnimatedImage) {
        self.update(images: view.images)
        self.update(duration: view.duration)
        self.update(repeat: view.repeat)
        self.update(mode: view.mode)
        self.update(tintColor: view.tintColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(images: [UI.Image]) {
        self.animationImages = images.map({ $0.native })
        self.image = self.animationImages?.first
    }
    
    func update(duration: TimeInterval) {
        self.animationDuration = duration
    }
    
    func update(repeat: UI.View.AnimatedImage.Repeat) {
        switch `repeat` {
        case .loops(let count): self.animationRepeatCount = count
        case .infinity: self.animationRepeatCount = 0
        }
    }
    
    func update(mode: UI.View.AnimatedImage.Mode) {
        switch mode {
        case .origin: self.contentMode = .center
        case .aspectFit: self.contentMode = .scaleAspectFit
        case .aspectFill: self.contentMode = .scaleAspectFill
        }
    }
    
    func update(tintColor: UI.Color?) {
        self.tintColor = tintColor?.native
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Float) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.stopAnimating()
    }
    
}

#endif
