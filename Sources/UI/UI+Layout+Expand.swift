//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class Expand : IUILayout {
        
        public weak var delegate: IUILayoutDelegate?
        public weak var view: IUIView?
        public var contentInset: InsetFloat {
            didSet { self.setNeedForceUpdate() }
        }
        public var contentView: IUIView {
            didSet {
                guard self.contentView !== oldValue else { return }
                self.contentItem = UI.Layout.Item(self.contentView)
            }
        }
        public private(set) var contentItem: UI.Layout.Item {
            didSet {
                guard self.contentItem != oldValue else { return }
                self.setNeedForceUpdate(item: self.contentItem)
            }
        }
        public var detailInset: InsetFloat {
            didSet {
                guard self.detailInset != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var detailView: IUIView {
            didSet {
                guard self.detailView !== oldValue else { return }
                self.detailItem = UI.Layout.Item(self.detailView)
            }
        }
        public private(set) var detailItem: UI.Layout.Item {
            didSet {
                guard self.detailItem != oldValue else { return }
                self.setNeedForceUpdate(item: self.detailItem)
            }
        }
        public var isAnimating: Bool {
            return self._animation != nil
        }
        
        private var _contentSize: SizeFloat?
        private var _detailSize: SizeFloat?
        private var _state: State = .collapsed {
            didSet { self.setNeedForceUpdate() }
        }
        private var _animation: IAnimationTask? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            contentInset: InsetFloat,
            contentView: IUIView,
            detailInset: InsetFloat,
            detailView: IUIView
        ) {
            self.contentInset = contentInset
            self.contentView = contentView
            self.contentItem = UI.Layout.Item(contentView)
            self.detailInset = detailInset
            self.detailView = detailView
            self.detailItem = UI.Layout.Item(detailView)
        }
        
        deinit {
            self._destroy()
        }
        
        public func invalidate() {
            self._contentSize = nil
            self._detailSize = nil
        }
        
        public func invalidate(item: UI.Layout.Item) {
            if self.contentItem == item {
                self._contentSize = nil
            } else if self.detailItem == item {
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
                return Size(
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
                return Size(
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
                return Size(
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
                return Size(
                    width: max(contentSize.width, detailSize.width),
                    height: contentSize.height + detailSize.height
                )
            case .changing(let progress):
                let contentSize = self.contentItem.size(available: available.inset(self.contentInset)).inset(-self.contentInset)
                let expandDetailSize = self.detailItem.size(available: available.inset(self.detailInset)).inset(-self.detailInset)
                let collapseDetailSize = SizeFloat(width: expandDetailSize.width, height: 0)
                let detailSize = collapseDetailSize.lerp(expandDetailSize, progress: progress.value)
                return Size(
                    width: max(contentSize.width, detailSize.width),
                    height: contentSize.height + detailSize.height
                )
            }
        }
        
        public func items(bounds: RectFloat) -> [UI.Layout.Item] {
            switch self._state {
            case .collapsed: return [ self.contentItem ]
            case .expanded: return [ self.contentItem, self.detailItem ]
            case .changing: return [ self.contentItem, self.detailItem ]
            }
        }
        
    }
    
}

public extension UI.Layout.Expand {
    
    func collapse(
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        completion: (() -> Void)? = nil
    ) {
        self._animation = Animation.default.run(
            duration: duration,
            ease: ease,
            processing: { [weak self] progress in
                guard let self = self else { return }
                self._state = .changing(progress)
                self.updateIfNeeded()
            },
            completion: { [weak self] in
                guard let self = self else { return }
                self._animation = nil
                self._state = .collapsed
                self.setNeedForceUpdate()
                self.updateIfNeeded()
                completion?()
            }
        )
    }
    
    func expand(
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        completion: (() -> Void)? = nil
    ) {
        self._animation = Animation.default.run(
            duration: duration,
            ease: ease,
            processing: { [weak self] progress in
                guard let self = self else { return }
                self._state = .changing(progress.invert)
                self.updateIfNeeded()
            },
            completion: { [weak self] in
                guard let self = self else { return }
                self._animation = nil
                self._state = .expanded
                self.setNeedForceUpdate()
                self.updateIfNeeded()
                completion?()
            }
        )
    }
    
}

private extension UI.Layout.Expand {
    
    func _destroy() {
        self._animation = nil
    }
    
}

public extension IUILayout where Self == UI.Layout.Expand {
    
    @inlinable
    static func expand(
        contentInset: InsetFloat,
        contentView: IUIView,
        detailInset: InsetFloat,
        detailView: IUIView
    ) -> UI.Layout.Expand {
        return .init(
            contentInset: contentInset,
            contentView: contentView,
            detailInset: detailInset,
            detailView: detailView
        )
    }
    
}
