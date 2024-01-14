//
//  KindKit
//

final class DeleteState : IState {
    
    private var _contexts: [IMutatingPermanentContext]
    
    init(_ command: String, _ object: String, _ closure: (inout IMutatingPermanentContext) -> Void) {
        var context: IMutatingPermanentContext = PermanentContext(command, object)
        closure(&context)
        self._contexts = [ context ]
    }
    
    func create(_ command: String, _ object: String, _ closure: (inout IMutatingPermanentContext) -> Void) -> Bool {
        return false
    }
    
    func update(_ command: String, _ object: String, _ closure: (inout IMutatingTransformContext) -> Void) -> Bool {
        return false
    }
    
    func delete(_ command: String, _ object: String, _ closure: (inout IMutatingPermanentContext) -> Void) -> Bool {
        if let index = self._contexts.firstIndex(where: { $0.command == command && $0.object == object }) {
            var context = self._contexts[index]
            closure(&context)
            self._contexts[index] = context
        } else {
            var context: IMutatingPermanentContext = PermanentContext(command, object)
            closure(&context)
            self._contexts.append(context)
        }
        return true
    }
    
    func undo(_ delegate: IDelegate) {
        for context in self._contexts.reversed() {
            delegate.create(context: context)
        }
    }
    
    func redo(_ delegate: IDelegate) {
        for context in self._contexts {
            delegate.delete(context: context)
        }
    }
    
    func cleanup() {
        for context in self._contexts {
            context.cleanup()
        }
    }
    
}
