//
//  KindKit
//

import Foundation

public extension RemoteImage.Filter {

    final class Thumbnail : IRemoteImageFilter {

        public let size: Size
        public var name: String {
            return "\(self.size.width)x\(self.size.height)"
        }
        
        public init(_ size: Size) {
            self.size = size
        }
        
        public convenience init(
            _ size: Double
        ) {
            self.init(.init(
                width: size,
                height: size
            ))
        }
        
        public func apply(_ image: UI.Image) -> UI.Image? {
            return image.scaleTo(size: self.size)
        }
        
    }

}
