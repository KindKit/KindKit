//
//  KindKit
//

import Foundation

public extension Signal {
    
    final class Args< Result, Argument > : ISignal {
        
        public var isEmpty: Bool {
            return self.slot == nil && self.slots.isEmpty == true
        }
        
        var slot: Slot.Args.Base< Result, Argument >? {
            willSet { self.slot?.reset() }
        }
        var slots: [Slot.Args.Base< Result, Argument >] = []
        
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

private extension Signal.Args {
    
    func _reset() {
        for slot in self.slots {
            slot.reset()
        }
        self.slot?.reset()
    }
    
}

public extension Signal.Args {
    
    @discardableResult
    func link(
        _ closure: ((Argument) -> Result)?
    ) -> ICancellable? {
        guard let closure = closure else {
            self.slot = nil
            return nil
        }
        let slot = Slot.Args.Simple(self, closure)
        self.slot = slot
        return slot
    }
    
    @discardableResult
    func link(
        _ closure: (() -> Result)?
    ) -> ICancellable? {
        guard let closure = closure else {
            self.slot = nil
            return nil
        }
        let slot = Slot.Args.Empty.Simple< Result, Argument >(self, closure)
        self.slot = slot
        return slot
    }

    @discardableResult
    func link< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: ((Sender, Argument) -> Result)?
    ) -> ICancellable? {
        guard let closure = closure else {
            self.slot = nil
            return nil
        }
        let slot = Slot.Args.Sender(self, sender, closure)
        self.slot = slot
        return slot
    }
    
    @discardableResult
    func link< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: ((Sender) -> Result)?
    ) -> ICancellable? {
        guard let closure = closure else {
            self.slot = nil
            return nil
        }
        let slot = Slot.Args.Empty.Sender< Sender, Result, Argument >(self, sender, closure)
        self.slot = slot
        return slot
    }
    
}

public extension Signal.Args {

    func append(
        _ closure: @escaping (Argument) -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Simple(self, closure)
        self.slots.append(slot)
        return AutoCancel(slot)
    }
    
    func append(
        _ closure: @escaping () -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Empty.Simple< Result, Argument >(self, closure)
        self.slots.append(slot)
        return AutoCancel(slot)
    }
    
    func append< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: @escaping (Sender, Argument) -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Sender(self, sender, closure)
        self.slots.append(slot)
        return AutoCancel(slot)
    }
    
    func append< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: @escaping (Sender) -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Empty.Sender< Sender, Result, Argument >(self, sender, closure)
        self.slots.append(slot)
        return AutoCancel(slot)
    }
    
}

public extension Signal.Args where Result == Void {
    
    func emit(_ argument: Argument) {
        if let slot = self.slot {
            slot.perform(argument)
        }
        for slot in self.slots {
            slot.perform(argument)
        }
    }
    
}

public extension Signal.Args where Result : IOptionalConvertible {
    
    func emit(_ argument: Argument) -> Optional< Result.Wrapped > {
        if let slot = self.slot {
            if let result = slot.perform(argument).asOptional {
                return result
            }
        }
        for slot in self.slots {
            if let result = slot.perform(argument).asOptional {
                return result
            }
        }
        return nil
    }
    
    func emit(_ argument: Argument, default: () -> Result.Wrapped) -> Result.Wrapped {
        if let slot = self.slot {
            if let result = slot.perform(argument).asOptional {
                return result
            }
        }
        for slot in self.slots {
            if let result = slot.perform(argument).asOptional {
                return result
            }
        }
        return `default`()
    }
    
    func emit(_ argument: Argument, default: @autoclosure () -> Result.Wrapped) -> Result.Wrapped {
        if let slot = self.slot {
            if let result = slot.perform(argument).asOptional {
                return result
            }
        }
        for slot in self.slots {
            if let result = slot.perform(argument).asOptional {
                return result
            }
        }
        return `default`()
    }
    
}

