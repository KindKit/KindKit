//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class State< State : Equatable & Hashable > : IUILayout {
        
        public unowned var delegate: IUILayoutDelegate?
        public unowned var view: IUIView?
        public var state: State {
            set(value) {
                self._internalState = .idle(state: value)
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
        public var insets: [State : InsetFloat] {
            return self.data.mapValues({ $0.inset })
        }
        public var alignments: [State : Alignment] {
            return self.data.mapValues({ $0.alignment })
        }
        public var items: [State : UI.Layout.Item] {
            var result: [State : UI.Layout.Item] = [:]
            for data in self.data {
                guard let item = data.value.item else { continue }
                result[data.key] = item
            }
            return result
        }
        public private(set) var data: [State : Data]
        
        private var _internalState: InternalState {
            didSet(oldValue) {
                guard self._internalState != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }

        public init(
            state: State,
            data: [State : Data] = [:]
        ) {
            self._internalState = .idle(state: state)
            self.data = data
        }
        
        public convenience init(
            state: State,
            insets: [State : InsetFloat] = [:],
            alignments: [State : Alignment] = [:],
            items: [State : UI.Layout.Item]
        ) {
            self.init(
                state: state,
                data: [:]
            )
            insets.forEach({
                self.set(state: $0.key, inset: $0.value)
            })
            alignments.forEach({
                self.set(state: $0.key, alignment: $0.value)
            })
            items.forEach({
                self.set(state: $0.key, item: $0.value)
            })
        }
        
        public convenience init(
            state: State,
            insets: [State : InsetFloat] = [:],
            alignments: [State : Alignment] = [:],
            views: [State : IUIView]
        ) {
            self.init(
                state: state,
                data: [:]
            )
            insets.forEach({
                self.set(state: $0.key, inset: $0.value)
            })
            alignments.forEach({
                self.set(state: $0.key, alignment: $0.value)
            })
            views.forEach({
                self.set(state: $0.key, view: $0.value)
            })
        }
        
        public func set(state: State, inset: InsetFloat) {
            self._data(state: state, update: { $0.inset = inset })
            if self._internalState.contains(state: state) == true {
                self.setNeedForceUpdate()
            }
        }
        
        public func inset(state: State) -> InsetFloat? {
            return self.data[state]?.inset
        }
        
        public func set(state: State, alignment: Alignment) {
            self._data(state: state, update: { $0.alignment = alignment })
            if self._internalState.contains(state: state) == true {
                self.setNeedForceUpdate()
            }
        }
        
        public func alignment(state: State) -> Alignment? {
            return self.data[state]?.alignment
        }
        
        public func set(state: State, item: UI.Layout.Item?) {
            self._data(state: state, update: { $0.item = item })
            if self._internalState.contains(state: state) == true {
                self.setNeedForceUpdate()
            }
        }
        
        public func item(state: State) -> UI.Layout.Item? {
            return self.data[state]?.item
        }
        
        public func set(state: State, view: IUIView?) {
            self._data(state: state, update: { $0.view = view })
            if self._internalState.contains(state: state) == true {
                self.setNeedForceUpdate()
            }
        }
        
        public func view(state: State) -> IUIView? {
            return self.data[state]?.view
        }
        
        public func set(state: State, data: Data?) {
            self.data[state] = data
            if self._internalState.contains(state: state) == true {
                self.setNeedForceUpdate()
            }
        }
        
        public func data(state: State) -> Data? {
            return self.data[state]
        }
        
        public func animate(
            delay: TimeInterval = 0,
            duration: TimeInterval,
            ease: IAnimationEase = Animation.Ease.Linear(),
            transition: Transition,
            state: State,
            completion: (() -> Void)? = nil
        ) {
            let fromState = self.state
            Animation.default.run(
                delay: delay,
                duration: duration,
                ease: ease,
                processing: { [unowned self] progress in
                    self._internalState = .animation(transition: transition, from: fromState, to: state, progress: progress)
                    self.setNeedForceUpdate()
                    self.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._internalState = .idle(state: state)
                    self.setNeedForceUpdate()
                    self.updateIfNeeded()
                    completion?()
                }
            )
        }
        
        public func layout(bounds: RectFloat) -> SizeFloat {
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
        
        public func size(available: SizeFloat) -> SizeFloat {
            switch self._internalState {
            case .idle(let state):
                return self._size(available: available, state: state)
            case .animation(_, let from, let to, let progress):
                let fromSize = self._size(available: available, state: from)
                let toSize = self._size(available: available, state: to)
                return fromSize.lerp(toSize, progress: progress)
            }
        }
        
        public func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = []
            switch self._internalState {
            case .idle(let state):
                if let item = self.data[state]?.item {
                    items.append(item)
                }
            case .animation(_, let from, let to, _):
                if let item = self.data[from]?.item {
                    items.append(item)
                }
                if let item = self.data[to]?.item {
                    items.append(item)
                }
            }
            return items
        }
        
    }
    
}

private extension UI.Layout.State {
    
    enum InternalState : Equatable {
        
        case idle(state: State)
        case animation(transition: Transition, from: State, to: State, progress: PercentFloat)
        
        func contains(state: State) -> Bool {
            switch self {
            case .idle(let currentState): return currentState == state
            case .animation(_, let from, let to, _): return from == state || to == state
            }
        }
        
    }
    
}

private extension UI.Layout.State {
    
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
    func _fromBeginBounds(bounds: RectFloat, transition: Transition) -> RectFloat {
        return bounds
    }
    
    @inline(__always)
    func _fromEndBounds(bounds: RectFloat, transition: Transition) -> RectFloat {
        switch transition {
        case .slideFromTop: return Rect(topLeft: bounds.bottomLeft, size: bounds.size)
        case .slideFromLeft: return Rect(topLeft: bounds.topRight, size: bounds.size)
        case .slideFromRight: return Rect(topRight: bounds.topLeft, size: bounds.size)
        case .slideFromBottom: return Rect(bottomLeft: bounds.topLeft, size: bounds.size)
        }
    }
    
    @inline(__always)
    func _toBeginBounds(bounds: RectFloat, transition: Transition) -> RectFloat {
        switch transition {
        case .slideFromTop: return Rect(bottomLeft: bounds.topLeft, size: bounds.size)
        case .slideFromLeft: return Rect(topRight: bounds.topLeft, size: bounds.size)
        case .slideFromRight: return Rect(topLeft: bounds.topRight, size: bounds.size)
        case .slideFromBottom: return Rect(topLeft: bounds.bottomLeft, size: bounds.size)
        }
    }
    
    @inline(__always)
    func _toEndBounds(bounds: RectFloat, transition: Transition) -> RectFloat {
        return bounds
    }
    
    @inline(__always)
    func _layout(bounds: RectFloat, state: State) -> SizeFloat {
        guard let data = self.data[state] else { return .zero }
        guard let item = data.item else { return .zero }
        let availableBounds = bounds.inset(data.inset)
        switch data.alignment {
        case .topLeft:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(topLeft: availableBounds.topLeft, size: size)
            return size
        case .top:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(top: availableBounds.top, size: size)
            return size
        case .topRight:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(topRight: availableBounds.topRight, size: size)
            return size
        case .left:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(left: availableBounds.left, size: size)
            return size
        case .center:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(center: availableBounds.center, size: size)
            return size
        case .right:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(right: availableBounds.right, size: size)
            return size
        case .bottomLeft:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(bottomLeft: availableBounds.bottomLeft, size: size)
            return size
        case .bottom:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(bottom: availableBounds.bottom, size: size)
            return size
        case .bottomRight:
            let size = item.size(available: availableBounds.size)
            item.frame = RectFloat(bottomRight: availableBounds.bottomRight, size: size)
            return size
        case .fill:
            item.frame = availableBounds
            return availableBounds.size
        }
    }
    
    @inline(__always)
    func _size(available: SizeFloat, state: State) -> SizeFloat {
        guard let data = self.data[state] else { return .zero }
        guard let item = data.item else { return .zero }
        let availableSize = available.inset(data.inset)
        switch data.alignment {
        case .topLeft, .top, .topRight, .left, .center, .right, .bottomLeft, .bottom, .bottomRight:
            let size = item.size(available: availableSize)
            return size.inset(-data.inset)
        case .fill:
            return availableSize
        }
    }
    
}

public extension IUILayout {
    
    @inlinable
    static func state< State : Equatable & Hashable >(
        state: State,
        data: [State : UI.Layout.State< State >.Data] = [:]
    ) -> UI.Layout.State< State > {
        return .init(
            state: state,
            data: data
        )
    }
    
    @inlinable
    static func state< State : Equatable & Hashable >(
        state: State,
        insets: [State : InsetFloat] = [:],
        alignments: [State : UI.Layout.State< State >.Alignment] = [:],
        items: [State : UI.Layout.Item]
    ) -> UI.Layout.State< State > {
        return .init(
            state: state,
            insets: insets,
            alignments: alignments,
            items: items
        )
    }
    
    @inlinable
    static func state< State : Equatable & Hashable >(
        state: State,
        insets: [State : InsetFloat] = [:],
        alignments: [State : UI.Layout.State< State >.Alignment] = [:],
        views: [State : IUIView]
    ) -> UI.Layout.State< State > {
        return .init(
            state: state,
            insets: insets,
            alignments: alignments,
            views: views
        )
    }
    
}
