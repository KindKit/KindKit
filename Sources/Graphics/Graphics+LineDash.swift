//
//  KindKit
//

import Foundation

public extension Graphics {

    struct LineDash : Equatable {
        
        public let phase: Float
        public let lengths: [Float]
        
        public init(
            phase: Float,
            lengths: [Float]
        ) {
            self.phase = phase
            self.lengths = lengths
        }
        
    }

}
