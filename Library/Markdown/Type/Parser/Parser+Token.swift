//
//  KindKit
//

public extension Parser {
    
    enum Token : Equatable {
        
        case start
        case tab
        case space
        case escape(Character)
        case raw(Character)
        case end
        
    }
    
}

public extension Parser.Token {
    
    @inlinable
    var character: Character? {
        switch self {
        case .start: return nil
        case .tab: return "\t"
        case .space: return " "
        case .escape(let char): return char
        case .raw(let char): return char
        case .end: return "\n"
        }
    }
    
}
