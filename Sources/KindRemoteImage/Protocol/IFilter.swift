//
//  KindKit
//

import KindGraphics

public protocol IFilter : AnyObject {
    
    var name: String { get }
    
    func apply(_ image: Image) -> Image?
    
}
