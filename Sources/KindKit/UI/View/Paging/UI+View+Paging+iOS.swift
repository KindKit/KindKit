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
    var kkNeedLayoutContent: Bool = true {
        didSet {
            if self.kkNeedLayoutContent == true {
                self.setNeedsLayout()
            }
        }
    }
    var kkContentView: UIView!
    var kkLayoutManager: UI.Layout.Manager!
    var kkVisibleInset: Inset = .zero {
        didSet {
            guard self.kkVisibleInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    var kkRevalidatePage: Double?
    
    override var frame: CGRect {
        set {
            let oldValue = super.frame
            if oldValue != newValue {
                let oldContentOffset = self.contentOffset
                let oldContentInset = self.contentInset
                let oldContentSize = self.contentSize
                super.frame = newValue
                if oldValue.size != newValue.size {
                    if self.kkRevalidatePage == nil {
                        self.kkRevalidatePage = Self._currentPage(
                            viewportSize: oldValue.size,
                            contentOffset: oldContentOffset,
                            contentInset: oldContentInset,
                            contentSize: oldContentSize
                        )
                    }
                    self.kkNeedLayoutContent = true
                }
            }
        }
        get { super.frame }
    }
    override var contentSize: CGSize {
        set {
            guard super.contentSize != newValue else { return }
            self.kkContentView.frame = CGRect(origin: CGPoint.zero, size: newValue)
            super.contentSize = newValue
            self.setNeedsLayout()
        }
        get { super.contentSize }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentInsetAdjustmentBehavior = .never
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.clipsToBounds = true
        self.delegate = self
        
        self.kkContentView = UIView(frame: .zero)
        self.addSubview(self.kkContentView)
        
        self.kkLayoutManager = UI.Layout.Manager(contentView: self.kkContentView, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview superview: UIView?) {
        super.willMove(toSuperview: superview)
        
        if superview == nil {
            self.kkLayoutManager.clear()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.kkNeedLayoutContent == true {
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
            let contentInset = self.contentInset
            self.kkLayoutManager.layout(bounds: layoutBounds)
            let size = self.kkLayoutManager.size
            self.contentSize = size.cgSize
            let numberOfPages = Self._numberOfPages(
                viewportSize: bounds.size,
                contentInset: contentInset,
                contentSize: size
            )
            self.kkDelegate?.update(self, numberOfPages: numberOfPages, contentSize: size)
            if let page = self.kkRevalidatePage {
                UIView.performWithoutAnimation({
                    self.contentOffset = Self._contentOffset(
                        currentPage: page,
                        viewportSize: bounds.size,
                        contentInset: contentInset,
                        contentSize: size
                    )
                })
                self.kkRevalidatePage = nil
            }
            self.kkNeedLayoutContent = false
        }
        self.kkLayoutManager.visible(
            bounds: Rect(self.bounds),
            inset: self.kkVisibleInset
        )
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
        self.kkNeedLayoutContent = true
    }
    
    func update(content: IUILayout?) {
        self.kkLayoutManager.layout = content
        self.kkNeedLayoutContent = true
    }
    
    func update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentInset: Inset) {
        self.contentInset = contentInset.uiEdgeInsets
    }
    
    func update(visibleInset: Inset) {
        self.kkVisibleInset = visibleInset
    }
    
    func update(direction: UI.View.Paging.Direction, currentPage: Double, numberOfPages: UInt) {
        if self.superview == nil {
            self.kkRevalidatePage = currentPage
        } else {
            self.contentOffset = Self._contentOffset(
                direction: direction,
                currentPage: currentPage,
                numberOfPages: numberOfPages,
                contentInset: self.contentInset,
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
        self.kkLayoutManager.layout = nil
        self.kkRevalidatePage = nil
        self.kkDelegate = nil
    }
    
}

private extension KKPagingView {
    
    static func _contentOffset(
        direction: UI.View.Paging.Direction,
        currentPage: Double,
        numberOfPages: UInt,
        contentInset: UIEdgeInsets,
        contentSize: CGSize
    ) -> CGPoint {
        if currentPage > .leastNonzeroMagnitude {
            switch direction {
            case .horizontal:
                let s = contentSize.width
                if s > .leastNonzeroMagnitude {
                    let p = s / CGFloat(numberOfPages)
                    return CGPoint(
                        x: -contentInset.left + (p * CGFloat(currentPage)),
                        y: -contentInset.top
                    )
                }
            case .vertical:
                let s = contentSize.height
                if s > .leastNonzeroMagnitude {
                    let p = s / CGFloat(numberOfPages)
                    return CGPoint(
                        x: -contentInset.left,
                        y: -contentInset.top + (p * CGFloat(currentPage))
                    )
                }
            }
        }
        return CGPoint(
            x: -contentInset.left,
            y: -contentInset.top
        )
    }
    
    static func _contentOffset(
        currentPage: Double,
        viewportSize: Size,
        contentInset: UIEdgeInsets,
        contentSize: Size
    ) -> CGPoint {
        if currentPage > .leastNonzeroMagnitude {
            if contentSize.width > viewportSize.width {
                let s = contentSize.width
                if s > .leastNonzeroMagnitude {
                    let p = s / (contentSize.width / viewportSize.width)
                    return CGPoint(
                        x: -contentInset.left + (CGFloat(p * currentPage)),
                        y: -contentInset.top
                    )
                }
            } else if contentSize.height > viewportSize.height {
                let s = contentSize.height
                if s > .leastNonzeroMagnitude {
                    let p = s / (contentSize.height / viewportSize.height)
                    return CGPoint(
                        x: -contentInset.left,
                        y: -contentInset.top + (CGFloat(p * currentPage))
                    )
                }
            }
        }
        return CGPoint(
            x: -contentInset.left,
            y: -contentInset.top
        )
    }
    
    static func _currentPage(
        viewportSize: CGSize,
        contentOffset: CGPoint,
        contentInset: UIEdgeInsets,
        contentSize: CGSize
    ) -> Double {
        if contentSize.width > viewportSize.width {
            return Double((-contentInset.left + contentOffset.x) / viewportSize.width)
        } else if contentSize.height > viewportSize.height {
            return Double((-contentInset.top + contentOffset.y) / viewportSize.height)
        }
        return 0
    }
    
    static func _numberOfPages(
        viewportSize: Size,
        contentInset: UIEdgeInsets,
        contentSize: Size
    ) -> UInt {
        if contentSize.width > viewportSize.width {
            return UInt(contentSize.width / viewportSize.width)
        } else if contentSize.height > viewportSize.height {
            return UInt(contentSize.height / viewportSize.height)
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
            contentInset: self.contentInset,
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
        self.kkNeedLayoutContent = true
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
