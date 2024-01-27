//
//  KindKit
//

#if os(iOS)

import UIKit

extension DateInputView {
    
    public enum Mode {
        
        case time
        case date
        case dateTime
        
    }
    
}

extension DateInputView.Mode {
    
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
