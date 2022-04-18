//
//  FloorPlanDescription
//

import Foundation

extension UndoRedo {
    
    struct Scope {
        
        private(set) var created: [IUndoRedoMutatingPermanentContext]
        private(set) var updated: [IUndoRedoMutatingTransformContext]
        private(set) var deleted: [IUndoRedoMutatingPermanentContext]

        init() {
            self.created = []
            self.updated = []
            self.deleted = []
        }
        
    }
    
}

extension UndoRedo.Scope {
    
    var isValid: Bool {
        return self.created.isEmpty == false || self.updated.isEmpty == false || self.deleted.isEmpty == false
    }
    
    func cleanup() {
        for context in self.created {
            context.cleanup()
        }
        for context in self.updated {
            context.cleanup()
        }
        for context in self.deleted {
            context.cleanup()
        }
    }
        
}

extension UndoRedo.Scope {
    
    mutating func create(_ command: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) {
        if let index = self.created.firstIndex(where: { $0.command == command }) {
            var context = self.created[index]
            closure(&context)
            self.created[index] = context
        } else {
            var context: IUndoRedoMutatingPermanentContext = UndoRedo.Context.Permanent(command: command)
            closure(&context)
            self.created.append(context)
        }
    }
    
    mutating func update(_ command: String, _ closure: (_ context: inout IUndoRedoMutatingTransformContext) -> Void) {
        if let index = self.updated.firstIndex(where: { $0.command == command }) {
            var context = self.updated[index]
            closure(&context)
            self.updated[index] = context
        } else {
            var context: IUndoRedoMutatingTransformContext = UndoRedo.Context.Transform(command: command)
            closure(&context)
            self.updated.append(context)
        }
    }
    
    mutating func delete(_ command: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) {
        if let index = self.deleted.firstIndex(where: { $0.command == command }) {
            var context = self.deleted[index]
            closure(&context)
            self.deleted[index] = context
        } else {
            var context: IUndoRedoMutatingPermanentContext = UndoRedo.Context.Permanent(command: command)
            closure(&context)
            self.deleted.append(context)
        }
    }
    
}
