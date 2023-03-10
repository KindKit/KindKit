//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    final class Static : IInputSuggestion {
        
        private let _items: [Item]
        private let _limit: UInt
        private let _options: Options
        
        public init(
            items: [String],
            limit: UInt = 0,
            options: Options = [ .allowEmpty ]
        ) {
            self._items = items.map(options.makeItem)
            self._limit = limit
            self._options = options
        }
        
        public func autoComplete(_ text: String) -> String? {
            guard text.isEmpty == false else {
                return nil
            }
            let search = self._options.search(text)
            let items = self._items.filter({ $0.search.hasPrefix(search) })
            guard let item = items.first(where: { $0.search != search }) else {
                return nil
            }
            return item.origin
        }
        
        public func variants(_ text: String) -> [String] {
            var items: [Item]
            if text.isEmpty == true {
                if self._options.contains(.allowEmpty) == true {
                    items = self._items
                } else {
                    items = []
                }
            } else {
                let search = self._options.search(text)
                items = self._items.filter({ $0.search.contains(search) && $0.search != search })
            }
            if self._limit > 0 {
                items = Array(items.prefix(Int(self._limit)))
            }
            return items.map({ $0.origin })
        }
        
    }
    
}

public extension IInputSuggestion where Self == InputSuggestion.Static {
    
    @inlinable
    static func `static`(
        items: [String],
        limit: UInt = 0,
        options: InputSuggestion.Static.Options = [ .allowEmpty ]
    ) -> Self {
        return .init(
            items: items,
            limit: limit,
            options: options
        )
    }
    
}
