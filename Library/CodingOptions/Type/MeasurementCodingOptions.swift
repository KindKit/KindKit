//
//  KindKit
//

import Foundation

public struct MeasurementCodingOptions : CodingOptions {
    
    public let unit: Unit
    
    public init(unit: Unit) {
        self.unit = unit
    }
    
}

extension MeasurementCodingOptions : @unchecked Sendable {
}
