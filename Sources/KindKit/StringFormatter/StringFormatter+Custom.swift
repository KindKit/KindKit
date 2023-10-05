//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct Custom< InputType > : IStringFormatter {
        
        private let uuid = UUID()
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
    
}

extension StringFormatter.Custom : Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    

}
