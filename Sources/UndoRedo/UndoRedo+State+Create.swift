//
//  KindKitUndoRedo
//

import Foundation

extension UndoRedo.State {
    
    class Create : IUndoRedoState {
        
        private var _contexts: [IUndoRedoMutatingPermanentContext]

        init(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void) {
            var context: IUndoRedoMutatingPermanentContext = UndoRedo.Context.Permanent(command, object)
            closure(&context)
            self._contexts = [ context ]
        }
        
        func create(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void) -> Bool {
            if let index = self._contexts.firstIndex(where: { $0.command == command && $0.object == object }) {
                var context = self._contexts[index]
                closure(&context)
                self._contexts[index] = context
            } else {
                var context: IUndoRedoMutatingPermanentContext = UndoRedo.Context.Permanent(command, object)
                closure(&context)
                self._contexts.append(context)
            }
            return true
        }
        
        func update(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingTransformContext) -> Void) -> Bool {
            return false
        }
        
        func delete(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void) -> Bool {
            return false
        }
        
        func undo(_ delegate: IUndoRedoDelegate) {
            for context in self._contexts.reversed() {
                delegate.delete(context: context)
            }
        }
        
        func redo(_ delegate: IUndoRedoDelegate) {
            for context in self._contexts {
                delegate.create(context: context)
            }
        }
        
        func cleanup() {
            for context in self._contexts {
                context.cleanup()
            }
        }
        
    }
    
}
