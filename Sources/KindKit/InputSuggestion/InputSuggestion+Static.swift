//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    final class Static< StoreType : Equatable > : IInputSuggestion, IInputSuggestionStorable {
        
        public private(set) var store: [StoreType] {
            set {
                guard self._store != newValue else { return }
                self._store = newValue
                self.onStore.emit(self._store)
                self.variants = self._store.map(self._format)
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
        public let onStore = Signal.Args< Void, [StoreType] >()
        public let onVariants = Signal.Args< Void, [String] >()
        
        private var _store: [StoreType] = []
        private var _variants: [String] = []
        private let _format: (StoreType) -> String
        private let _search: (String) -> String
        private let _items: [Item]
        private let _limit: UInt
        private let _options: StaticOptions
        
        private init(
            format: @escaping (StoreType) -> String,
            search: @escaping (String) -> String,
            items: [StoreType],
            limit: UInt = 0,
            options: StaticOptions = .allowEmpty
        ) {
            self._format = format
            self._search = search
            self._items = items.map({
                .init(
                    origin: $0,
                    search: search(format($0))
                )
            })
            self._limit = limit
            self._options = options
        }
        
        public convenience init(
            format: @escaping (StoreType) -> String,
            items: [StoreType],
            limit: UInt = 0,
            options: StaticOptions = .allowEmpty
        ) {
            self.init(
                format: format,
                search: options.search,
                items: items,
                limit: limit,
                options: options
            )
        }
        
        public convenience init(
            items: [StoreType],
            limit: UInt = 0,
            options: StaticOptions = .allowEmpty
        ) where StoreType == String {
            self.init(
                format: { $0 },
                items: items.map({ $0 }),
                limit: limit,
                options: options
            )
        }
        
        public func begin() {
        }
        
        public func end() {
            self._store = []
            self._variants = []
        }
        
        public func autoComplete(_ text: String) -> String? {
            guard text.isEmpty == false else {
                return nil
            }
            let search = self._search(text)
            let items = self._items.filter({ $0.search.hasPrefix(search) })
            guard let item = items.first(where: { $0.search != search }) else {
                return nil
            }
            return self._format(item.origin)
        }
        
        public func variants(_ text: String) {
            var items: [Item]
            if text.isEmpty == true {
                if self._options.contains(.allowEmpty) == true {
                    items = self._items
                } else {
                    items = []
                }
            } else {
                let search = self._search(text)
                items = self._items.filter({ $0.search.contains(search) && $0.search != search })
            }
            if self._limit > 0 {
                items = Array(items.prefix(Int(self._limit)))
            }
            self.store = items.map({ $0.origin })
        }
        
    }
    
}
