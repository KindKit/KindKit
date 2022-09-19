//
//  KindKit
//

import Foundation

public protocol IUndoRedoDelegate : AnyObject {
    
    func create(context: IUndoRedoPermanentContext)
    func update(context: IUndoRedoPermanentContext)
    func delete(context: IUndoRedoPermanentContext)
    
}
