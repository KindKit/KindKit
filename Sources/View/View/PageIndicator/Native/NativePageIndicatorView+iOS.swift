//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension PageIndicatorView {
    
    struct Reusable : IReusable {
        
        typealias Owner = PageIndicatorView
        typealias Content = NativePageIndicatorView

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

final class NativePageIndicatorView : UIView {
    
    unowned var customDelegate: PageIndicatorViewDelegate?
    
    private unowned var _view: PageIndicatorView?
    private var _pageControl: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        self._pageControl = UIPageControl()
        self._pageControl.addTarget(self, action: #selector(self._changed(_:)), for: .valueChanged)
        self.addSubview(self._pageControl)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let progressSize = self._pageControl.sizeThatFits(bounds.size)
        self._pageControl.frame = CGRect(
            x: bounds.midX - (progressSize.width / 2),
            y: bounds.midY - (progressSize.height / 2),
            width: progressSize.width,
            height: progressSize.height
        )
    }
    
}

extension NativePageIndicatorView {
    
    func update(view: PageIndicatorView) {
        self._view = view
        self.update(pageColor: view.pageColor)
        self.update(currentPageColor: view.currentPageColor)
        self.update(currentPage: view.currentPage)
        self.update(numberOfPages: view.numberOfPages)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(pageColor: Color) {
        self._pageControl.pageIndicatorTintColor = pageColor.native
    }
    
    func update(currentPageColor: Color) {
        self._pageControl.currentPageIndicatorTintColor = currentPageColor.native
    }
    
    func update(currentPage: Float) {
        self._pageControl.currentPage = Int(currentPage)
    }
    
    func update(numberOfPages: UInt) {
        self._pageControl.numberOfPages = Int(numberOfPages)
        self.setNeedsLayout()
    }
    
    func cleanup() {
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativePageIndicatorView {
    
    @objc
    func _changed(_ sender: Any) {
        self.customDelegate?.changed(
            currentPage: Float(self._pageControl.currentPage)
        )
    }
    
}

#endif
