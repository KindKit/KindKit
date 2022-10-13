//
//  KindKit
//

import Foundation

public extension NSNumber {

    class func kk_number(from string: NSString) -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current;
        formatter.formatterBehavior = .behavior10_4;
        formatter.numberStyle = .none;

        var number = formatter.number(from: string as String)
        if number == nil {
            if formatter.decimalSeparator == "." {
                formatter.decimalSeparator = ","
            } else {
                formatter.decimalSeparator = "."
            }
            number = formatter.number(from: string as String)
        }
        return number
    }
    
    class func kk_number(from string: String) -> NSNumber? {
        return self.kk_number(from: string as NSString)
    }
    
    class func kk_number(from string: Substring) -> NSNumber? {
        return self.kk_number(from: string as NSString)
    }

}
