//
//  KindKit
//

extension DebugTrait where Self : BinaryFloatingPoint & CustomStringConvertible {
    
    public func buildInfo() -> Info {
        return StringInfo(self.description)
    }

}

extension Float : DebugTrait {
}

extension Double : DebugTrait {
}
