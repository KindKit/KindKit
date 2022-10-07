//
//  KindKit
//

import Foundation

public extension Signal {
    
    final class Empty< Result > : ISignal {
        
        public var isEmpty: Bool {
            return self.slot == nil && self.slots.isEmpty == true
        }

        var slot: Slot.Empty.Base< Result >? {
            willSet { self.slot?.reset() }
        }
        var slots: [Slot.Empty.Base< Result >] = []
        
        public init() {
        }
        
        deinit {
            self._reset()
        }

        func remove(_ slot: ISlot) {
            if self.slot === slot {
                self.slot = nil
            } else if let index = self.slots.firstIndex(where: { $0 === slot }) {
                self.slots.remove(at: index)
            }
        }
        
    }
    
}

private extension Signal.Empty {
    
    func _reset() {
        for slot in self.slots {
            slot.reset()
        }
        self.slot?.reset()
    }
    
}

public extension Signal.Empty {
    
    @discardableResult
    func set(
        _ closure: (() -> Result)?
    ) -> ICancellable? {
        guard let closure = closure else {
            self.slot = nil
            return nil
        }
        let slot = Slot.Empty.Simple(self, closure)
        self.slot = slot
        return slot
    }

    @discardableResult
    func set< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: ((Sender) -> Result)?
    ) -> ICancellable? {
        guard let closure = closure else {
            self.slot = nil
            return nil
        }
        let slot = Slot.Empty.Sender(self, sender, closure)
        self.slot = slot
        return slot
    }
    
}

public extension Signal.Empty {
    
    func append(
        _ closure: @escaping () -> Result
    ) -> ICancellable {
        let slot = Slot.Empty.Simple(self, closure)
        self.slots.append(slot)
        return AutoCancel(slot)
    }
    
    func append< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: @escaping (Sender) -> Result
    ) -> ICancellable {
        let slot = Slot.Empty.Sender(self, sender, closure)
        self.slots.append(slot)
        return AutoCancel(slot)
    }
    
}

public extension Signal.Empty where Result == Void {
    
    func emit() {
        if let slot = self.slot {
            slot.perform()
        }
        for slot in self.slots {
            slot.perform()
        }
    }
    
}

public extension Signal.Empty where Result : IOptionalConvertible {
    
    func emit() -> Optional< Result.Wrapped > {
        if let slot = self.slot {
            if let result = slot.perform().asOptional {
                return result
            }
        }
        for slot in self.slots {
            if let result = slot.perform().asOptional {
                return result
            }
        }
        return nil
    }
    
    func emit(default: () -> Result.Wrapped) -> Result.Wrapped {
        if let slot = self.slot {
            if let result = slot.perform().asOptional {
                return result
            }
        }
        for slot in self.slots {
            if let result = slot.perform().asOptional {
                return result
            }
        }
        return `default`()
    }
    
    func emit(default: @autoclosure () -> Result.Wrapped) -> Result.Wrapped {
        if let slot = self.slot {
            if let result = slot.perform().asOptional {
                return result
            }
        }
        for slot in self.slots {
            if let result = slot.perform().asOptional {
                return result
            }
        }
        return `default`()
    }
    
}
