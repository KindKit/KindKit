//
//  KindKit
//

public protocol LockTrait : Sendable {
    
    func perform(_ block: () -> Void) -> Void
    
    func perform(_ block: () throws -> Void) rethrows -> Void
    
    func perform< Return >(_ block: () -> Return) -> Return
    
    func perform< Return >(_ block: () throws -> Return) rethrows -> Return
    
}
