//
//  KindKit
//

import KindGeometry

public struct Image {
    
    public typealias Handle = NativeImage
    public typealias Scale = Coordinate
    
    public var handle: Handle
    public var size: Size
    public var scale: Scale
    
}

extension Image : Hashable {
}

extension Image : Equatable {
}

extension Image : @unchecked Sendable {
}
