//
//  KindKit
//

import Foundation

public protocol IRemoteImageQuery : AnyObject {
    
    var key: String { get }
    var isLocal: Bool { get }
    
    func local() throws -> Data
    
    func remote(
        provider: IApiProvider,
        queue: DispatchQueue,
        download: @escaping (_ progress: Progress) -> Void,
        success: @escaping (_ data: Data, _ image: Image) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) -> ICancellable
    
}
