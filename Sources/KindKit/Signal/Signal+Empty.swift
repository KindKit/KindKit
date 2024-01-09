//
//  KindKit
//

import Foundation

extension Signal {
    
    public final class Empty< Result > : ISignal {
        
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

public extension Signal.Empty {
    
    func link(
        _ closure: (() -> Result)?
    ) {
        if let closure = closure {
            let slot = Slot.Empty.Simple(self, closure)
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
            let slot = Slot.Empty.Sender(self, sender, closure)
            self.slot = slot
        } else {
            self.slot = nil
        }
    }
    
    @discardableResult
    func subscribe(
        _ closure: @escaping () -> Result
    ) -> ICancellable {
        let slot = Slot.Empty.Simple(self, closure)
        self.slots.append(slot)
        return slot
    }
    
    @discardableResult
    func subscribe< Sender : AnyObject >(
        _ sender: Sender,
        _ closure: @escaping (Sender) -> Result
    ) -> ICancellable {
        let slot = Slot.Empty.Sender(self, sender, closure)
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

public extension Signal.Empty where Result == Void {
    
    func emit() {
        if let slot = self.slot {
            do {
                try slot.perform()
            } catch Slot.Error.notHaveSender {
                self.slot = nil
            } catch {
            }
        }
        do {
            let slots = self.slots
            var needRemove: [Slot.Empty.Base< Result >] = []
            for slot in slots {
                do {
                    try slot.perform()
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

public extension Signal.Empty where Result : IOptionalConvertible {
    
    func emit() -> Result.Wrapped? {
        if let slot = self.slot {
            do {
                if let result = try slot.perform().asOptional {
                    return result
                }
            } catch Slot.Error.notHaveSender {
                self.slot = nil
            } catch {
            }
        }
        do {
            let slots = self.slots
            var needRemove: [Slot.Empty.Base< Result >] = []
            for slot in slots {
                do {
                    if let result = try slot.perform().asOptional {
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
    
    func emit(default: () -> Result.Wrapped) -> Result.Wrapped {
        if let result = self.emit() {
            return result
        }
        return `default`()
    }
    
    func emit(default: @autoclosure () -> Result.Wrapped) -> Result.Wrapped {
        if let result = self.emit() {
            return result
        }
        return `default`()
    }
    
}
