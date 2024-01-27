//
//  KindKit
//

public protocol MapTrait {
    
    func map< Result >(_ block: (Self) -> Result) -> Result

}

public extension MapTrait {
    
    @inlinable
    func map< Result >(_ block: (Self) -> Result) -> Result {
        return block(self)
    }
    
}
