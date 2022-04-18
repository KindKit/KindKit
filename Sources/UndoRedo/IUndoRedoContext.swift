//
//  KindKitUndoRedo
//

import Foundation

public protocol IUndoRedoContext {
    
    var command: String { get }
    var keys: [String] { get }

    func cleanup()
    
}

public protocol IUndoRedoMutatingContext : IUndoRedoContext {
    
    var command: String { set get }
    
}

public extension IUndoRedoContext {
    
    func command< CommandType: RawRepresentable >(_ type: CommandType.Type) -> CommandType? where CommandType.RawValue == String {
        return CommandType(rawValue: self.command)
    }
    
    func keys< KeysType: RawRepresentable >(_ type: KeysType.Type) -> [KeysType] where KeysType.RawValue == String {
        return self.keys.compactMap({ KeysType(rawValue: $0) })
    }
    
}
