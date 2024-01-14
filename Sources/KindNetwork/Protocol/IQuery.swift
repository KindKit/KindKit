//
//  KindKit
//

import Foundation

public protocol IQuery : ICancellable {
    
    var provider: Provider { get }
    var createAt: Date { get }

    func redirect(request: URLRequest) -> URLRequest?

}
