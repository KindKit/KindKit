//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public final class ListLayout : ILayout {
    
    public unowned var delegate: ILayoutDelegate?
    public unowned var view: IView?
    public var direction: Direction {
        didSet(oldValue) {
            guard self.direction != oldValue else { return }
            self._firstVisible = nil
            self.setNeedForceUpdate()
        }
    }
    public var alignment: Alignment {
        didSet(oldValue) {
            guard self.alignment != oldValue else { return }
            self.setNeedForceUpdate()
        }
    }
    public var inset: InsetFloat {
        didSet(oldValue) {
            guard self.inset != oldValue else { return }
            self.setNeedForceUpdate()
        }
    }
    public var spacing: Float {
        didSet(oldValue) {
            guard self.spacing != oldValue else { return }
            self.setNeedForceUpdate()
        }
    }
    public var items: [LayoutItem] {
        set(value) {
            self._items = value
            self._cache = Array< SizeFloat? >(repeating: nil, count: value.count)
            self._firstVisible = nil
            self.setNeedForceUpdate()
        }
        get { return self._items }
    }
    public var views: [IView] {
        set(value) {
            self._items = value.compactMap({ return LayoutItem(view: $0) })
            self._cache = Array< SizeFloat? >(repeating: nil, count: value.count)
            self._firstVisible = nil
            self.setNeedForceUpdate()
        }
        get { return self._items.compactMap({ $0.view }) }
    }
    public private(set) var isAnimating: Bool
    
    private var _items: [LayoutItem]
    private var _animations: [AnimationContext]
    private var _operations: [Helper.Operation]
    private var _cache: [SizeFloat?]
    private var _firstVisible: Int?

    public init(
        direction: Direction,
        alignment: Alignment = .fill,
        inset: InsetFloat = .zero,
        spacing: Float = 0,
        items: [LayoutItem] = []
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
        views: [IView]
    ) {
        self.init(
            direction: direction,
            alignment: alignment,
            inset: inset,
            spacing: spacing,
            items: views.compactMap({ return LayoutItem(view: $0) })
        )
    }
    
    public func contains(view: IView) -> Bool {
        guard let item = view.item else { return false }
        return self.contains(item: item)
    }
    
    public func contains(item: LayoutItem) -> Bool {
        return self.items.contains(where: { $0 === item })
    }
    
    public func index(view: IView) -> Int? {
        guard let item = view.item else { return nil }
        return self.index(item: item)
    }
    
    public func index(item: LayoutItem) -> Int? {
        return self.items.firstIndex(where: { $0 === item })
    }
    
    public func indices(items: [LayoutItem]) -> [Int] {
        return items.compactMap({ item in self.items.firstIndex(where: { $0 === item }) })
    }
    
    public func animate(
        delay: TimeInterval = 0,
        duration: TimeInterval,
        ease: IAnimationEase = Animation.Ease.Linear(),
        perform: @escaping (_ layout: ListLayout) -> Void,
        completion: (() -> Void)? = nil
    ) {
        let animation = AnimationContext(delay: delay, duration: duration, ease: ease, perform: perform, completion: completion)
        self._animations.append(animation)
        if self._animations.count == 1 {
            self._animate(animation: animation)
        }
    }
    
    public func insert(index: Int, items: [LayoutItem]) {
        let safeIndex = max(0, min(index, self._items.count))
        self._items.insert(contentsOf: items, at: safeIndex)
        self._cache.insert(contentsOf: Array< SizeFloat? >(repeating: nil, count: items.count), at: safeIndex)
        self._firstVisible = nil
        if self._animations.isEmpty == false {
            self._operations.append(Helper.Operation(
                type: .insert,
                indices: Set< Int >(range: safeIndex ..< safeIndex + items.count),
                progress: .zero
            ))
        } else {
            self.setNeedForceUpdate()
        }
    }
    
    public func insert(index: Int, views: [IView]) {
        self.insert(
            index: index,
            items: views.compactMap({ return LayoutItem(view: $0) })
        )
    }
    
    public func delete(range: Range< Int >) {
        self._firstVisible = nil
        if self._animations.isEmpty == false {
            self._operations.append(Helper.Operation(
                type: .delete,
                indices: Set< Int >(range: range),
                progress: .zero
            ))
        } else {
            self._items.removeSubrange(range)
            self._cache.removeSubrange(range)
            self.setNeedForceUpdate()
        }
    }
    
    public func delete(items: [LayoutItem]) {
        let indices = items.compactMap({ item in self.items.firstIndex(where: { $0 === item }) }).sorted()
        if indices.count > 0 {
            self._firstVisible = nil
            if self._animations.isEmpty == false {
                self._operations.append(Helper.Operation(
                    type: .delete,
                    indices: Set< Int >(indices),
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
    
    public func delete(views: [IView]) {
        self.delete(
            items: views.compactMap({ return $0.item })
        )
    }
    
    public func invalidate(item: LayoutItem) {
        if let index = self._items.firstIndex(where: { $0 === item }) {
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
    
    public func items(bounds: RectFloat) -> [LayoutItem] {
        guard let firstVisible = self._visibleIndex(bounds: bounds) else {
            return []
        }
        var result: [LayoutItem] = [ self._items[firstVisible] ]
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

public extension ListLayout {
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    enum Alignment {
        case leading
        case center
        case trailing
        case fill
    }
    
}

private extension ListLayout {
    
    class AnimationContext {
        
        let delay: TimeInterval
        let duration: TimeInterval
        let ease: IAnimationEase
        let perform: (_ layout: ListLayout) -> Void
        let completion: (() -> Void)?
        
        public init(
            delay: TimeInterval,
            duration: TimeInterval,
            ease: IAnimationEase,
            perform: @escaping (_ layout: ListLayout) -> Void,
            completion: (() -> Void)?
        ) {
            self.delay = delay
            self.duration = duration
            self.ease = ease
            self.perform = perform
            self.completion = completion
        }

    }
    
}

private extension ListLayout {
    
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
        Animation.default.run(
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
                self.setNeedForceUpdate()
                self.updateIfNeeded()
                self._operations.removeAll()
                if let index = self._animations.firstIndex(where: { $0 === animation }) {
                    self._animations.remove(at: index)
                }
                if let animation = self._animations.first {
                    self._animate(animation: animation)
                } else {
                    self.isAnimating = false
                }
                animation.completion?()
            }
        )
    }
    
}
