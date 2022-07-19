//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class ExpandLayout< ContentView : IView, DetailView : IView > : ILayout {
    
    public unowned var delegate: ILayoutDelegate?
    public unowned var view: IView?
    public var contentInset: InsetFloat {
        didSet { self.setNeedForceUpdate() }
    }
    public var contentView: ContentView {
        didSet { self.contentItem = LayoutItem(view: self.contentView) }
    }
    public private(set) var contentItem: LayoutItem {
        didSet { self.setNeedForceUpdate(item: self.contentItem) }
    }
    public var detailInset: InsetFloat {
        didSet { self.setNeedForceUpdate() }
    }
    public var detailView: DetailView {
        didSet { self.detailItem = LayoutItem(view: self.detailView) }
    }
    public private(set) var detailItem: LayoutItem {
        didSet { self.setNeedForceUpdate(item: self.detailItem) }
    }
    public var isAnimating: Bool {
        return self._animationTask != nil
    }
    
    private var _contentSize: SizeFloat?
    private var _detailSize: SizeFloat?
    private var _state: State {
        didSet { self.setNeedForceUpdate() }
    }
    private var _animationTask: IAnimationTask? {
        willSet {
            guard let animationTask = self._animationTask else { return }
            animationTask.cancel()
        }
    }
    
    public init(
        contentInset: InsetFloat,
        contentView: ContentView,
        detailInset: InsetFloat,
        detailView: DetailView
    ) {
        self.contentInset = contentInset
        self.contentView = contentView
        self.contentItem = LayoutItem(view: contentView)
        self.detailInset = detailInset
        self.detailView = detailView
        self.detailItem = LayoutItem(view: detailView)
        self._state = .collapsed
    }
    
    public func collapse(
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        completion: (() -> Void)? = nil
    ) {
        self._animationTask = Animation.default.run(
            duration: duration,
            ease: ease,
            processing: { [unowned self] progress in
                self._state = .changing(progress: progress)
                self.updateIfNeeded()
            },
            completion: { [unowned self] in
                self._state = .collapsed
                self._animationTask = nil
                self.setNeedForceUpdate()
                self.updateIfNeeded()
                completion?()
            }
        )
    }
    
    public func expand(
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        completion: (() -> Void)? = nil
    ) {
        self._animationTask = Animation.default.run(
            duration: duration,
            ease: ease,
            processing: { [unowned self] progress in
                self._state = .changing(progress: progress.invert)
                self.updateIfNeeded()
            },
            completion: { [unowned self] in
                self._state = .expanded
                self._animationTask = nil
                self.setNeedForceUpdate()
                self.updateIfNeeded()
                completion?()
            }
        )
    }
    
    public func invalidate(item: LayoutItem) {
        if self.contentItem === item {
            self._contentSize = nil
        } else if self.detailItem === item {
            self._detailSize = nil
        }
    }
    
    public func layout(bounds: RectFloat) -> SizeFloat {
        let contentSize: SizeFloat
        if let size = self._contentSize {
            contentSize = size
        } else {
            contentSize = self.contentItem.size(available: bounds.size.inset(self.contentInset))
            self._contentSize = contentSize
        }
        let detailSize: SizeFloat
        if let size = self._detailSize {
            detailSize = size
        } else {
            detailSize = self.detailItem.size(available: bounds.size.inset(self.detailInset))
            self._detailSize = detailSize
        }
        switch self._state {
        case .collapsed:
            self.contentItem.frame = RectFloat(
                x: self.contentInset.left,
                y: self.contentInset.top,
                width: contentSize.width,
                height: contentSize.height
            )
            return SizeFloat(
                width: contentSize.width + self.contentInset.vertical,
                height: contentSize.height + self.contentInset.horizontal
            )
        case .expanded:
            self.contentItem.frame = RectFloat(
                x: self.contentInset.left,
                y: self.contentInset.top,
                width: contentSize.width,
                height: contentSize.height
            )
            self.detailItem.frame = RectFloat(
                x: self.detailInset.left,
                y: self.detailInset.top + (self.contentInset.top + contentSize.height + self.contentInset.horizontal),
                width: detailSize.width,
                height: detailSize.height
            )
            return SizeFloat(
                width: max(contentSize.width + self.contentInset.vertical, detailSize.width + self.detailInset.vertical),
                height: (contentSize.height + self.contentInset.horizontal) + (detailSize.height + self.detailInset.horizontal)
            )
        case .changing(let progress):
            self.contentItem.frame = RectFloat(
                x: self.contentInset.left,
                y: self.contentInset.top,
                width: contentSize.width,
                height: contentSize.height
            )
            self.detailItem.frame = RectFloat(
                x: self.detailInset.left,
                y: self.detailInset.top + (self.contentInset.top + contentSize.height + self.contentInset.horizontal),
                width: detailSize.width,
                height: detailSize.height
            )
            let collapseDetailHeight: Float = 0
            let expandDetailHeight = (detailSize.height + self.detailInset.horizontal)
            let detailHeight = collapseDetailHeight.lerp(expandDetailHeight, progress: progress.value)
            return SizeFloat(
                width: max(contentSize.width + self.contentInset.vertical, detailSize.width + self.detailInset.vertical),
                height: (contentSize.height + self.contentInset.horizontal) + detailHeight
            )
        }
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        switch self._state {
        case .collapsed:
            let contentSize = self.contentItem.size(available: available.inset(self.contentInset)).inset(-self.contentInset)
            return contentSize
        case .expanded:
            let contentSize = self.contentItem.size(available: available.inset(self.contentInset)).inset(-self.contentInset)
            let detailSize = self.detailItem.size(available: available.inset(self.detailInset)).inset(-self.detailInset)
            return SizeFloat(
                width: max(contentSize.width, detailSize.width),
                height: contentSize.height + detailSize.height
            )
        case .changing(let progress):
            let contentSize = self.contentItem.size(available: available.inset(self.contentInset)).inset(-self.contentInset)
            let expandDetailSize = self.detailItem.size(available: available.inset(self.detailInset)).inset(-self.detailInset)
            let collapseDetailSize = SizeFloat(width: expandDetailSize.width, height: 0)
            let detailSize = collapseDetailSize.lerp(expandDetailSize, progress: progress.value)
            return SizeFloat(
                width: max(contentSize.width, detailSize.width),
                height: contentSize.height + detailSize.height
            )
        }
    }
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        switch self._state {
        case .collapsed: return [ self.contentItem ]
        case .expanded: return [ self.contentItem, self.detailItem ]
        case .changing: return [ self.contentItem, self.detailItem ]
        }
    }
    
}

private extension ExpandLayout {
    
    enum State {
        case collapsed
        case expanded
        case changing(progress: PercentFloat)
    }
    
}
