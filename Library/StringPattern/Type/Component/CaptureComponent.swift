//
//  KindKit
//

import KindStringScanner

public struct CaptureComponent : Component {
    
    private let _recorder: Pattern.Recorder
    private let _pattern: [any Component]
    
    public init(
        `in`: String,
        @ComponentsBuilder _ builder: () -> [any Component]
    ) {
        self._recorder = .init(`in`)
        self._pattern = builder()
    }
    
    public init< Key : RawRepresentable >(
        `in`: Key,
        @ComponentsBuilder _ builder: () -> [any Component]
    ) where Key.RawValue == String {
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
