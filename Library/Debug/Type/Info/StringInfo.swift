//
//  KindKit
//

import KindCore
import KindString

public struct StringInfo : Info {
    
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public init(@KindString.Builder _ builder: () -> String) {
        self.value = builder()
    }
    
    public init< Subject >(describing: Subject) {
        self.value = .init(describing: describing)
    }
    
    @KindString.Builder public func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String {
        if options.contains(.inline) == false {
            IndentComponent(head)
        }
        LettersComponent(self.value)
    }
    
}
