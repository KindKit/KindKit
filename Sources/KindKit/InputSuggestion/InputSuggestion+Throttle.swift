//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    final class Throttle< SuggestionType : IInputSuggestion > : IInputSuggestion {
        
        public let timer: Timer.Throttle
        public let suggestion: SuggestionType
        
        private var _state: State?
        private var _task: ICancellable? {
            willSet { self._task?.cancel() }
        }

        public init(
            timer: Timer.Throttle,
            suggestion: SuggestionType
        ) {
            self.timer = timer
            self.suggestion = suggestion
            self.timer.onFinished.subscribe(self, { $0._onTriggered() })
        }
        
        public func autoComplete(_ text: String) -> String? {
            return nil
        }
        
        public func variants(_ text: String, completed: @escaping ([String]) -> Void) -> ICancellable? {
            self._state = .init(text: text, completed: completed)
            return self.timer.emit()
        }
        
    }
    
}

private extension InputSuggestion.Throttle {
    
    func _onTriggered() {
        guard let state = self._state else { return }
        self._task = self.suggestion.variants(state.text, completed: { [weak self] variants in
            guard let self = self else { return }
            self._task = nil
            self._state = nil
            state.completed(variants)
        })
    }
    
}

private extension InputSuggestion.Throttle {
    
    struct State {
        
        let text: String
        let completed: ([String]) -> Void
        
    }
    
}
