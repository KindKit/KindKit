//
//  KindKit
//

import Foundation
import KindCore

public final class CustomFormatter< InputType > : IFormatter {
    
    private let closure: (InputType) -> String
    
    public init(
        _ closure: @escaping (InputType) -> String
    ) {
        self.closure = closure
    }
    
    public func format(_ input: InputType) -> String {
        return self.closure(input)
    }
    
}

extension CustomFormatter : Equatable {
    
    public static func == (lhs: CustomFormatter, rhs: CustomFormatter) -> Bool {
        return lhs === rhs
    }
    
}
