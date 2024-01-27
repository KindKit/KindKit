//
//  KindKit
//

import KindEvent
import KindTimer

public final class ThrottleController< Suggestion : Controller > : Controller {
    
    public private(set) var isStarting: Bool = false
    
    public var items: [Suggestion.Item] {
        return self._suggestion.items
    }
    
    public var onItems: Signal< Void, [Suggestion.Item] > {
        return self._suggestion.onItems
    }
    
    private var _search: String? {
        didSet {
            guard self._search != oldValue else { return }
            self._timer.emit()
        }
    }
    private let _suggestion: Suggestion
    private let _timer: ThrottleTimer
    
    public init(
        timer: ThrottleTimer,
        suggestion: Suggestion
    ) {
        self._timer = timer
        self._suggestion = suggestion
        
        do {
            self._timer.onFinished(target: self, regular: {
                guard let search = $0._search else { return }
                $0._suggestion.update(search)
            })
        }
    }
    
    deinit {
        self._timer.onFinished(disconnect: self)
    }
    
    public func start() {
        guard self.isStarting == false else { return }
        self.isStarting = true
        self._suggestion.start()
    }
    
    public func update(_ input: String) {
        guard self.isStarting == true else { return }
        self._search = input
    }
    
    public func stop() {
        guard self.isStarting == true else { return }
        self.isStarting = false
        self._suggestion.stop()
        self._timer.cancel()
    }
    
}
