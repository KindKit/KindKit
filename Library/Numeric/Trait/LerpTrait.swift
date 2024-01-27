//
//  KindKit
//

public protocol LerpTrait {

    func lerp(_ to: Self, by progress: Percent) -> Self

}

extension LerpTrait where Self : BinaryFloatingPoint {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        let v = Self(progress.value)
        return ((1 - v) * self) + (v * to)
    }

}
