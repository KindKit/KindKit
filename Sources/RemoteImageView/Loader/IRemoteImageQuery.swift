//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitApi
import KindKitView

public protocol IRemoteImageQuery : AnyObject {
    
    var key: String { get }
    var isLocal: Bool { get }
    
    func localData() throws -> Data
    
    func download(
        provider: IApiProvider,
        download: @escaping (_ progress: Progress) -> Void,
        success: @escaping (_ data: Data, _ image: Image) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) -> ICancellable
    
}
