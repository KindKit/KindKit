//
//  KindKit
//

public struct CaptureComponent : IComponent {
    
    private let _recorder: Pattern.Recorder
    private let _pattern: [IComponent]
    
    public init(
        `in`: String,
        @ComponentsBuilder _ builder: () -> [IComponent]
    ) {
        self._recorder = .init(`in`)
        self._pattern = builder()
    }
    
    public init< KeyType : RawRepresentable >(
        `in`: KeyType,
        @ComponentsBuilder _ builder: () -> [IComponent]
    ) where KeyType.RawValue == String {
        self.init(in: `in`.rawValue, builder)
    }
    
    public func scan(_ scanner: Scanner, in context: Pattern.Context) throws {
        guard scanner.isAtEnd == false else {
            return
        }
        try context.scope(self._recorder, {
            for pattern in self._pattern {
                try pattern.scan(scanner, in: context)
            }
        })
    }
    
}
