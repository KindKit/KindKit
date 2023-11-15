//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    final class Condition< ThenType : IInputSuggestion, ElseType : IInputSuggestion > : IInputSuggestion {
        
        public let condition: (String) -> Bool
        public let then: ThenType
        public let `else`: ElseType

        public init(
            condition: @escaping (String) -> Bool,
            then: ThenType,
            `else`: ElseType
        ) {
            self.condition = condition
            self.then = then
            self.else = `else`
        }
        
        public func autoComplete(_ text: String) -> String? {
            if self.condition(text) == true {
                return self.then.autoComplete(text)
            }
            return self.else.autoComplete(text)
        }
        
        public func variants(_ text: String, completed: @escaping ([String]) -> Void) -> ICancellable? {
            if self.condition(text) == true {
                return self.then.variants(text, completed: completed)
            }
            return self.else.variants(text, completed: completed)
        }
        
    }
    
}
