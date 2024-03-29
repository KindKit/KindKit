//
//  KindKit
//

import Foundation

public extension Graphics {

    struct LineDash : Equatable {
        
        public let phase: Double
        public let lengths: [Double]
        
        public init(
            phase: Double,
            lengths: [Double]
        ) {
            self.phase = phase
            self.lengths = lengths
        }
        
    }

}
