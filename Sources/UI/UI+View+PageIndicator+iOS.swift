//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.PageIndicator {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.PageIndicator
        typealias Content = KKPageIndicatorView

        static var reuseIdentificator: String {
            return "UI.View.PageIndicator"
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
    
    func update(view: UI.View.PageIndicator) {
        self.update(currentPage: view.currentPage)
        self.update(numberOfPages: view.numberOfPages)
        self.update(pageColor: view.pageColor)
        self.update(currentPageColor: view.currentPageColor)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.kkDelegate = view
    }
    
    func update(currentPage: Float) {
        self.currentPage = Int(currentPage)
    }
    
    func update(numberOfPages: UInt) {
        self.numberOfPages = Int(numberOfPages)
        self.setNeedsLayout()
    }
    
    func update(pageColor: UI.Color?) {
        self.pageIndicatorTintColor = pageColor?.native
    }
    
    func update(currentPageColor: UI.Color?) {
        self.currentPageIndicatorTintColor = currentPageColor?.native
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Float) {
        self.alpha = CGFloat(alpha)
    }
    
    func cleanup() {
        self.kkDelegate = nil
    }
    
}

private extension KKPageIndicatorView {
    
    @objc
    func _changed(_ sender: Any) {
        self.kkDelegate?.changed(self, currentPage: Float(self.currentPage))
    }
    
}

#endif
