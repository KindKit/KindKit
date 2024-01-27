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
        
        static func name(owner: Owner) -> String {
            return "ImageView"
        }
        
        static func create(owner: Owner) -> Content {
            return .init(frame: .zero)
        }
        
        static func configure(owner: Owner, content: Content) {
            content.kk_update(view: owner)
        }
        
        static func cleanup(owner: Owner, content: Content) {
            content.kk_cleanup(view: owner)
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
    
    final func kk_update(view: ImageView) {
        self.kk_update(frame: view.frame)
        self.kk_update(image: view.image)
        self.kk_update(mode: view.mode)
        self.kk_update(tintColor: view.tintColor)
        self.kk_update(color: view.color)
        self.kk_update(alpha: view.alpha)
    }
    
    final func kk_cleanup(view: ImageView) {
        self.image = nil
    }
    
}

extension KKImageView {
    
    final func kk_update(image: Image?) {
        self.image = image?.native
    }
    
    final func kk_update(mode: ImageMode) {
        switch mode {
        case .origin: self.contentMode = .center
        case .aspectFit: self.contentMode = .scaleAspectFit
        case .aspectFill: self.contentMode = .scaleAspectFill
        }
    }
    
    final func kk_update(tintColor: Color?) {
        self.tintColor = tintColor?.native
    }
    
    final func kk_update(color: Color) {
        self.backgroundColor = color.native
    }
    
    final func kk_update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
}

#endif
