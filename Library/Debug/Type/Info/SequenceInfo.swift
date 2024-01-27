//
//  KindKit
//

import KindCore
import KindString

public struct SequenceInfo : Info {
    
    public let elements: [Info]
    
    public init(_ elements: [Info]) {
        self.elements = elements
    }
    
    public init(_ elements: [DebugTrait]) {
        self.elements = elements.map({ $0.buildInfo() })
    }
    
    public init(@SequenceBuilder _ builder: () -> [Info]) {
        self.elements = builder()
    }
    
    @KindString.Builder public func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String {
        if options.contains(.inline) == false {
            IndentComponent(head)
            LettersComponent("[")
            NewLineComponent()
        } else {
            LettersComponent("[ ")
        }
        for index in self.elements.indices {
            LettersComponent(
                info: self.elements[index],
                options: options,
                head: inter,
                inter: inter + 1,
                tail: inter
            )
            if options.contains(.inline) == true {
                if index != self.elements.endIndex - 1 {
                    LettersComponent(", ")
                }
            } else {
                if index != self.elements.endIndex - 1 {
                    LettersComponent(",")
                }
                NewLineComponent()
            }
        }
        if options.contains(.inline) == false {
            IndentComponent(tail)
            LettersComponent("}")
        } else {
            LettersComponent(" }")
        }
    }
    
}
