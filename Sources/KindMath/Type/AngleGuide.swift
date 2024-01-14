//
//  KindKit
//

public final class AngleGuide : IGuide {
    
    public var isEnabled: Bool
    public var angle: Angle
    public var snap: Angle
    
    public init(
        isEnabled: Bool = true,
        angle: Angle,
        snap: Angle
    ) {
        self.isEnabled = isEnabled
        self.angle = angle
        self.snap = snap
    }
    
    public func guide(_ angle: Angle) -> Angle {
        guard self.isEnabled == true else { return angle }
        let s = angle.radians / self.angle.radians
        let p = self.angle.radians * s.roundDown
        let n = self.angle.radians * s.roundUp
        let pd = angle.radians - p
        let nd = n - angle.radians
        let md = min(pd, nd)
        if md < self.snap.radians {
            if pd < nd {
                return .init(radians: p)
            } else if nd < pd {
                return .init(radians: n)
            }
        }
        return angle
    }

}

public extension AngleGuide {
    
    @inlinable
    @discardableResult
    func angle(_ value: Angle) -> Self {
        self.angle = value
        return self
    }
    
    @inlinable
    @discardableResult
    func angle(_ value: () -> Angle) -> Self {
        return self.angle(value())
    }

    @inlinable
    @discardableResult
    func angle(_ value: (Self) -> Angle) -> Self {
        return self.angle(value(self))
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: Angle) -> Self {
        self.snap = value
        return self
    }
    
    @inlinable
    @discardableResult
    func snap(_ value: () -> Angle) -> Self {
        return self.snap(value())
    }

    @inlinable
    @discardableResult
    func snap(_ value: (Self) -> Angle) -> Self {
        return self.snap(value(self))
    }
    
}
