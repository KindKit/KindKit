//
//  KindKitApi
//

import Foundation

public struct ApiRequestRedirectOption : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static var enabled = ApiRequestRedirectOption(rawValue: 1 << 0)
    public static var method = ApiRequestRedirectOption(rawValue: 1 << 1)
    public static var authorization = ApiRequestRedirectOption(rawValue: 1 << 2)
    
}

public protocol IApiRequest : AnyObject {

    var retries: TimeInterval { get }
    var delay: TimeInterval { get }
    var redirect: ApiRequestRedirectOption { get }
    #if DEBUG
    var logging: ApiLogging { get }
    #endif

    func urlRequest(provider: IApiProvider) -> URLRequest?
    
}
