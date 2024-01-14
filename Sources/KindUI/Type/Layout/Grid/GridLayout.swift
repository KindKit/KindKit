//
//  KindKit
//

import KindMath

public final class GridLayout : ILayout {
    
    public weak var delegate: ILayoutDelegate?
    public weak var appearedView: IView?
    public var direction: Direction {
        didSet {
            guard self.direction != oldValue else { return }
            self._pass = nil
            self.setNeedUpdate()
        }
    }
    public var alignment: Alignment {
        didSet {
            guard self.alignment != oldValue else { return }
            self._pass = nil
            self.setNeedUpdate()
        }
    }
    public var inset: Inset {
        didSet {
            guard self.inset != oldValue else { return }
            self._pass = nil
            self.setNeedUpdate()
        }
    }
    public var columns: Int {
        didSet {
            guard self.columns != oldValue else { return }
            self._pass = nil
            self.setNeedUpdate()
        }
    }
    public var spacing: Point {
        didSet {
            guard self.spacing != oldValue else { return }
            self._pass = nil
            self.setNeedUpdate()
        }
    }
    public var views: [IView] {
        set {
            self._views = newValue
            self._cache = Array< Size? >(repeating: nil, count: newValue.count)
            self._pass = nil
            self.setNeedUpdate()
        }
        get { self._views }
    }
    
    private var _views: [IView]
    private var _pass: Pass?
    private var _cache: [Size?] = []
    
    public init(
        direction: Direction,
        alignment: Alignment,
        inset: Inset = .zero,
        columns: Int,
        spacing: Point = .zero,
        views: [IView] = []
    ) {
        self.direction = direction
        self.alignment = alignment
        self.inset = inset
        self.columns = columns
        self.spacing = spacing
        self._views = views
        self._cache = Array< Size? >(repeating: nil, count: views.count)
    }
    
    public func invalidate() {
        for index in self._cache.startIndex ..< self._cache.endIndex {
            self._cache[index] = nil
        }
        self._pass = nil
    }
    
    public func invalidate(_ view: IView) {
        if let index = self._views.firstIndex(where: { view === $0 }) {
            self._cache[index] = nil
        }
    }
    
    public func layout(bounds: Rect) -> Size {
        let pass = self._pass(available: bounds.size)
        pass.layout(
            bounds: bounds.inset(self.inset),
            direction: self.direction,
            alignment: self.alignment,
            spacing: self.spacing
        )
        return pass.bounding.inset(-self.inset)
    }
    
    public func size(available: Size) -> Size {
        var pass = self._pass(available: available)
        if pass.available !~ available {
            pass = self._makePass(available)
        }
        return pass.bounding.inset(-self.inset)
    }
    
    public func views(bounds: Rect) -> [IView] {
        guard bounds.size.isZero == false else {
            return []
        }
        let lower: Double
        let upper: Double
        switch self.direction {
        case .horizontal:
            lower = bounds.x
            upper = lower + bounds.width
        case .vertical:
            lower = bounds.y
            upper = lower + bounds.height
        }
        return self._views(
            pass: self._pass(available: bounds.size),
            lower: lower,
            upper: upper
        )
    }
    
}

public extension GridLayout {
    
    func contains(_ view: IView) -> Bool {
        return self._views.contains(where: { $0 === view })
    }
    
    func index(_ view: IView) -> Int? {
        return self._views.firstIndex(where: { $0 === view })
    }
    
    func indices(views: [IView]) -> [Int] {
        return views.compactMap({ view in
            self._views.firstIndex(where: { $0 === view })
        }).sorted()
    }
    
    func insert(index: Int, views: [IView]) {
        let safeIndex = max(0, min(index, self._views.count))
        self._views.insert(contentsOf: views, at: safeIndex)
        self._cache.insert(contentsOf: Array< Size? >(repeating: nil, count: views.count), at: safeIndex)
        self._pass = nil
        self.setNeedUpdate()
    }
    
    func insert(index: Int, view: IView) {
        self.insert(index: index, views: [ view ])
    }
    
    func delete(range: Range< Int >) {
        self._views.removeSubrange(range)
        self._cache.removeSubrange(range)
        self._pass = nil
        self.setNeedUpdate()
    }
    
    func delete(views: [IView]) {
        let indices = self.indices(views: views)
        if indices.count > 0 {
            for index in indices.reversed() {
                self._views.remove(at: index)
                self._cache.remove(at: index)
            }
            self.setNeedUpdate()
        }
    }
    
    @inlinable
    func delete(view: IView) {
        self.delete(views: [ view ])
    }
    
}

private extension GridLayout {
    
    func _makePass(_ available: Size) -> Pass {
        return Self.pass(
            available: available.inset(self.inset),
            direction: self.direction,
            columns: self.columns,
            spacing: self.spacing,
            views: self.views,
            cache: &self._cache
        )
    }
    
    func _pass(available: Size) -> Pass {
        if self._pass == nil {
            self._pass = self._makePass(available)
        }
        return self._pass!
    }
    
    func _firstRow(pass: Pass, lower: Double, upper: Double) -> Int? {
        for index in 0 ..< pass.rows.count {
            let row = pass.rows[index]
            let rowLower = row.origin
            let rowUpper = rowLower + row.size
            if (lower <~ rowUpper && upper >~ rowLower) == true {
                return index
            }
        }
        return nil
    }
    
    func _views(pass: Pass, lower: Double, upper: Double) -> [IView] {
        guard let first = self._firstRow(pass: pass, lower: lower, upper: upper) else {
            return []
        }
        var result: [IView] = pass.rows[first].cells.map({ $0.view })
        let start = min(first + 1, pass.rows.count)
        let end = pass.rows.count
        for index in start ..< end {
            let row = pass.rows[index]
            let rowLower = row.origin
            let rowUpper = rowLower + row.size
            if (lower <~ rowUpper && upper >~ rowLower) == true {
                result.append(contentsOf: row.cells.map({ $0.view }))
            } else {
                break
            }
        }
        return result
    }
    
}
