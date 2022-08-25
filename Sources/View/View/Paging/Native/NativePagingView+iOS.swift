//
//  KindKitView
//

#if os(iOS)

import UIKit
import KindKitCore
import KindKitMath

extension PagingView {
    
    struct Reusable : IReusable {
        
        typealias Owner = PagingView
        typealias Content = NativePagingView

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

final class NativePagingView : UIScrollView {
    
    typealias View = IView & IViewCornerRadiusable & IViewShadowable
    
    unowned var customDelegate: PagingViewDelegate?
    var needLayoutContent: Bool {
        didSet(oldValue) {
            if self.needLayoutContent == true {
                self.setNeedsLayout()
            }
        }
    }
    override var frame: CGRect {
        set(value) {
            let oldValue = super.frame
            if oldValue != value {
                super.frame = value
                if let view = self._view {
                    self.update(cornerRadius: view.cornerRadius)
                    self.updateShadowPath()
                }
                if oldValue.size != value.size {
                    self.needLayoutContent = true
                }
            }
        }
        get { return super.frame }
    }
    override var contentSize: CGSize {
        set(value) {
            if super.contentSize != value {
                self._contentView.frame = CGRect(origin: CGPoint.zero, size: value)
                super.contentSize = value
                self.setNeedsLayout()
            }
        }
        get { return super.contentSize }
    }
    
    private unowned var _view: View?
    private var _contentView: UIView!
    private var _layoutManager: LayoutManager!
    private var _visibleInset: InsetFloat {
        didSet(oldValue) {
            guard self._visibleInset != oldValue else { return }
            self.setNeedsLayout()
        }
    }
    private var _isLayout: Bool
    
    override init(frame: CGRect) {
        self.needLayoutContent = true
        self._visibleInset = .zero
        self._isLayout = false
        
        super.init(frame: frame)

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.clipsToBounds = true
        self.delegate = self
        
        self._contentView = UIView(frame: .zero)
        self.addSubview(self._contentView)
        
        self._layoutManager = LayoutManager(contentView: self._contentView, delegate: self)
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
        
        self._safeLayout({
            let bounds = RectFloat(self.bounds)
            if self.needLayoutContent == true {
                self.needLayoutContent = false
                
                let layoutBounds: RectFloat
                if #available(iOS 11.0, *) {
                    let inset = InsetFloat(self.adjustedContentInset)
                    layoutBounds = RectFloat(
                        origin: .zero,
                        size: bounds.size.inset(inset)
                    )
                } else {
                    layoutBounds = RectFloat(
                        origin: .zero,
                        size: bounds.size
                    )
                }
                self._layoutManager.layout(bounds: layoutBounds)
                let size = self._layoutManager.size
                self.contentSize = size.cgSize
                self.customDelegate?._update(
                    numberOfPages: self._numberOfPages(
                        bounds: bounds,
                        contentSize: size
                    ),
                    contentSize: size
                )
            }
            self._layoutManager.visible(
                bounds: bounds,
                inset: self._visibleInset
            )
        })
    }
    
}

extension NativePagingView {
    
    func update< Layout : ILayout >(view: PagingView< Layout >) {
        self._view = view
        self.update(direction: view.direction)
        self.update(visibleInset: view.visibleInset)
        self.update(contentInset: view.contentInset)
        self.update(contentSize: view.contentSize)
        self.update(direction: view.direction, currentPage: view.currentPage, numberOfPages: view.numberOfPages)
        self.update(contentLayout: view.contentLayout)
        self.update(color: view.color)
        self.update(border: view.border)
        self.update(cornerRadius: view.cornerRadius)
        self.update(shadow: view.shadow)
        self.update(alpha: view.alpha)
        self.updateShadowPath()
        self.customDelegate = view
    }
    
    func update(contentLayout: ILayout) {
        self._layoutManager.layout = contentLayout
        self.needLayoutContent = true
    }
    
    func update(direction: PagingViewDirection) {
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
    
    func update(visibleInset: InsetFloat) {
        self._visibleInset = visibleInset
    }
    
    func update(contentInset: InsetFloat) {
        self.contentInset = contentInset.uiEdgeInsets
    }
    
    func update(contentSize: SizeFloat) {
        self.contentSize = contentSize.cgSize
    }
    
    func update(direction: PagingViewDirection, currentPage: Float, numberOfPages: UInt) {
        if currentPage > .leastNonzeroMagnitude {
            switch direction {
            case .horizontal:
                let s = self.contentSize.width
                if s > .leastNonzeroMagnitude {
                    let p = s / CGFloat(numberOfPages)
                    self.contentOffset = CGPoint(x: p * CGFloat(currentPage), y: 0)
                } else {
                    self.contentOffset = .zero
                }
            case .vertical:
                let s = self.contentSize.height
                if s > .leastNonzeroMagnitude {
                    let p = s / CGFloat(numberOfPages)
                    self.contentOffset = CGPoint(x: 0, y: p * CGFloat(currentPage))
                } else {
                    self.contentOffset = .zero
                }
            }
        } else {
            self.contentOffset = .zero
        }
    }
    
    func cleanup() {
        self._layoutManager.layout = nil
        self.customDelegate = nil
        self._view = nil
    }
    
}

private extension NativePagingView {
    
    func _currentPage() -> Float {
        let bounds = self.bounds
        let contentOffset = self.contentOffset
        let contentSize = self.contentSize
        if contentSize.width > bounds.width {
            return Float(contentOffset.x / bounds.width)
        } else if contentSize.height > bounds.height {
            return Float(contentOffset.y / bounds.height)
        }
        return 0
    }
    
    func _numberOfPages(bounds: RectFloat, contentSize: SizeFloat) -> UInt {
        if contentSize.width > bounds.width {
            return UInt(contentSize.width / bounds.width)
        } else if contentSize.height > bounds.height {
            return UInt(contentSize.height / bounds.height)
        }
        return 1
    }
    
    func _safeLayout(_ action: () -> Void) {
        if self._isLayout == false {
            self._isLayout = true
            action()
            self._isLayout = false
        }
    }
    
}

extension NativePagingView : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.customDelegate?._beginPaginging()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.customDelegate?._paginging(currentPage: self._currentPage())
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.customDelegate?._endPaginging(decelerate: decelerate)
        if decelerate == false {
            self.setNeedsLayout()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.customDelegate?._beginDecelerating()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.customDelegate?._endDecelerating()
        self.setNeedsLayout()
    }
    
}

extension NativePagingView : ILayoutDelegate {
    
    func setNeedUpdate(_ layout: ILayout) -> Bool {
        self.needLayoutContent = true
        self.setNeedsLayout()
        if let customDelegate = self.customDelegate {
            return customDelegate._isDynamicSize()
        }
        return false
    }
    
    func updateIfNeeded(_ layout: ILayout) {
        self.layoutIfNeeded()
    }
    
}

#endif
