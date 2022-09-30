//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class List : IUILayout {
        
        public unowned var delegate: IUILayoutDelegate?
        public unowned var view: IUIView?
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
        public var inset: InsetFloat {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var spacing: Float {
            didSet {
                guard self.spacing != oldValue else { return }
                self.setNeedForceUpdate()
            }
        }
        public var items: [UI.Layout.Item] {
            set {
                guard self.items != newValue else { return }
                self._items = newValue
                self._cache = Array< SizeFloat? >(repeating: nil, count: newValue.count)
                self._firstVisible = nil
                self.setNeedForceUpdate()
            }
            get { return self._items }
        }
        public var views: [IUIView] {
            set {
                self._items = newValue.compactMap({ UI.Layout.Item($0) })
                self._cache = Array< SizeFloat? >(repeating: nil, count: newValue.count)
                self._firstVisible = nil
                self.setNeedForceUpdate()
            }
            get { return self._items.compactMap({ $0.view }) }
        }
        public private(set) var isAnimating: Bool
        
        private var _items: [UI.Layout.Item]
        private var _animations: [AnimationContext]
        private var _operations: [Helper.Operation]
        private var _cache: [SizeFloat?]
        private var _firstVisible: Int?
        private var _animation: IAnimationTask? {
            willSet { self._animation?.cancel() }
        }

        public init(
            direction: Direction,
            alignment: Alignment = .fill,
            inset: InsetFloat = .zero,
            spacing: Float = 0,
            items: [UI.Layout.Item] = []
        ) {
            self.direction = direction
            self.alignment = alignment
            self.inset = inset
            self.spacing = spacing
            self.isAnimating = false
            self._items = items
            self._animations = []
            self._operations = []
            self._cache = Array< SizeFloat? >(repeating: nil, count: items.count)
        }

        public convenience init(
            direction: Direction,
            alignment: Alignment = .fill,
            inset: InsetFloat = .zero,
            spacing: Float = 0,
            views: [IUIView]
        ) {
            self.init(
                direction: direction,
                alignment: alignment,
                inset: inset,
                spacing: spacing,
                items: views.compactMap({ return UI.Layout.Item($0) })
            )
        }
        
        deinit {
            self._destroy()
        }
        
        public func invalidate(item: UI.Layout.Item) {
            if let index = self._items.firstIndex(of: item) {
                self._cache[index] = nil
            }
        }
        
        public func layout(bounds: RectFloat) -> SizeFloat {
            return Helper.layout(
                bounds: bounds,
                direction: self.direction,
                alignment: self.alignment,
                inset: self.inset,
                spacing: self.spacing,
                operations: self._operations,
                items: self._items,
                cache: &self._cache
            )
        }
        
        public func size(available: SizeFloat) -> SizeFloat {
            return Helper.size(
                available: available,
                direction: self.direction,
                alignment: self.alignment,
                inset: self.inset,
                spacing: self.spacing,
                items: self._items,
                operations: self._operations
            )
        }
        
        public func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard bounds.size.isZero == false else {
                return []
            }
            guard let firstVisible = self._visibleIndex(bounds: bounds) else {
                return []
            }
            var result: [UI.Layout.Item] = [ self._items[firstVisible] ]
            let start = min(firstVisible + 1, self._items.count)
            let end = self._items.count
            for index in start ..< end {
                let item = self._items[index]
                if bounds.isIntersects(item.frame) == true {
                    result.append(item)
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
        guard let item = view.appearedItem else { return false }
        return self.contains(item: item)
    }
    
    func contains(item: UI.Layout.Item) -> Bool {
        return self.items.contains(item)
    }
    
    func index(view: IUIView) -> Int? {
        guard let item = view.appearedItem else { return nil }
        return self.index(item: item)
    }
    
    func index(item: UI.Layout.Item) -> Int? {
        return self.items.firstIndex(of: item)
    }
    
    func indices(items: [UI.Layout.Item]) -> [Int] {
        return items.compactMap({ item in self.items.firstIndex(of: item) }).sorted()
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
    
    func insert(index: Int, items: [UI.Layout.Item]) {
        let safeIndex = max(0, min(index, self._items.count))
        self._items.insert(contentsOf: items, at: safeIndex)
        self._cache.insert(contentsOf: Array< SizeFloat? >(repeating: nil, count: items.count), at: safeIndex)
        self._firstVisible = nil
        if self._animations.isEmpty == false {
            self._operations.append(Helper.Operation(
                type: .insert,
                indices: Array(range: safeIndex ..< safeIndex + items.count),
                progress: .zero
            ))
        } else {
            self.setNeedForceUpdate()
        }
    }
    
    func insert(index: Int, views: [IUIView]) {
        self.insert(
            index: index,
            items: views.compactMap({ return UI.Layout.Item($0) })
        )
    }
    
    func delete(range: Range< Int >) {
        self._firstVisible = nil
        if self._animations.isEmpty == false {
            self._operations.append(Helper.Operation(
                type: .delete,
                indices: Array(range: range),
                progress: .zero
            ))
        } else {
            self._items.removeSubrange(range)
            self._cache.removeSubrange(range)
            self.setNeedForceUpdate()
        }
    }
    
    func delete(items: [UI.Layout.Item]) {
        let indices = self.indices(items: items)
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
                    self._items.remove(at: index)
                    self._cache.remove(at: index)
                }
                self.setNeedForceUpdate()
            }
        }
    }
    
    func delete(views: [IUIView]) {
        self.delete(
            items: views.compactMap({ return $0.appearedItem })
        )
    }
    
}

private extension UI.Layout.List {
    
    func _destroy() {
        self._animation = nil
    }
    
    @inline(__always)
    func _visibleIndex(bounds: RectFloat) -> Int? {
        if let firstVisible = self._firstVisible {
            var newFirstIndex = firstVisible
            let firstItem = self._items[firstVisible]
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
                    let item = self._items[index]
                    if bounds.isIntersects(item.frame) == true {
                        newFirstIndex = index
                        isFounded = true
                    } else if isFounded == true {
                        break
                    }
                }
            } else if isAfter == true {
                for index in firstVisible ..< self._items.count {
                    let item = self._items[index]
                    if bounds.isIntersects(item.frame) == true {
                        newFirstIndex = index
                        break
                    }
                }
            }
            self._firstVisible = newFirstIndex
            return newFirstIndex
        }
        for index in 0 ..< self._items.count {
            let item = self._items[index]
            if bounds.isIntersects(item.frame) == true {
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
            delay: animation.delay,
            duration: animation.duration,
            ease: animation.ease,
            processing: { [unowned self] progress in
                for operation in self._operations {
                    operation.progress = progress
                }
                self.setNeedForceUpdate()
                self.updateIfNeeded()
            },
            completion: { [unowned self] in
                for operation in self._operations {
                    switch operation.type {
                    case .delete:
                        for index in operation.indices.reversed() {
                            self._items.remove(at: index)
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
    }
    
}

public extension IUILayout where Self == UI.Layout.List {
    
    @inlinable
    static func list(
        direction: UI.Layout.List.Direction,
        alignment: UI.Layout.List.Alignment = .fill,
        inset: InsetFloat = .zero,
        spacing: Float = 0,
        items: [UI.Layout.Item] = []
    ) -> UI.Layout.List {
        return .init(
            direction: direction,
            alignment: alignment,
            inset: inset,
            spacing: spacing,
            items: items
        )
    }
    
    @inlinable
    static func list(
        direction: UI.Layout.List.Direction,
        alignment: UI.Layout.List.Alignment = .fill,
        inset: InsetFloat = .zero,
        spacing: Float = 0,
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
