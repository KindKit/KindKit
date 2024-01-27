//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@Monadic
public final class StaticController< Item : KindSuggestion.Item > : Controller {
    
    @MonadicField
    public var dictionary: [Item]
    
    @MonadicField
    public var limit: UInt
    
    @MonadicField
    public var options: Options
    
    public private(set) var isStarting: Bool = false
    
    public private(set) var items: [Item] = [] {
        didSet {
            guard self.items != oldValue else { return }
            if self.isStarting == true {
                self.onItems.emit(self.items)
            }
        }
    }
    
    public let onItems = Signal< Void, [Item] >()
    
    public init(
        dictionary: [Item],
        options: Options = .default,
        limit: UInt = 0
    ) {
        self.dictionary = dictionary
        self.options = options
        self.limit = limit
    }
    
    public func start() {
        guard self.isStarting == false else { return }
        self.isStarting = true
    }
    
    public func update(_ input: String) {
        guard self.isStarting == true else { return }
        var items: [Item]
        if input.isEmpty == true {
            if self.options.contains(.allowEmpty) == true {
                items = self.dictionary
            } else {
                items = []
            }
        } else {
            items = self.dictionary.filter({
                $0.match(input, options: self.options)
            })
        }
        if self.limit > 0 {
            items = Array(items.prefix(Int(self.limit)))
        }
        self.items = items
    }
    
    public func stop() {
        guard self.isStarting == true else { return }
        self.isStarting = false
        self.items = []
    }
    
}
