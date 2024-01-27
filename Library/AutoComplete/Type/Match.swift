//
//  KindKit
//

public struct Match {
    
    public let estimate: String?
    
    public init< Estimate : StringProtocol >(
        estimate: Estimate
    ) {
        if estimate.count > 0 {
            self.estimate = .init(estimate)
        } else {
            self.estimate = nil
        }
    }
    
}
