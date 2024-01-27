//
//  KindKit
//

public protocol DebugTrait {

    func buildInfo() -> any Info

}

extension CustomStringConvertible where Self : DebugTrait {
    
    public var description: String {
        return self.buildInfo().string()
    }
    
}

extension CustomDebugStringConvertible where Self : DebugTrait {
    
    public var debugDescription: String {
        return self.buildInfo().string()
    }
    
}
