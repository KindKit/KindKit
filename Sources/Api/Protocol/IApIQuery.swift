//
//  KindKit
//

import Foundation

public protocol IApiQuery : ICancellable {

    associatedtype Provider: IApiProvider
    
    var provider: Provider { get }
    var createAt: Date { get }

    func redirect(request: URLRequest) -> URLRequest?

}
