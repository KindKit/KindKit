//
//  KindKit
//

final class UpdateState : IState {
    
    private var _contexts: [IMutatingTransformContext]
    
    init(_ command: String, _ object: String, _ closure: (inout IMutatingTransformContext) -> Void) {
        var context: IMutatingTransformContext = TransformContext(command, object)
        closure(&context)
        self._contexts = [ context ]
    }
    
    func create(_ command: String, _ object: String, _ closure: (inout IMutatingPermanentContext) -> Void) -> Bool {
        return false
    }
    
    func update(_ command: String, _ object: String, _ closure: (inout IMutatingTransformContext) -> Void) -> Bool {
        if let index = self._contexts.firstIndex(where: { $0.command == command && $0.object == object }) {
            var context = self._contexts[index]
            closure(&context)
            self._contexts[index] = context
        } else {
            var context: IMutatingTransformContext = TransformContext(command, object)
            closure(&context)
            self._contexts.append(context)
        }
        return true
    }
    
    func delete(_ command: String, _ object: String, _ closure: (inout IMutatingPermanentContext) -> Void) -> Bool {
        return false
    }
    
    func undo(_ delegate: IDelegate) {
        for context in self._contexts.reversed() {
            delegate.update(context: context.old)
        }
    }
    
    func redo(_ delegate: IDelegate) {
        for context in self._contexts {
            delegate.update(context: context.new)
        }
    }
    
    func cleanup() {
        for context in self._contexts {
            context.cleanup()
        }
    }
    
}
