//
//  KindKit
//

import Foundation

protocol IUndoRedoScope {
    
    var isValid: Bool { get }
    
    func create(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void)
    func update(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingTransformContext) -> Void)
    func delete(_ command: String, _ object: String, _ closure: (_ context: inout IUndoRedoMutatingPermanentContext) -> Void)
    
    func undo(_ delegate: IUndoRedoDelegate)
    func redo(_ delegate: IUndoRedoDelegate)
    
    func cleanup()
    
}
