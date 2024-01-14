//
//  KindKit
//

import KindGraphics
import KindNetwork

public protocol IQuery : AnyObject {
    
    var key: String { get }
    var isLocal: Bool { get }
    
    func local() throws -> Data
    
    func remote(
        provider: KindNetwork.Provider,
        queue: DispatchQueue,
        download: @escaping (_ progress: Progress) -> Void,
        success: @escaping (_ data: Data, _ image: Image) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) -> ICancellable
    
}
