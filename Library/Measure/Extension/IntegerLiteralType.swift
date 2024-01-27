//
//  KindKit
//

public extension IntegerLiteralType {
    
    @inlinable
    func `as`(angle unit: Angle.Unit) -> Angle {
        return .init(value: .init(self), unit: unit)
    }
    
    @inlinable
    func `as`(area unit: Area.Unit) -> Area {
        return .init(value: .init(self), unit: unit)
    }
    
    @inlinable
    func `as`(length unit: Length.Unit) -> Length {
        return .init(value: .init(self), unit: unit)
    }
    
    @inlinable
    func `as`(time unit: Time.Unit) -> Time {
        return .init(value: .init(self), unit: unit)
    }
    
    @inlinable
    func `as`(volume unit: Volume.Unit) -> Volume {
        return .init(value: .init(self), unit: unit)
    }
    
}
