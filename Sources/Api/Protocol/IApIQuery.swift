//
//  KindKit
//

import Foundation

public protocol IApiQuery : ICancellable {
    
    var provider: Api.Provider { get }
    var createAt: Date { get }

    func redirect(request: URLRequest) -> URLRequest?

}
