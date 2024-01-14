//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension PageIndicatorView {
    
    struct Reusable : IReusable {
        
        typealias Owner = PageIndicatorView
        typealias Content = KKPageIndicatorView

        static var reuseIdentificator: String {
            return "PageIndicatorView"
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

final class KKPageIndicatorView : UIPageControl {
    
    weak var kkDelegate: KKPageIndicatorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KKPageIndicatorView {
    
    func update(view: PageIndicatorView) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(currentPage: view.currentPage)
        self.update(numberOfPages: view.numberOfPages)
        self.update(pageColor: view.pageColor)
        self.update(currentPageColor: view.currentPageColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(currentPage: Double) {
        self.currentPage = Int(currentPage)
    }
    
    func update(numberOfPages: UInt) {
        self.numberOfPages = Int(numberOfPages)
        self.setNeedsLayout()
    }
    
    func update(pageColor: Color?) {
        self.pageIndicatorTintColor = pageColor?.native
    }
    
    func update(currentPageColor: Color?) {
        self.currentPageIndicatorTintColor = currentPageColor?.native
    }
    
    func update(color: Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKPageIndicatorView {
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.changed(self, currentPage: Double(self.currentPage))
    }
    
}

#endif
