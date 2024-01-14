//
//  KindKit
//

import KindEvent
import KindTimer

public final class Throttle< SuggestionType : IEntity & IStorable > : IEntity, IStorable {
    
    public var store: [SuggestionType.StoreType] {
        return self._suggestion.store
    }
    public var onVariants: Signal< Void, [String] > {
        return self._suggestion.onVariants
    }
    public var onStore: Signal< Void, [SuggestionType.StoreType] > {
        return self._suggestion.onStore
    }
    
    private let _suggestion: SuggestionType
    private let _timer: KindTimer.Throttle
    private var _search: String?
    
    public init(
        timer: KindTimer.Throttle,
        suggestion: SuggestionType
    ) {
        self._timer = timer
        self._suggestion = suggestion
        
        self._timer.onFinished.add(self, {
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
