//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension ExternalView {
    
    struct Reusable : IReusable {
        
        typealias Owner = ExternalView
        typealias Content = KKExternalView

        static var reuseIdentificator: String {
            return "ExternalView"
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

final class KKExternalView : UIView {
    
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

extension KKExternalView {
    
    func update(view: ExternalView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(content: view.content)
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(content: UIView?) {
        self.kkContent = content
    }
    
    func cleanup() {
        self.kkContent = nil
    }
    
}

#endif
