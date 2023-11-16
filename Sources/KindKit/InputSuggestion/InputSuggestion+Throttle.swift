//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    final class Throttle< SuggestionType : IInputSuggestion & IInputSuggestionStorable > : IInputSuggestion, IInputSuggestionStorable {
        
        public var store: [SuggestionType.StoreType] {
            return self._suggestion.store
        }
        public var onVariants: Signal.Args< Void, [String] > {
            return self._suggestion.onVariants
        }
        public var onStore: Signal.Args< Void, [SuggestionType.StoreType] > {
            return self._suggestion.onStore
        }
        
        private let _suggestion: SuggestionType
        private let _timer: Timer.Throttle
        private var _search: String?
        
        public init(
            timer: Timer.Throttle,
            suggestion: SuggestionType
        ) {
            self._timer = timer
            self._suggestion = suggestion
            
            self._timer.onFinished.subscribe(self, {
                guard let search = $0._search else { return }
                $0._suggestion.variants(search)
            })
        }
        
        public func begin() {
        }
        
        public func end() {
            self._timer.cancel()
        }
        
        public func autoComplete(_ text: String) -> String? {
            return nil
        }
        
        public func variants(_ text: String) {
            self._search = text
            self._timer.emit()
        }
        
    }
    
}
