//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    final class Condition< ThenType : IInputSuggestion & IInputSuggestionStorable, ElseType : IInputSuggestion & IInputSuggestionStorable > : IInputSuggestion where ThenType.StoreType == ElseType.StoreType {
        
        public private(set) var store: [ThenType.StoreType] {
            set {
                guard self._store != newValue else { return }
                self._store = newValue
                self.onStore.emit(self._store)
            }
            get {
                return self._store
            }
        }
        public private(set) var variants: [String] {
            set {
                guard self._variants != newValue else { return }
                self._variants = newValue
                self.onVariants.emit(self.variants)
            }
            get {
                return self._variants
            }
        }
        public let onStore = Signal.Args< Void, [ThenType.StoreType] >()
        public let onVariants = Signal.Args< Void, [String] >()
        
        private var _store: [ThenType.StoreType] = []
        private var _variants: [String] = []
        private let _condition: (String) -> Bool
        private let _then: ThenType
        private let _else: ElseType

        public init(
            condition: @escaping (String) -> Bool,
            then: ThenType,
            `else`: ElseType
        ) {
            self._condition = condition
            self._then = then
            self._else = `else`
            self._then.onVariants.subscribe(self, {
                $0.variants = $1
            })
            self._then.onStore.subscribe(self, {
                $0.store = $1
            })
            self._else.onVariants.subscribe(self, {
                $0.variants = $1
            })
            self._else.onStore.subscribe(self, {
                $0.store = $1
            })
        }
        
        public func begin() {
            self._then.begin()
            self._else.begin()
        }
        
        public func end() {
            self._then.end()
            self._else.end()
            self._store = []
            self._variants = []
        }

        public func autoComplete(_ text: String) -> String? {
            if self._condition(text) == true {
                return self._then.autoComplete(text)
            }
            return self._else.autoComplete(text)
        }
        
        public func variants(_ text: String) {
            if self._condition(text) == true {
                self._then.variants(text)
            } else {
                self._else.variants(text)
            }
        }
        
    }
    
}
