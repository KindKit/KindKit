//
//  KindKit
//

import Foundation

public extension RemoteImage {
    
    enum Error : Swift.Error {
        
        case invalidRequest
        case invalidResponse
        case notConnectedToInternet
        case untrustedInternetConnection
        case timeout
        
        case unknown
        
    }

}
