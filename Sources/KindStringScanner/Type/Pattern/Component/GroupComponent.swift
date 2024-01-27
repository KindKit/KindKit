//
//  KindKit
//

public struct GroupComponent : IComponent {
    
    private let _pattern: [IComponent]
    
    public init(@ComponentsBuilder _ builder: () -> [IComponent]) {
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
