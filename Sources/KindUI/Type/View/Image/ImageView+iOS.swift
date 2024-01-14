//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension ImageView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ImageView
        typealias Content = KKImageView

        static var reuseIdentificator: String {
            return "ImageView"
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

final class KKImageView : UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKImageView {
    
    func update(view: ImageView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(image: view.image)
        self.update(mode: view.mode)
        self.update(tintColor: view.tintColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(image: Image?) {
        self.image = image?.native
    }
    
    func update(mode: ImageView.Mode) {
        switch mode {
        case .origin: self.contentMode = .center
        case .aspectFit: self.contentMode = .scaleAspectFit
        case .aspectFill: self.contentMode = .scaleAspectFill
        }
    }
    
    func update(tintColor: Color?) {
        self.tintColor = tintColor?.native
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.image = nil
    }
    
}

#endif
