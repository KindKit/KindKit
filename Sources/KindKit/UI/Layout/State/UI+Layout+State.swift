//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class State< State : Equatable & Hashable > : IUILayout {
        
        public weak var delegate: IUILayoutDelegate?
        public weak var appearedView: IUIView?
        public var inset: Inset = .zero {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var state: State {
            set {
                self._internalState = .idle(state: newValue)
            }
            get {
                switch self._internalState {
                case .idle(let state): return state
                case .animation(_, let from, let to, let progress):
                    if progress > .half {
                        return to
                    }
                    return from
                }
            }
        }
        public private(set) var data: [State : Data] = [:]
        
        private var _internalState: InternalState {
            didSet {
                guard self._internalState != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }

        public init(_ state: State) {
            self._internalState = .idle(state: state)
        }
        
        deinit {
            self._destroy()
        }
        
        public func layout(bounds: Rect) -> Size {
            switch self._internalState {
            case .idle(let state):
                return self._layout(bounds: bounds, state: state)
            case .animation(let transition, let from, let to, let progress):
                let fromBeginBounds = self._fromBeginBounds(bounds: bounds, transition: transition)
                let fromEndBounds = self._fromEndBounds(bounds: bounds, transition: transition)
                let fromBounds = fromBeginBounds.lerp(fromEndBounds, progress: progress)
                let toBeginBounds = self._toBeginBounds(bounds: bounds, transition: transition)
                let toEndBounds = self._toEndBounds(bounds: bounds, transition: transition)
                let toBounds = toBeginBounds.lerp(toEndBounds, progress: progress)
                let fromSize = self._layout(bounds: fromBounds, state: from)
                let toSize = self._layout(bounds: toBounds, state: to)
                return fromSize.lerp(toSize, progress: progress)
            }
        }
        
        public func size(available: Size) -> Size {
            switch self._internalState {
            case .idle(let state):
                return self._size(available: available, state: state)
            case .animation(_, let from, let to, let progress):
                let fromSize = self._size(available: available, state: from)
                let toSize = self._size(available: available, state: to)
                return fromSize.lerp(toSize, progress: progress)
            }
        }
        
        public func views(bounds: Rect) -> [IUIView] {
            var views: [IUIView] = []
            switch self._internalState {
            case .idle(let state):
                if let view = self.data[state]?.view {
                    views.append(view)
                }
            case .animation(_, let from, let to, _):
                if let view = self.data[from]?.view {
                    views.append(view)
                }
                if let view = self.data[to]?.view {
                    views.append(view)
                }
            }
            return views
        }
        
    }
    
}

public extension UI.Layout.State {
    
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
    
    @discardableResult
    func data(_ value: [State : Data]) -> Self {
        self.data = value
        self.setNeedForceUpdate()
        return self
    }
    
    @inlinable
    @discardableResult
    func data(_ value: () -> [State : Data]) -> Self {
        return self.data(value())
    }

    @inlinable
    @discardableResult
    func data(_ value: (Self) -> [State : Data]) -> Self {
        return self.data(value(self))
    }
    
}

public extension UI.Layout.State {
    
    @discardableResult
    func set(state: State, inset: Inset) -> Self {
        self._data(state: state, update: { $0.inset = inset })
        if self._internalState.contains(state: state) == true {
            self.setNeedForceUpdate()
        }
        return self
    }
    
    func inset(state: State) -> Inset? {
        return self.data[state]?.inset
    }
    
    @discardableResult
    func set(state: State, alignment: Alignment) -> Self {
        self._data(state: state, update: { $0.alignment = alignment })
        if self._internalState.contains(state: state) == true {
            self.setNeedForceUpdate()
        }
        return self
    }
    
    func alignment(state: State) -> Alignment? {
        return self.data[state]?.alignment
    }
    
    @discardableResult
    func set(state: State, view: IUIView?) -> Self {
        self._data(state: state, update: { $0.view = view })
        if self._internalState.contains(state: state) == true {
            self.setNeedForceUpdate()
        }
        return self
    }
    
    func view(state: State) -> IUIView? {
        return self.data[state]?.view
    }
    
    @discardableResult
    func set(state: State, data: Data?) -> Self {
        self.data[state] = data
        if self._internalState.contains(state: state) == true {
            self.setNeedForceUpdate()
        }
        return self
    }
    
    func data(state: State) -> Data? {
        return self.data[state]
    }
    
}

