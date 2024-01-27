//
//  KindKit
//

import KindGraphics

public protocol Filter : AnyObject, Sendable {
    
    var name: String { get }
    
    func apply(_ image: Image) -> Image?
    
}
