//
//  KindKit
//

import KindAnimation
import KindMath

public final class ListLayout : ILayout {
    
    public weak var delegate: ILayoutDelegate?
    public weak var appearedView: IView?
    public var direction: Direction = .vertical {
        didSet {
            guard self.direction != oldValue else { return }
            self._firstVisible = nil
            self.setNeedUpdate()
        }
    }
    public var alignment: Alignment = .fill {
        didSet {
            guard self.alignment != oldValue else { return }
            self.setNeedUpdate()
        }
    }
    public var inset: Inset = .zero {
        didSet {
            guard self.inset != oldValue else { return }
            self.setNeedUpdate()
        }
    }
    public var spacing: Double = 0 {
        didSet {
            guard self.spacing != oldValue else { return }
            self.setNeedUpdate()
        }
    }
    public var views: [IView] {
        set {
            self._views = newValue
            self._cache = Array< Size? >(repeating: nil, count: newValue.count)
            self._firstVisible = nil
            self.setNeedUpdate()
        }
        get { self._views }
    }
    public private(set) var isAnimating: Bool = false
    
    private var _views: [IView] = []
    private var _animations: [AnimationContext] = []
    private var _operations: [Helper.Operation] = []
    private var _cache: [Size?] = []
    private var _firstVisible: Int?
    private var _animation: ICancellable? {
        willSet { self._animation?.cancel() }
    }

    public init() {}
    
    deinit {
        self._destroy()
    }
    
    public func invalidate() {
        for index in self._cache.startIndex ..< self._cache.endIndex {
            self._cache[index] = nil
        }
    }
    
    public func invalidate(_ view: IView) {
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
    
    public func views(bounds: Rect) -> [IView] {
        guard bounds.size.isZero == false else {
            return []
        }
        guard let firstVisible = self._visibleIndex(bounds: bounds) else {
            return []
        }
        var result: [IView] = [ self._views[firstVisible] ]
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

public extension ListLayout {
    
    @inlinable
    @discardableResult
    func direction(_ value: Direction) -> Self {
        self.direction = value
        return self
    }
    
    @inlinable
    @discardableResult
    func direction(_ value: () -> Direction) -> Self {
        return self.direction(value())
    }

    @inlinable
    @discardableResult
    func direction(_ value: (Self) -> Direction) -> Self {
        return self.direction(value(self))
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: Alignment) -> Self {
        self.alignment = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alignment(_ value: () -> Alignment) -> Self {
        return self.alignment(value())
    }

    @inlinable
    @discardableResult
    func alignment(_ value: (Self) -> Alignment) -> Self {
        return self.alignment(value(self))
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
    func spacing(_ value: Double) -> Self {
        self.spacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func spacing(_ value: () -> Double) -> Self {
        return self.spacing(value())
    }

    @inlinable
    @discardableResult
    func spacing(_ value: (Self) -> Double) -> Self {
        return self.spacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func views(_ value: [IView]) -> Self {
        self.views = value
        return self
    }
    
    @inlinable
    @discardableResult
    func views(_ value: () -> [IView]) -> Self {
        return self.views(value())
    }

    @inlinable
    @discardableResult
    func views(_ value: (Self) -> [IView]) -> Self {
        return self.views(value(self))
    }
    
}

public extension ListLayout {
    
    func contains(view: IView) -> Bool {
        return self.views.contains(where: { $0 === view })
    }
    
    func index(view: IView) -> Int? {
        return self.views.firstIndex(where: { $0 === view })
    }
    
    func index(`where`: (IView) -> Bool) -> Int? {
        return self.views.firstIndex(where: `where`)
    }
    
    func index< View : IView >(`as`: View.Type, `where`: (View) -> Bool) -> Int? {
        return self.views.firstIndex(where: {
            switch $0 {
            case let view as View: return `where`(view)
            default: return false
            }
        })
    }
    
    func indices(views: [IView]) -> [Int] {
        return views.compactMap({ view in
            self.views.firstIndex(where: { $0 === view })
        }).sorted()
    }
    
    func animate(
        delay: TimeInterval = 0,
        duration: TimeInterval,
        ease: KindAnimation.IEase = KindAnimation.Ease.Linear(),
        perform: @escaping (_ layout: ListLayout) -> Void,
        completion: (() -> Void)? = nil
    ) {
        let animation = AnimationContext(delay: delay, duration: duration, ease: ease, perform: perform, completion: completion)
        self._animations.append(animation)
        if self._animations.count == 1 {
            self._animate(animation: animation)
        }
    }
    
    func insert(index: Int, views: [IView]) {
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
            self.setNeedUpdate()
        }
    }
    
    func insert(index: Int, view: IView) {
        self.insert(index: index, views: [ view ])
    }
    
    func delete(index: Int) {
        guard index < self._views.count else {
            return
        }
        self._firstVisible = nil
        if self._animations.isEmpty == false {
            self._operations.append(Helper.Operation(
                type: .delete,
                indices: [ index ],
                progress: .zero
            ))
        } else {
            self._views.remove(at: index)
            self._cache.remove(at: index)
            self.setNeedUpdate()
        }
    }
    
    func delete(range: Range< Int >) {
        let range = Range< Int >(uncheckedBounds: (
            lower: min(max(range.lowerBound, 0), self._views.count),
            upper: min(max(range.upperBound, 0), self._views.count)
        ))
        guard range.isEmpty == false else {
            return
        }
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
            self.setNeedUpdate()
        }
    }
    
    func delete(views: [IView]) {
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
                self.setNeedUpdate()
            }
        }
    }
    
    func delete(view: IView) {
        self.delete(views: [ view ])
    }
    
}

private extension ListLayout {
    
    func _destroy() {
        self._animation = nil
    }
    
    @inline(__always)
    func _visibleIndex(bounds: Rect) -> Int? {
        if let firstVisible = self._firstVisible {
            if firstVisible >= self._views.startIndex && firstVisible < self._views.endIndex {
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
        self._animation = KindAnimation.default.run(
            .custom(
                delay: animation.delay,
                duration: animation.duration,
                ease: animation.ease,
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    for operation in self._operations {
                        operation.progress = progress
                    }
                    self.update()
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
                    self.update()
                    animation.completion?()
                    if let animation = self._animations.first {
                        self._animate(animation: animation)
                    }
                }
            )
        )
    }
    
}
