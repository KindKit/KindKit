//
//  KindKit
//

public protocol Request : Sendable {
    
    func status() async -> Status
    
    func request() async
    
}
