//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class Expand : IUILayout {
        
        public weak var delegate: IUILayoutDelegate?
        public weak var appearedView: IUIView?
        public var state: State {
            set {
                guard self.state != newValue else { return }
                switch self.state {
                case .collapsed: self._status = .collapsed
                case .expanded: self._status = .expanded
                }
            }
            get {
                switch self._status {
                case .collapsed: return .collapsed
                case .expanded: return .expanded
                case .changing(let percent):
                    if percent > .half {
                        return .collapsed
                    } else {
                        return .expanded
                    }
                }
            }
        }
        public var contentInset: Inset {
            didSet { self.setNeedForceUpdate() }
        }
        public var contentView: IUIView {
            didSet {
                guard self.contentView !== oldValue else { return }
                self.setNeedForceUpdate(self.contentView)
            }
        }
        public var detailInset: Inset {
            didSet {
                guard self.detailInset != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var detailView: IUIView {
            didSet {
                guard self.detailView !== oldValue else { return }
                self.setNeedForceUpdate(self.detailView)
            }
        }
        public var isAnimating: Bool {
            return self._animation != nil
        }
        
        private var _contentSize: Size?
        private var _detailSize: Size?
        private var _status: Status {
            didSet {
                guard self._status != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            state: State = .collapsed,
            contentInset: Inset = .zero,
            contentView: IUIView,
            detailInset: Inset = .zero,
            detailView: IUIView
        ) {
            switch state {
            case .collapsed: self._status = .collapsed
            case .expanded: self._status = .expanded
            }
            self.contentInset = contentInset
            self.contentView = contentView
            self.detailInset = detailInset
            self.detailView = detailView
        }
        
        deinit {
            self._destroy()
        }
        
        public func invalidate() {
            self._contentSize = nil
            self._detailSize = nil
        }
        
        public func invalidate(_ view: IUIView) {
            if self.contentView === view {
                self._contentSize = nil
            } else if self.detailView === view {
                self._detailSize = nil
            }
        }
        
        public func layout(bounds: Rect) -> Size {
            let contentSize: Size
            if let size = self._contentSize {
                contentSize = size
            } else {
                contentSize = self.contentView.size(available: bounds.size.inset(self.contentInset))
                self._contentSize = contentSize
            }
            let detailSize: Size
            if let size = self._detailSize {
                detailSize = size
            } else {
                detailSize = self.detailView.size(available: bounds.size.inset(self.detailInset))
                self._detailSize = detailSize
            }
            switch self._status {
            case .collapsed:
                self.contentView.frame = Rect(
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
                self.contentView.frame = Rect(
                    x: self.contentInset.left,
                    y: self.contentInset.top,
                    width: contentSize.width,
                    height: contentSize.height
                )
                self.detailView.frame = Rect(
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
                self.contentView.frame = Rect(
                    x: self.contentInset.left,
                    y: self.contentInset.top,
                    width: contentSize.width,
                    height: contentSize.height
                )
                self.detailView.frame = Rect(
                    x: self.detailInset.left,
                    y: self.detailInset.top + (self.contentInset.top + contentSize.height + self.contentInset.horizontal),
                    width: detailSize.width,
                    height: detailSize.height
                )
                let collapseDetailHeight: Double = 0
                let expandDetailHeight = (detailSize.height + self.detailInset.horizontal)
                let detailHeight = collapseDetailHeight.lerp(expandDetailHeight, progress: progress)
                return Size(
                    width: max(contentSize.width + self.contentInset.vertical, detailSize.width + self.detailInset.vertical),
                    height: (contentSize.height + self.contentInset.horizontal) + detailHeight
                )
            }
        }
        
        public func size(available: Size) -> Size {
            switch self._status {
            case .collapsed:
                let contentSize = self.contentView.size(available: available.inset(self.contentInset)).inset(-self.contentInset)
                return contentSize
            case .expanded:
                let contentSize = self.contentView.size(available: available.inset(self.contentInset)).inset(-self.contentInset)
                let detailSize = self.detailView.size(available: available.inset(self.detailInset)).inset(-self.detailInset)
                return Size(
                    width: max(contentSize.width, detailSize.width),
                    height: contentSize.height + detailSize.height
                )
            case .changing(let progress):
                let contentSize = self.contentView.size(available: available.inset(self.contentInset)).inset(-self.contentInset)
                let expandDetailSize = self.detailView.size(available: available.inset(self.detailInset)).inset(-self.detailInset)
                let collapseDetailSize = Size(width: expandDetailSize.width, height: 0)
                let detailSize = collapseDetailSize.lerp(expandDetailSize, progress: progress)
                return Size(
                    width: max(contentSize.width, detailSize.width),
                    height: contentSize.height + detailSize.height
                )
            }
        }
        
        public func views(bounds: Rect) -> [IUIView] {
            switch self._status {
            case .collapsed: return [ self.contentView ]
            case .expanded: return [ self.contentView, self.detailView ]
            case .changing: return [ self.contentView, self.detailView ]
            }
        }
        
    }
    
}

public extension UI.Layout.Expand {
    
    func animate(
        to state: State,
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        processing: ((_ progress: Percent) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        switch state {
        case .collapsed:
            self._animation = Animation.default.run(
                .custom(
                    duration: duration,
                    ease: ease,
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._status = .changing(progress.invert)
                        processing?(progress)
                        self.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._status = .collapsed
                        completion?()
                        self.updateIfNeeded()
                    }
                )
            )
        case .expanded:
            self._animation = Animation.default.run(
                .custom(
                    duration: duration,
                    ease: ease,
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._status = .changing(progress)
                        processing?(progress)
                        self.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._status = .expanded
                        completion?()
                        self.updateIfNeeded()
                    }
                )
            )
        }
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
        contentInset: Inset,
        contentView: IUIView,
        detailInset: Inset,
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