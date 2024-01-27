//
//  KindKit
//

import KindCore
import KindString

public struct ObjectInfo< Info : KindDebug.Info > : KindDebug.Info {
    
    public let name: String
    public let info: Info
    
    public init(
        name: String,
        info: Info
    ) {
        self.name = name
        self.info = info
    }
    
    public init(
        name: String,
        info: KindDebug.Info
    ) where Info == AnyInfo {
        self.name = name
        self.info = .init(info)
    }
    
    public init(
        name: String,
        info: DebugTrait
    ) where Info == AnyInfo {
        self.name = name
        self.info = .init(info.buildInfo())
    }
    
    public init(
        name: String,
        sequence elements: [KindDebug.Info]
    ) where Info == SequenceInfo {
        self.name = name
        self.info = .init(elements)
    }
    
    public init(
        name: String,
        @SequenceBuilder sequenceBuilder: () -> [KindDebug.Info]
    ) where Info == SequenceInfo {
        self.name = name
        self.info = .init(sequenceBuilder)
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
        LettersComponent("<")
        LettersComponent(self.name)
        SpaceComponent()
        LettersComponent(
            info: self.info,
            options: options,
            head: 0,
            inter: inter,
            tail: inter - 1
        )
        SpaceComponent()
        LettersComponent(">")
    }
    
}
