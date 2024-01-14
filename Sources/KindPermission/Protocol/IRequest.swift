//
//  KindKit
//

public protocol IRequest {
    
    var status: Status { get }
    
    func request(_ completion: @escaping () -> Void)
    
}
