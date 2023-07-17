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
                switch newValue {
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
        public var inset: Inset = .zero {
            didSet {
                guard self.inset != oldValue else { return }
                self._contentSize = nil
                self._detailSize = nil
                self.setNeedForceUpdate()
            }
        }
        public var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self._contentSize = nil
                self.setNeedForceUpdate()
            }
        }
        public var detailSpacing: Double = 0 {
            didSet {
                guard self.detailSpacing != oldValue else { return }
                self._contentSize = nil
                self._detailSize = nil
                self.setNeedForceUpdate()
            }
        }
        public var detail: IUIView? {
            didSet {
                guard self.detail !== oldValue else { return }
                self._detailSize = nil
                self.setNeedForceUpdate()
            }
        }
        public var isAnimating: Bool {
            return self._animation != nil
        }
        
        private var _contentSize: Size?
        private var _detailSize: Size?
        private var _status: Status = .collapsed {
            didSet {
                guard self._status != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init() {
        }
        
        deinit {
            self._animation?.cancel()
        }
        
        public func invalidate() {
            self._contentSize = nil
            self._detailSize = nil
        }
        
        public func invalidate(_ view: IUIView) {
            if self.content === view {
                self._contentSize = nil
            } else if self.detail === view {
                self._detailSize = nil
            }
        }
        
        public func layout(bounds: Rect) -> Size {
            let available = bounds.size.inset(self.inset)
            switch self._status {
            case .collapsed:
                guard let content = self.content else { return .zero }
                let contentSize: Size
                if let size = self._contentSize {
                    contentSize = size
                } else {
                    contentSize = content.size(available: available)
                    self._contentSize = contentSize
                }
                content.frame = Rect(
                    x: self.inset.left,
                    y: self.inset.top,
                    width: contentSize.width,
                    height: contentSize.height
                )
                return Size(
                    width: contentSize.width + self.inset.vertical,
                    height: contentSize.height + self.inset.horizontal
                )
            case .expanded:
                guard let content = self.content, let detail = self.detail else { return .zero }
                let contentSize: Size
                if let size = self._contentSize {
                    contentSize = size
                } else {
                    contentSize = content.size(available: available)
                    self._contentSize = contentSize
                }
                let detailSize: Size
                if let size = self._detailSize {
                    detailSize = size
                } else {
                    detailSize = detail.size(available: available)
                    self._detailSize = detailSize
                }
                content.frame = Rect(
                    x: self.inset.left,
                    y: self.inset.top,
                    width: contentSize.width,
                    height: contentSize.height
                )
                detail.frame = Rect(
                    x: self.inset.left,
                    y: self.inset.top + contentSize.height + self.detailSpacing,
                    width: detailSize.width,
                    height: detailSize.height
                )
                return Size(
                    width: max(contentSize.width, detailSize.width) + self.inset.vertical,
                    height: (contentSize.height + self.detailSpacing + detailSize.height) + self.inset.horizontal
                )
            case .changing(let progress):
                guard let content = self.content, let detail = self.detail else { return .zero }
                let contentSize: Size
                if let size = self._contentSize {
                    contentSize = size
                } else {
                    contentSize = content.size(available: available)
                    self._contentSize = contentSize
                }
                let detailSize: Size
                if let size = self._detailSize {
                    detailSize = size
                } else {
                    detailSize = detail.size(available: available)
                    self._detailSize = detailSize
                }
                let collapseDetailSpacing: Double = 0
                let expandDetailSpacing = self.detailSpacing
                let detailSpacing = collapseDetailSpacing.lerp(expandDetailSpacing, progress: progress)
                content.frame = Rect(
                    x: self.inset.left,
                    y: self.inset.top,
                    width: contentSize.width,
                    height: contentSize.height
                )
                detail.frame = Rect(
                    x: self.inset.left,
                    y: self.inset.top + contentSize.height + detailSpacing,
                    width: detailSize.width,
                    height: detailSize.height
                )
                let collapseDetailHeight: Double = 0
                let expandDetailHeight = detailSize.height
                let detailHeight = collapseDetailHeight.lerp(expandDetailHeight, progress: progress)
                return Size(
                    width: max(contentSize.width, detailSize.width) + self.inset.vertical,
                    height: (contentSize.height + detailSpacing + detailHeight) + self.inset.horizontal
                )
            }
        }
        
        public func size(available: Size) -> Size {
            let available = available.inset(self.inset)
            switch self._status {
            case .collapsed:
                guard let content = self.content else { return .zero }
                let contentSize = content.size(available: available)
                return contentSize
            case .expanded:
                guard let content = self.content, let detail = self.detail else { return .zero }
                let contentSize = content.size(available: available)
                let detailSize = detail.size(available: available)
                return Size(
                    width: max(contentSize.width, detailSize.width) + self.inset.vertical,
                    height: (contentSize.height + self.detailSpacing + detailSize.height) + self.inset.horizontal
                )
            case .changing(let progress):
                guard let content = self.content, let detail = self.detail else { return .zero }
                let contentSize = content.size(available: available)
                let detailSize = detail.size(available: available)
                let collapseDetailSpacing: Double = 0
                let expandDetailSpacing = self.detailSpacing
                let detailSpacing = collapseDetailSpacing.lerp(expandDetailSpacing, progress: progress)
                let collapseDetailHeight: Double = 0
                let expandDetailHeight = detailSize.height
                let detailHeight = collapseDetailHeight.lerp(expandDetailHeight, progress: progress)
                return Size(
                    width: max(contentSize.width, detailSize.width) + self.inset.vertical,
                    height: (contentSize.height + detailSpacing + detailHeight) + self.inset.horizontal
                )
            }
        }
        
        public func views(bounds: Rect) -> [IUIView] {
            guard let content = self.content else {
                return []
            }
            switch self._status {
            case .collapsed:
                return [ content ]
            case .expanded, .changing:
                guard let detail = self.detail else {
                    return [ content ]
                }
                return [ content, detail ]
            }
        }
        
    }
    
}

