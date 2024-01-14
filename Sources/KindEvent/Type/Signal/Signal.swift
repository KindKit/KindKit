//
//  KindKit
//

public final class Signal< ResultType, ArgumentType > : ISignal {
    
    public var isEmpty: Bool {
        return self.slots.isEmpty == true
    }
    var slots: [Slot] = []
    
    public init() {
    }
    
    deinit {
        self.clear()
    }
            
    func remove(_ slot: ICancellable) {
        guard let index = self.slots.firstIndex(where: { $0 === slot }) else { return }
        self.slots.remove(at: index)
    }
    
}

public extension Signal {
    
    @discardableResult
    func add(_ closure: @escaping (ArgumentType) -> ResultType) -> ICancellable {
        let slot = Slot.Simple(self, closure)
        self.slots.append(slot)
        return slot
    }
    
    @discardableResult
    func add(_ closure: @escaping () -> ResultType) -> ICancellable {
        return self.add({ _ in closure() })
    }
    
    @discardableResult
    func add< SenderType : AnyObject >(_ sender: SenderType, _ closure: @escaping (SenderType, ArgumentType) -> ResultType) -> ICancellable {
        let slot = Slot.Sender(self, sender, closure)
        self.slots.append(slot)
        return slot
    }
    
    @discardableResult
    func add< SenderType : AnyObject >(_ sender: SenderType, _ closure: @escaping (SenderType) -> ResultType) -> ICancellable {
        return self.add(sender, { sender, _ in closure(sender) })
    }
    
    func remove(sender: AnyObject) {
        self.slots.removeAll(where: { $0.contains(sender) })
    }
    
    func clear() {
        for slot in self.slots {
            slot.reset()
        }
    }
    
}

public extension Signal where ResultType == Void {
    
    func emit() where ArgumentType == Void {
        self.emit(())
    }
    
    func emit(_ argument: ArgumentType) {
        let slots = self.slots
        var needRemove: [Slot] = []
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

public extension Signal where ResultType : IOptionalConvertible {
    
    func emit() -> ResultType.Wrapped? where ArgumentType == Void {
        return self.emit(())
    }
    
    func emit(_ argument: ArgumentType) -> ResultType.Wrapped? {
        let slots = self.slots
        var needRemove: [Slot] = []
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
        return nil
    }
    
    func emit(default: () -> ResultType.Wrapped) -> ResultType.Wrapped where ArgumentType == Void {
        return self.emit((), default: `default`)
    }
    
    func emit(_ argument: ArgumentType, default: () -> ResultType.Wrapped) -> ResultType.Wrapped {
        if let result = self.emit(argument) {
            return result
        }
        return `default`()
    }
    
    func emit(default: @autoclosure () -> ResultType.Wrapped) -> ResultType.Wrapped where ArgumentType == Void {
        return self.emit((), default: `default`)
    }
    
    func emit(_ argument: ArgumentType, default: @autoclosure () -> ResultType.Wrapped) -> ResultType.Wrapped {
        if let result = self.emit(argument) {
            return result
        }
        return `default`()
    }
    
}

