//
//  KindKit
//

import Foundation

public protocol IRemoteImageFilter : AnyObject {
    
    var name: String { get }
    
    func apply(_ image: Image) -> Image?
    
}
