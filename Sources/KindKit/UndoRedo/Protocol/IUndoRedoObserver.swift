//
//  KindKit
//

import Foundation

public protocol IUndoRedoObserver : AnyObject {
    
    func refresh(_ undoRedo: UndoRedo)
    
}
