//
//  KindKitUndoRedo
//

import Foundation

extension UndoRedo.State {
    
    class Update : IUndoRedoState {
        
        private var _contexts: [IUndoRedoMutatingTransformContext]
        
        init(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingTransformContext) -> Void) {
            var context: IUndoRedoMutatingTransformContext = UndoRedo.Context.Transform(command, object)
            closure(&context)
            self._contexts = [ context ]
        }
        
        func create(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void) -> Bool {
            return false
        }
        
        func update(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingTransformContext) -> Void) -> Bool {
            if let index = self._contexts.firstIndex(where: { $0.command == command && $0.object == object }) {
                var context = self._contexts[index]
                closure(&context)
                self._contexts[index] = context
            } else {
                var context: IUndoRedoMutatingTransformContext = UndoRedo.Context.Transform(command, object)
                closure(&context)
                self._contexts.append(context)
            }
            return true
        }
        
        func delete(_ command: String, _ object: String, _ closure: (inout IUndoRedoMutatingPermanentContext) -> Void) -> Bool {
            return false
        }
        
        func undo(_ delegate: IUndoRedoDelegate) {
            for context in self._contexts.reversed() {
                delegate.update(context: context.old)
            }
        }
        
        func redo(_ delegate: IUndoRedoDelegate) {
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
    
}
