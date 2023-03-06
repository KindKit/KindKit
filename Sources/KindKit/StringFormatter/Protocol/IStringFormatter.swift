//
//  KindKit
//

import Foundation

public protocol IStringFormatter {
    
    associatedtype InputType

    func format(_ input: InputType) -> String

}
