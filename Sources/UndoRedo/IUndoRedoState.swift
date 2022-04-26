//
//  KindKitUndoRedo
//

import Foundation

protocol IUndoRedoState {

    func create(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) -> Bool
    func update(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingTransformContext) -> Void) -> Bool
    func delete(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void) -> Bool
    
    func undo(_ delegate: IUndoRedoDelegate)
    func redo(_ delegate: IUndoRedoDelegate)
    
    func cleanup()
    
}
