//
//  KindKit
//

import Foundation
import CoreImage

public extension QrCode {
    
    enum Correction {
        
        case low
        case medium
        case quartile
        case high
        
    }
    
}

extension QrCode.Correction {
    
    var string: String {
        switch self {
        case .low: return "L"
        case .medium: return "M"
        case .quartile: return "Q"
        case .high: return "H"
        }
    }
    
}
