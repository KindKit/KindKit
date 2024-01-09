//
//  KindKit
//

import Foundation

public extension UI.Layout {

    final class Paging : IUILayout {
        
        public weak var delegate: IUILayoutDelegate?
        public weak var appearedView: IUIView?
        public var direction: Direction = .horizontal {
            didSet {
                guard self.direction != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        public var views: [IUIView] {
            set {
                self._views = newValue
                self.setNeedUpdate()
            }
            get { self._views }
        }
        
        private var _views: [IUIView] = []

        public init() {
        }
        
        public func layout(bounds: Rect) -> Size {
            switch self.direction {
            case .horizontal:
                var origin = bounds.origin
                for view in self._views {
                    view.frame = Rect(origin: origin, size: bounds.size)
                    origin.x += bounds.width
                }
                return Size(
                    width: bounds.width * Double(self._views.count),
                    height: bounds.height
                )
            case .vertical:
                var origin = bounds.origin
                for view in self._views {
                    view.frame = Rect(origin: origin, size: bounds.size)
                    origin.y += bounds.height
                }
                return Size(
                    width: bounds.width,
                    height: bounds.height * Double(self._views.count)
                )
            }
        }
        
        public func size(available: Size) -> Size {
            guard self._views.isEmpty == false && available.isZero == false else {
                return .zero
            }
            switch self.direction {
            case .horizontal:
                var accumulate: Double = 0
                for index in 0 ..< self._views.count {
                    let view = self._views[index]
                    let viewSize = view.size(available: available)
                    accumulate = max(accumulate, viewSize.height)
                }
                return Size(
                    width: available.width * Double(self._views.count),
                    height: accumulate
                )
            case .vertical:
                var accumulate: Double = 0
                for index in 0 ..< self._views.count {
                    let view = self._views[index]
                    let viewSize = view.size(available: available)
                    accumulate = max(accumulate, viewSize.width)
                }
                return Size(
                    width: accumulate,
                    height: available.height * Double(self._views.count)
                )
            }
        }
        
        public func views(bounds: Rect) -> [IUIView] {
            guard self._views.isEmpty == false && bounds.size.isZero == false else {
                return []
            }
            let sf, ef: Double
            switch self.direction {
            case .horizontal:
                sf = bounds.left.x / bounds.width
                ef = bounds.right.x / bounds.width
            case .vertical:
                sf = bounds.top.y / bounds.height
                ef = bounds.bottom.y / bounds.height
            }
            let s = max(0, Int(sf.roundDown))
            let e = min(Int(ef.roundUp), self._views.count)
            return Array(self._views[s..<e])
        }
        
    }
    
}

public extension UI.Layout.Paging {
    
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
    func views(_ value: [IUIView]) -> Self {
        self.views = value
        return self
    }
    
    @inlinable
    @discardableResult
    func views(_ value: () -> [IUIView]) -> Self {
        return self.views(value())
    }

    @inlinable
    @discardableResult
    func views(_ value: (Self) -> [IUIView]) -> Self {
        return self.views(value(self))
    }
    
}

public extension UI.Layout.Paging {
    
    @inlinable
    func contains(view: IUIView) -> Bool {
        return self.views.contains(where: { $0 === view })
    }
    
    @inlinable
    func index(view: IUIView) -> Int? {
        return self.views.firstIndex(where: { $0 === view })
    }
    
}

public extension IUILayout where Self == UI.Layout.Paging {
    
    @inlinable
    static func vPaging() -> UI.Layout.Paging {
        return .init().direction(.vertical)
    }
    
    @inlinable
    static func hPaging() -> UI.Layout.Paging {
        return .init()
    }
    
}
