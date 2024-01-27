//
//  KindKit
//

public enum TextLineBreak {
    
    case cliping
    case wordWrapping
    case charWrapping
    case truncatingHead
    case truncatingMiddle
    case truncatingTail
    
}

extension TextLineBreak : Hashable {
}

extension TextLineBreak : Equatable {
}

extension TextLineBreak : Sendable {
}
