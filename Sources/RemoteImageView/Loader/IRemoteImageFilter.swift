//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitView

public protocol IRemoteImageFilter : AnyObject {
    
    var name: String { get }
    
    func apply(_ image: Image) -> Image?
    
}
