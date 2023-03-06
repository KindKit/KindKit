//
//  KindKit
//

import Foundation

public protocol IUndoRedoContext {
    
    var command: String { get }
    var object: String { get }
    var keys: [String] { get }

    func cleanup()
    
}

public extension IUndoRedoContext {
    
    func command< Command : RawRepresentable >(_ type: Command.Type) -> Command? where Command.RawValue == String {
        return Command(rawValue: self.command)
    }
    
    func keys< Keys : RawRepresentable >(_ type: Keys.Type) -> [Keys] where Keys.RawValue == String {
        return self.keys.compactMap({ Keys(rawValue: $0) })
    }
    
}