public extension UI.Layout.Expand {
    
    @inlinable
    @discardableResult
    func state(_ value: State) -> Self {
        self.state = value
        return self
    }
    
    @inlinable
    @discardableResult
    func state(_ value: () -> State) -> Self {
        return self.state(value())
    }

    @inlinable
    @discardableResult
    func state(_ value: (Self) -> State) -> Self {
        return self.state(value(self))
    }
    
    @inlinable
    @discardableResult
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func inset(_ value: () -> Inset) -> Self {
        return self.inset(value())
    }

    @inlinable
    @discardableResult
    func inset(_ value: (Self) -> Inset) -> Self {
        return self.inset(value(self))
    }
    
    @inlinable
    @discardableResult
    func content(_ value: IUIView?) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> IUIView?) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> IUIView?) -> Self {
        return self.content(value(self))
    }
    
    @inlinable
    @discardableResult
    func detailSpacing(_ value: Double) -> Self {
        self.detailSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func detailSpacing(_ value: () -> Double) -> Self {
        return self.detailSpacing(value())
    }

    @inlinable
    @discardableResult
    func detailSpacing(_ value: (Self) -> Double) -> Self {
        return self.detailSpacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func detail(_ value: IUIView?) -> Self {
        self.detail = value
        return self
    }
    
    @inlinable
    @discardableResult
    func detail(_ value: () -> IUIView?) -> Self {
        return self.detail(value())
    }

    @inlinable
    @discardableResult
    func detail(_ value: (Self) -> IUIView?) -> Self {
        return self.detail(value(self))
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

public extension IUILayout where Self == UI.Layout.Expand {
    
    @inlinable
    static func expand() -> UI.Layout.Expand {
        return .init()
    }
    
}
