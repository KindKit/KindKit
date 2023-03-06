//
//  KindKit
//

#if os(iOS)

import Foundation
import UIKit

public extension UI.View.Input.Date {
    
    enum Mode {
        
        case time
        case date
        case dateTime
        
    }
    
}

extension UI.View.Input.Date.Mode {
    
    @inlinable
    var datePickerMode: UIDatePicker.Mode {
        switch self {
        case .time: return .time
        case .date: return .date
        case .dateTime: return .dateAndTime
        }
    }
    
}

#endif
