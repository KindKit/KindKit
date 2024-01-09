//
//  KindKit
//

import Foundation

extension Signal {
    
    public final class Args< Result, Argument > : ISignal {
        
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
            self.clear()
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

public extension Signal.Args {
    
    func link(
        _ closure: ((Argument) -> Result)?
    ) {
        if let closure = closure {
            let slot = Slot.Args.Simple(self, closure)
            self.slot = slot
        } else {
            self.slot = nil
        }
    }
    
    func link(
        _ closure: (() -> Result)?
    ) {
        if let closure = closure {
            let slot = Slot.Args.Empty.Simple< Result, Argument >(self, closure)
            self.slot = slot
        } else {
            self.slot = nil
        }
    }

    func link< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: ((Sender, Argument) -> Result)?
    ) {
        if let closure = closure {
            let slot = Slot.Args.Sender(self, sender, closure)
            self.slot = slot
        } else {
            self.slot = nil
        }
    }
    
    func link< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: ((Sender) -> Result)?
    ) {
        if let closure = closure {
            let slot = Slot.Args.Empty.Sender< Sender, Result, Argument >(self, sender, closure)
            self.slot = slot
        } else {
            self.slot = nil
        }
    }
    
    @discardableResult
    func subscribe(
        _ closure: @escaping (Argument) -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Simple(self, closure)
        self.slots.append(slot)
        return slot
    }
    
    @discardableResult
    func subscribe(
        _ closure: @escaping () -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Empty.Simple< Result, Argument >(self, closure)
        self.slots.append(slot)
        return slot
    }
    
    @discardableResult
    func subscribe< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: @escaping (Sender, Argument) -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Sender(self, sender, closure)
        self.slots.append(slot)
        return slot
    }
    
    @discardableResult
    func subscribe< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: @escaping (Sender) -> Result
    ) -> ICancellable {
        let slot = Slot.Args.Empty.Sender< Sender, Result, Argument >(self, sender, closure)
        self.slots.append(slot)
        return slot
    }
    
    func clear() {
        for slot in self.slots {
            slot.reset()
        }
        self.slot?.reset()
    }
    
}

public extension Signal.Args where Result == Void {
    
    func emit(_ argument: Argument) {
        if let slot = self.slot {
            do {
                try slot.perform(argument)
            } catch Slot.Error.notHaveSender {
                self.slot = nil
            } catch {
            }
        }
        do {
            let slots = self.slots
            var needRemove: [Slot.Args.Base< Result, Argument >] = []
            for slot in slots {
                do {
                    try slot.perform(argument)
                } catch Slot.Error.notHaveSender {
                    needRemove.append(slot)
                } catch {
                }
            }
            if needRemove.isEmpty == false {
                self.slots.removeAll(where: { slot in
                    needRemove.contains(where: { slot === $0 })
                })
            }
        }
    }
    
}

public extension Signal.Args where Result : IOptionalConvertible {
    
    func emit(_ argument: Argument) -> Result.Wrapped? {
        if let slot = self.slot {
            do {
                if let result = try slot.perform(argument).asOptional {
                    return result
                }
            } catch Slot.Error.notHaveSender {
                self.slot = nil
            } catch {
            }
        }
        do {
            let slots = self.slots
            var needRemove: [Slot.Args.Base< Result, Argument >] = []
            for slot in slots {
                do {
                    if let result = try slot.perform(argument).asOptional {
                        return result
                    }
                } catch Slot.Error.notHaveSender {
                    needRemove.append(slot)
                } catch {
                }
            }
            if needRemove.isEmpty == false {
                self.slots.removeAll(where: { slot in
                    needRemove.contains(where: { slot === $0 })
                })
            }
        }
        return nil
    }
    
    func emit(_ argument: Argument, default: () -> Result.Wrapped) -> Result.Wrapped {
        if let result = self.emit(argument) {
            return result
        }
        return `default`()
    }
    
    func emit(_ argument: Argument, default: @autoclosure () -> Result.Wrapped) -> Result.Wrapped {
        if let result = self.emit(argument) {
            return result
        }
        return `default`()
    }
    
}

