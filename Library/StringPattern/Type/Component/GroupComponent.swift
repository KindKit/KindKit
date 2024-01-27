//
//  KindKit
//

import KindStringScanner

public struct GroupComponent : Component {
    
    private let _pattern: [any Component]
    
    public init(@ComponentsBuilder _ builder: () -> [any Component]) {
        self._pattern = builder()
    }
    
    public func scan(_ scanner: Scanner, in context: Pattern.Context) throws {
        guard scanner.isAtEnd == false else {
            return
        }
        for pattern in self._pattern {
            try pattern.scan(scanner, in: context)
        }
    }
    
}
