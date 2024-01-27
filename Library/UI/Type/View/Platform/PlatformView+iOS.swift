//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindGeometry

extension PlatformView {
    
    struct Reusable : IReusable {
        
        typealias Owner = PlatformView
        typealias Content = KKPlatformView
        
        static func name(owner: Owner) -> String {
            return "PlatformView"
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

final class KKPlatformView : UIView {
    
    var kkContent: UIView? {
        willSet {
            self.kkContent?.removeFromSuperview()
        }
        didSet {
            guard let content = self.kkContent else { return }
            content.frame = self.bounds
            self.addSubview(content)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let content = self.kkContent {
            content.frame = self.bounds
        }
    }
    
}

extension KKPlatformView {
    
    final func kk_update(view: PlatformView) {
        self.kk_update(frame: view.frame)
        self.kk_update(content: view.content)
    }
    
    final func kk_cleanup(view: PlatformView) {
        self.kkContent = nil
    }
    
}

extension KKPlatformView {
    
    final func kk_update(content: UIView?) {
        self.kkContent = content
    }
    
}

extension KKPlatformView {
    
    final func kk_sizeOf(_ available: CGSize) -> CGSize {
        guard let content = self.kkContent else { return .zero }
        return content.sizeThatFits(available)
    }
    
}

#endif
