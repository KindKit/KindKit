//
//  KindKit
//

#if os(iOS)

import UIKit

extension UI.View.Paging {
    
    struct Reusable : IUIReusable {
        
        typealias Owner = UI.View.Paging
        typealias Content = KKPagingView

        static var reuseIdentificator: String {
            return "UI.View.Paging"
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

final class KKPagingView : UIScrollView {
    
    weak var kkDelegate: KKPagingViewDelegate?
    var needLayoutContent: Bool = true {
        didSet {
            if self.needLayoutContent == true {
                self.setNeedsLayout()
            }
        }
    }
    override var frame: CGRect {
        set {
            let oldValue = super.frame
            if oldValue != newValue {
                let oldContentOffset = self.contentOffset
                let oldContentSize = self.contentSize
                super.frame = newValue
                if oldValue.size != newValue.size {
                    if self._revalidatePage == nil {
                        self._revalidatePage = Self._currentPage(
                            viewportSize: oldValue.size,
                            contentOffset: oldContentOffset,
                            contentSize: oldContentSize
                        )
                    }
                    self.needLayoutContent = true
                }
            }
        }
        get { super.frame }
    }
    override var contentSize: CGSize {
        set {
            guard super.contentSize != newValue else { return }
            self._contentView.frame = CGRect(origin: CGPoint.zero, size: newValue)
            super.contentSize = newValue
            self.setNeedsLayout()
        }
        get { super.contentSize }
    }
    
    private var _contentView: UIView!
    private var _layoutManager: UI.Layout.Manager!
    private var _visibleInset: Inset = .zero {
        didSet {
            guard self._visibleInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    private var _revalidatePage: Double?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentInsetAdjustmentBehavior = .never
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.clipsToBounds = true
        self.delegate = self
        
        self._contentView = UIView(frame: .zero)
        self.addSubview(self._contentView)
        
        self._layoutManager = UI.Layout.Manager(contentView: self._contentView, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self._layoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        do {
            if self.needLayoutContent == true {
                self.needLayoutContent = false
                
                let bounds = Rect(self.bounds)
                let layoutBounds: Rect
                if #available(iOS 11.0, *) {
                    layoutBounds = .init(
                    	origin: .zero,
                    	size: bounds.size.inset(self.adjustedContentInset)
                	)
                } else {
                    layoutBounds = .init(
                    	origin: .zero,
                    	size: bounds.size
                	)
                }
                self._layoutManager.layout(bounds: layoutBounds)
                let size = self._layoutManager.size
                self.contentSize = size.cgSize
                self.kkDelegate?.update(self, numberOfPages: Self._numberOfPages(bounds: bounds, contentSize: size), contentSize: size)
                if let page = self._revalidatePage {
                    UIView.performWithoutAnimation({
                        self.contentOffset = Self._contentOffset(
                            currentPage: page,
                            viewportSize: bounds.size,
                            contentSize: size
                        )
                    })
                    self._revalidatePage = nil
                }
            }
            self._layoutManager.visible(
                bounds: Rect(self.bounds),
                inset: self._visibleInset
            )
        }
    }
    
}

extension KKPagingView {
    
    func update(view: UI.View.Paging) {
        self.update(frame: view.frame)
        self.update(transform: view.transform)
        self.update(direction: view.direction)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(direction: view.direction, currentPage: view.currentPage, numberOfPages: view.numberOfPages)
        self.update(content: view.content)
        self.update(color: view.color)
        self.update(alpha: view.alpha)
        self.update(locked: view.isLocked)
        self.kkDelegate = view
    }
    
    func update(frame: Rect) {
        self.frame = frame.cgRect
    }
    
    func update(transform: UI.Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(direction: UI.View.Paging.Direction) {
        switch direction {
        case .horizontal(let bounds):
            self.alwaysBounceHorizontal = bounds
            self.alwaysBounceVertical = false
        case .vertical(let bounds):
            self.alwaysBounceHorizontal = false
            self.alwaysBounceVertical = bounds
        }
        self.needLayoutContent = true
    }
    
    func update(content: IUILayout?) {
        self._layoutManager.layout = content
        self.needLayoutContent = true
    }
    
    func update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentInset: Inset) {
        self.contentInset = contentInset.uiEdgeInsets
    }
    
    func update(visibleInset: Inset) {
        self._visibleInset = visibleInset
    }
    
    func update(direction: UI.View.Paging.Direction, currentPage: Double, numberOfPages: UInt) {
        if self.superview == nil {
            self._revalidatePage = currentPage
        } else {
            self.contentOffset = Self._contentOffset(
                direction: direction,
                currentPage: currentPage,
                numberOfPages: numberOfPages,
                contentSize: self.contentSize
            )
        }
    }
    
    func update(color: UI.Color?) {
        self.backgroundColor = color?.native
    }
    
    func update(alpha: Double) {
        self.alpha = CGFloat(alpha)
    }
    
    func update(locked: Bool) {
        self.isScrollEnabled = locked == false
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self._revalidatePage = nil
        self.kkDelegate = nil
    }
    
}

private extension KKPagingView {
    
    static func _contentOffset(
        direction: UI.View.Paging.Direction,
        currentPage: Double,
        numberOfPages: UInt,
        contentSize: CGSize
    ) -> CGPoint {
        if currentPage > .leastNonzeroMagnitude {
            switch direction {
            case .horizontal:
                let s = contentSize.width
                if s > .leastNonzeroMagnitude {
                    let p = s / CGFloat(numberOfPages)
                    return CGPoint(x: p * CGFloat(currentPage), y: 0)
                }
            case .vertical:
                let s = contentSize.height
                if s > .leastNonzeroMagnitude {
                    let p = s / CGFloat(numberOfPages)
                    return CGPoint(x: 0, y: p * CGFloat(currentPage))
                }
            }
        }
        return .zero
    }
    
    static func _contentOffset(
        currentPage: Double,
        viewportSize: Size,
        contentSize: Size
    ) -> CGPoint {
        if currentPage > .leastNonzeroMagnitude {
            if contentSize.width > viewportSize.width {
                let s = contentSize.width
                if s > .leastNonzeroMagnitude {
                    let p = s / (contentSize.width / viewportSize.width)
                    return CGPoint(x: CGFloat(p * currentPage), y: 0)
                }
            } else if contentSize.height > viewportSize.height {
                let s = contentSize.height
                if s > .leastNonzeroMagnitude {
                    let p = s / (contentSize.height / viewportSize.height)
                    return CGPoint(x: 0, y: CGFloat(p * currentPage))
                }
            }
        }
        return .zero
    }
    
    static func _currentPage(
        viewportSize: CGSize,
        contentOffset: CGPoint,
        contentSize: CGSize
    ) -> Double {
        if contentSize.width > viewportSize.width {
            return Double(contentOffset.x / viewportSize.width)
        } else if contentSize.height > viewportSize.height {
            return Double(contentOffset.y / viewportSize.height)
        }
        return 0
    }
    
    static func _numberOfPages(
        bounds: Rect,
        contentSize: Size
    ) -> UInt {
        if contentSize.width > bounds.width {
            return UInt(contentSize.width / bounds.width)
        } else if contentSize.height > bounds.height {
            return UInt(contentSize.height / bounds.height)
        }
        return 1
    }
    
}

extension KKPagingView : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.kkDelegate?.beginDragging(self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Self._currentPage(
            viewportSize: self.bounds.size,
            contentOffset: self.contentOffset,
            contentSize: self.contentSize
        )
        self.kkDelegate?.dragging(self, currentPage: currentPage)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.kkDelegate?.endDragging(self, decelerate: decelerate)
        if decelerate == false {
            self.setNeedsLayout()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.kkDelegate?.beginDecelerating(self)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.kkDelegate?.endDecelerating(self)
        self.setNeedsLayout()
    }
    
}

extension KKPagingView : IUILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: IUILayout) -> Bool {
        self.needLayoutContent = true
        self.setNeedsLayout()
        if let kkDelegate = self.kkDelegate {
            return kkDelegate.isDynamicSize(self)
        }
        return false
    }
    
    func updateIfNeeded(_ appearedLayout: IUILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
