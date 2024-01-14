//
//  KindKit
//

#if os(iOS)

import UIKit
import KindGraphics
import KindMath

extension PagingView {
    
    struct Reusable : IReusable {
        
        typealias Owner = PagingView
        typealias Content = KKPagingView

        static var reuseIdentificator: String {
            return "PagingView"
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
    var kkContentView: UIView!
    var kkLayoutManager: LayoutManager!
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
                    self.setNeedsLayout()
                }
            }
        }
        get { super.frame }
    }
    override var contentSize: CGSize {
        set {
            guard super.contentSize != newValue else { return }
            self.kkContentView.frame = CGRect(origin: .zero, size: newValue)
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
        
        self.kkLayoutManager = .init(
            delegate: self,
            view: self.kkContentView
        )
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
        
        do {
            self.kkLayoutManager.visibleFrame = .init(self.bounds)
            if #available(iOS 11.0, *) {
                self.kkLayoutManager.preloadInsets = .init(self.safeAreaInsets)
            }
            self.kkLayoutManager.updateIfNeeded()
        }
        do {
            let viewportSize = Size(self.bounds.size)
            let contentInset = self.contentInset
            let contentSize = self.kkLayoutManager.size
            self.contentSize = contentSize.cgSize
            let numberOfPages = Self._numberOfPages(
                viewportSize: viewportSize,
                contentInset: contentInset,
                contentSize: contentSize
            )
            self.kkDelegate?.update(self, numberOfPages: numberOfPages, contentSize: contentSize)
            if let page = self.kkRevalidatePage {
                self.kkRevalidatePage = nil
                UIView.performWithoutAnimation({
                    self.contentOffset = Self._contentOffset(
                        currentPage: page,
                        viewportSize: viewportSize,
                        contentInset: contentInset,
                        contentSize: contentSize
                    )
                })
            }
        }
    }
    
}

extension KKPagingView {
    
    func update(view: PagingView) {
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
    
    func update(transform: Transform) {
        self.layer.setAffineTransform(transform.matrix.cgAffineTransform)
    }
    
    func update(direction: PagingView.Direction) {
        switch direction {
        case .horizontal(let bounds):
            self.alwaysBounceHorizontal = bounds
            self.alwaysBounceVertical = false
        case .vertical(let bounds):
            self.alwaysBounceHorizontal = false
            self.alwaysBounceVertical = bounds
        }
    }
    
    func update(content: ILayout?) {
        self.kkLayoutManager.layout = content
        self.setNeedsLayout()
    }
    
    func update(contentSize: Size) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(contentInset: Inset) {
        self.contentInset = contentInset.uiEdgeInsets
    }
    
    func update(visibleInset: Inset) {
        self.kkLayoutManager.preloadInsets = visibleInset
    }
    
    func update(direction: PagingView.Direction, currentPage: Double, numberOfPages: UInt) {
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
    
    func update(color: Color?) {
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
        direction: PagingView.Direction,
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

extension KKPagingView : ILayoutDelegate {
    
    func setNeedUpdate(_ appearedLayout: ILayout) -> Bool {
        guard let delegate = self.kkDelegate else { return false }
        defer {
            self.setNeedsLayout()
        }
        guard delegate.isDynamic(self) == true else {
            self.kkLayoutManager.setNeed(layout: true)
            return false
        }
        self.kkLayoutManager.setNeed(layout: true)
        return true
    }
    
    func updateIfNeeded(_ appearedLayout: ILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
