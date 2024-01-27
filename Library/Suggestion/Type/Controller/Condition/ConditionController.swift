//
//  KindKit
//

import KindEvent

public final class ConditionController< Then : Controller, Else : Controller > : Controller where Then.Item == Else.Item {
    
    public typealias Item = Then.Item
    
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
    
    private let _condition: (String) -> Bool
    private let _then: Then
    private let _else: Else

    public init(
        condition: @escaping (String) -> Bool,
        then: Then,
        `else`: Else
    ) {
        self._condition = condition
        self._then = then
        self._else = `else`
        self._then.onItems(target: self, regular: {
            $0.items = $1
        })
        self._else.onItems(target: self, regular: {
            $0.items = $1
        })
    }
    
    deinit {
        self._else.onItems(disconnect: self)
        self._then.onItems(disconnect: self)
    }
    
    public func start() {
        guard self.isStarting == false else { return }
        self.isStarting = true
        self._then.start()
        self._else.start()
    }
    
    public func update(_ input: String) {
        guard self.isStarting == true else { return }
        if self._condition(input) == true {
            self._then.update(input)
        } else {
            self._else.update(input)
        }
    }
    
    public func stop() {
        guard self.isStarting == true else { return }
        self.isStarting = false
        self._then.stop()
        self._else.stop()
        self.items = []
    }
    
}
