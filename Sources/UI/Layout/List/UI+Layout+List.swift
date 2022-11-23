//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class List : IUILayout {
        
        public weak var delegate: IUILayoutDelegate?
        public weak var appearedView: IUIView?
        public var direction: Direction {
            didSet {
                guard self.direction != oldValue else { return }
                self._firstVisible = nil
                self.setNeedForceUpdate()
            }
        }
        public var alignment: Alignment {
            didSet {
                guard self.alignment != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var inset: Inset {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var spacing: Double {
            didSet {
                guard self.spacing != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var views: [IUIView] {
            set {
                self._views = newValue
                self._cache = Array< Size? >(repeating: nil, count: newValue.count)
                self._firstVisible = nil
                self.setNeedForceUpdate()
            }
            get { self._views }
        }
        public private(set) var isAnimating: Bool = false
        
        private var _views: [IUIView]
        private var _animations: [AnimationContext] = []
        private var _operations: [Helper.Operation] = []
        private var _cache: [Size?] = []
        private var _firstVisible: Int?
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }

        public init(
            direction: Direction,
            alignment: Alignment = .fill,
            inset: Inset = .zero,
            spacing: Double = 0,
            views: [IUIView] = []
        ) {
            self.direction = direction
            self.alignment = alignment
            self.inset = inset
            self.spacing = spacing
            self._views = views
            self._cache = Array< Size? >(repeating: nil, count: views.count)
        }
        
        deinit {
            self._destroy()
        }
        
        public func invalidate() {
            for index in self._cache.startIndex ..< self._cache.endIndex {
                self._cache[index] = nil
            }
        }
        
        public func invalidate(_ view: IUIView) {
            if let index = self._views.firstIndex(where: { $0 === view }) {
                self._cache[index] = nil
            }
        }
        
        public func layout(bounds: Rect) -> Size {
            return Helper.layout(
                bounds: bounds,
                direction: self.direction,
                alignment: self.alignment,
                inset: self.inset,
                spacing: self.spacing,
                operations: self._operations,
                views: self._views,
                cache: &self._cache
            )
        }
        
        public func size(available: Size) -> Size {
            return Helper.size(
                available: available,
                direction: self.direction,
                alignment: self.alignment,
                inset: self.inset,
                spacing: self.spacing,
                views: self._views,
                operations: self._operations
            )
        }
        
        public func views(bounds: Rect) -> [IUIView] {
            guard bounds.size.isZero == false else {
                return []
            }
            guard let firstVisible = self._visibleIndex(bounds: bounds) else {
                return []
            }
            var result: [IUIView] = [ self._views[firstVisible] ]
            let start = min(firstVisible + 1, self._views.count)
            let end = self._views.count
            for index in start ..< end {
                let view = self._views[index]
                if bounds.isIntersects(view.frame) == true {
                    result.append(view)
                } else {
                    break
                }
            }
            return result
        }
        
    }
    
}

public extension UI.Layout.List {
    
    func contains(view: IUIView) -> Bool {
        return self.views.contains(where: { $0 === view })
    }
    
    func index(view: IUIView) -> Int? {
        return self.views.firstIndex(where: { $0 === view })
    }
    
    func indices(views: [IUIView]) -> [Int] {
        return views.compactMap({ view in
            self.views.firstIndex(where: { $0 === view })
        }).sorted()
    }
    
    func animate(
        delay: TimeInterval = 0,
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        perform: @escaping (_ layout: UI.Layout.List) -> Void,
        completion: (() -> Void)? = nil
    ) {
        let animation = AnimationContext(delay: delay, duration: duration, ease: ease, perform: perform, completion: completion)
        self._animations.append(animation)
        if self._animations.count == 1 {
            self._animate(animation: animation)
        }
    }
    
    func insert(index: Int, views: [IUIView]) {
        let safeIndex = max(0, min(index, self._views.count))
        self._views.insert(contentsOf: views, at: safeIndex)
        self._cache.insert(contentsOf: Array< Size? >(repeating: nil, count: views.count), at: safeIndex)
        self._firstVisible = nil
        if self._animations.isEmpty == false {
            self._operations.append(Helper.Operation(
                type: .insert,
                indices: Array.kk_make(range: safeIndex ..< safeIndex + views.count),
                progress: .zero
            ))
        } else {
            self.setNeedForceUpdate()
        }
    }
    
    func delete(range: Range< Int >) {
        self._firstVisible = nil
        if self._animations.isEmpty == false {
            self._operations.append(Helper.Operation(
                type: .delete,
                indices: Array.kk_make(range: range),
                progress: .zero
            ))
        } else {
            self._views.removeSubrange(range)
            self._cache.removeSubrange(range)
            self.setNeedForceUpdate()
        }
    }
    
    func delete(views: [IUIView]) {
        let indices = self.indices(views: views)
        if indices.count > 0 {
            self._firstVisible = nil
            if self._animations.isEmpty == false {
                self._operations.append(Helper.Operation(
                    type: .delete,
                    indices: indices,
                    progress: .zero
                ))
            } else {
                for index in indices.reversed() {
                    self._views.remove(at: index)
                    self._cache.remove(at: index)
                }
                self.setNeedForceUpdate()
            }
        }
    }
    
}

private extension UI.Layout.List {
    
    func _destroy() {
        self._animation = nil
    }
    
    @inline(__always)
    func _visibleIndex(bounds: Rect) -> Int? {
        if let firstVisible = self._firstVisible {
            var newFirstIndex = firstVisible
            let firstItem = self._views[firstVisible]
            let isFirstVisible = bounds.isIntersects(firstItem.frame)
            let isBefore: Bool
            let isAfter: Bool
            switch self.direction {
            case .horizontal:
                isBefore = firstItem.frame.origin.x > bounds.origin.x
                isAfter = firstItem.frame.origin.x < bounds.origin.x
            case .vertical:
                isBefore = firstItem.frame.origin.y > bounds.origin.y
                isAfter = firstItem.frame.origin.y < bounds.origin.y
            }
            if isBefore == true {
                var isFounded = isFirstVisible
                for index in (0 ..< firstVisible + 1).reversed() {
                    let view = self._views[index]
                    if bounds.isIntersects(view.frame) == true {
                        newFirstIndex = index
                        isFounded = true
                    } else if isFounded == true {
                        break
                    }
                }
            } else if isAfter == true {
                for index in firstVisible ..< self._views.count {
                    let view = self._views[index]
                    if bounds.isIntersects(view.frame) == true {
                        newFirstIndex = index
                        break
                    }
                }
            }
            self._firstVisible = newFirstIndex
            return newFirstIndex
        }
        for index in 0 ..< self._views.count {
            let view = self._views[index]
            if bounds.isIntersects(view.frame) == true {
                self._firstVisible = index
                return index
            }
        }
        return nil
    }
    
    func _animate(animation: AnimationContext) {
        self.isAnimating = true
        animation.perform(self)
        self._animation = Animation.default.run(
            .custom(
                delay: animation.delay,
                duration: animation.duration,
                ease: animation.ease,
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    for operation in self._operations {
                        operation.progress = progress
                    }
                    self.setNeedForceUpdate()
                    self.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    for operation in self._operations {
                        switch operation.type {
                        case .delete:
                            for index in operation.indices.reversed() {
                                self._views.remove(at: index)
                                self._cache.remove(at: index)
                            }
                        default:
                            break
                        }
                    }
                    self._operations.removeAll()
                    if let index = self._animations.firstIndex(where: { $0 === animation }) {
                        self._animations.remove(at: index)
                    }
                    if self._animations.isEmpty == true {
                        self._animation = nil
                        self.isAnimating = false
                    }
                    self.setNeedForceUpdate()
                    self.updateIfNeeded()
                    animation.completion?()
                    if let animation = self._animations.first {
                        self._animate(animation: animation)
                    }
                }
            )
        )
    }
    
}

public extension IUILayout where Self == UI.Layout.List {
    
    @inlinable
    static func list(
        direction: UI.Layout.List.Direction,
        alignment: UI.Layout.List.Alignment = .fill,
        inset: Inset = .zero,
        spacing: Double = 0,
        views: [IUIView] = []
    ) -> UI.Layout.List {
        return .init(
            direction: direction,
            alignment: alignment,
            inset: inset,
            spacing: spacing,
            views: views
        )
    }
    
}
