//
//  KindKit
//

import Foundation
import KindCore

public final class CustomFormatter< Input > : FormatterTrait {
    
    private let closure: (Input) -> String
    
    public init(
        _ closure: @escaping (Input) -> String
    ) {
        self.closure = closure
    }
    
    public func format(_ input: Input) -> String {
        return self.closure(input)
    }
    
}

extension CustomFormatter : Equatable {
    
    public static func == (lhs: CustomFormatter, rhs: CustomFormatter) -> Bool {
        return lhs === rhs
    }
    
}
