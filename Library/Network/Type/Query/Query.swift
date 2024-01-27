//
//  KindKit
//

import Foundation

public protocol Query : CancelTrait, Sendable {
    
    var provider: Provider { get }
    var createAt: Date { get }

    func redirect(request: URLRequest) -> URLRequest?

}