public extension UI.Layout.State {
    
    func reset() {
        self.data = [:]
        self.setNeedForceUpdate()
    }
    
    func animate(
        delay: TimeInterval = 0,
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        transition: Transition,
        state: State,
        processing: ((_ progress: Percent) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        let fromState = self.state
        self._animation = Animation.default.run(
            .custom(
                delay: delay,
                duration: duration,
                ease: ease,
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._internalState = .animation(transition: transition, from: fromState, to: state, progress: progress)
                    processing?(progress)
                    self.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._animation = nil
                    self._internalState = .idle(state: state)
                    self.updateIfNeeded()
                    completion?()
                }
            )
        )
    }
    
}

private extension UI.Layout.State {
    
    enum InternalState : Equatable {
        
        case idle(state: State)
        case animation(transition: Transition, from: State, to: State, progress: Percent)
        
        func contains(state: State) -> Bool {
            switch self {
            case .idle(let currentState): return currentState == state
            case .animation(_, let from, let to, _): return from == state || to == state
            }
        }
        
    }
    
}

private extension UI.Layout.State {
    
    func _destroy() {
        self._animation = nil
    }
    
    @inline(__always)
    func _data(state: State, update: (_ data: inout Data) -> Void) {
        if var data = self.data[state] {
            update(&data)
            self.data[state] = data
        } else {
            var data = Data()
            update(&data)
            self.data[state] = data
        }
    }
    
    @inline(__always)
    func _fromBeginBounds(bounds: Rect, transition: Transition) -> Rect {
        return bounds
    }
    
    @inline(__always)
    func _fromEndBounds(bounds: Rect, transition: Transition) -> Rect {
        switch transition {
        case .slideFromTop: return Rect(topLeft: bounds.bottomLeft, size: bounds.size)
        case .slideFromLeft: return Rect(topLeft: bounds.topRight, size: bounds.size)
        case .slideFromRight: return Rect(topRight: bounds.topLeft, size: bounds.size)
        case .slideFromBottom: return Rect(bottomLeft: bounds.topLeft, size: bounds.size)
        }
    }
    
    @inline(__always)
    func _toBeginBounds(bounds: Rect, transition: Transition) -> Rect {
        switch transition {
        case .slideFromTop: return Rect(bottomLeft: bounds.topLeft, size: bounds.size)
        case .slideFromLeft: return Rect(topRight: bounds.topLeft, size: bounds.size)
        case .slideFromRight: return Rect(topLeft: bounds.topRight, size: bounds.size)
        case .slideFromBottom: return Rect(topLeft: bounds.bottomLeft, size: bounds.size)
        }
    }
    
    @inline(__always)
    func _toEndBounds(bounds: Rect, transition: Transition) -> Rect {
        return bounds
    }
    
    @inline(__always)
    func _layout(bounds: Rect, state: State) -> Size {
        guard let data = self.data[state] else { return .zero }
        guard let view = data.view else { return .zero }
        switch data.alignment {
        case .topLeft:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(topLeft: bounds.topLeft, size: size)
            return size.inset(-inset)
        case .top:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(top: bounds.top, size: size)
            return size
        case .topRight:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(topRight: bounds.topRight, size: size)
            return size
        case .left:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(left: bounds.left, size: size)
            return size
        case .center:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(center: bounds.center, size: size)
            return size
        case .right:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(right: bounds.right, size: size)
            return size
        case .bottomLeft:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(bottomLeft: bounds.bottomLeft, size: size)
            return size
        case .bottom:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(bottom: bounds.bottom, size: size)
            return size
        case .bottomRight:
            let inset = self.inset + data.inset
            let bounds = bounds.inset(inset)
            let size = view.size(available: bounds.size)
            view.frame = Rect(bottomRight: bounds.bottomRight, size: size)
            return size
        case .fill:
            let inset = self.inset + data.inset
            view.frame = bounds.inset(inset)
            return bounds.size
        }
    }
    
    @inline(__always)
    func _size(available: Size, state: State) -> Size {
        guard let data = self.data[state] else { return .zero }
        guard let view = data.view else { return .zero }
        let inset = self.inset + data.inset
        let size = view.size(available: available.inset(inset))
        return size.inset(-inset)
    }
    
}

public extension IUILayout {
    
    @inlinable
    static func state< State : Equatable & Hashable >(_ state: State) -> UI.Layout.State< State > {
        return .init(state)
    }
    
}
