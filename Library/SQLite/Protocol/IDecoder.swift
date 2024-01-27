//
//  KindKit
//

import Foundation

public protocol IDecoder {
    
    associatedtype SQLiteDecoded
    
    func decode(_ statement: Statement) throws -> SQLiteDecoded
    
}
