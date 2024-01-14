//
//  KindKit
//

extension IEntity where Self : BinaryFloatingPoint & CustomStringConvertible {
    
    public func debugInfo() -> Info {
        return .string(self.description)
    }

}

extension Float : IEntity {
}

extension Double : IEntity {
}
