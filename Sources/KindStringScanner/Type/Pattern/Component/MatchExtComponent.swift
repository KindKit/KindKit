//
//  KindKit
//

import Foundation

public struct MatchExtComponent : IComponent {
    
    private let input: Input
    
    @ComponentsBuilder
    private let components: (String) -> [IComponent]
    
    public init(
        _ input: Character,
        @ComponentsBuilder _ components: @escaping (String) -> [IComponent]
    ) {
        self.input = .character(input)
        self.components = components
    }
    
    public init(
        _ input: [Character],
        @ComponentsBuilder _ components: @escaping (String) -> [IComponent]
    ) {
        self.input = .characters(input)
        self.components = components
    }

    public init(
        _ input: CharacterSet,
        @ComponentsBuilder _ components: @escaping (String) -> [IComponent]
    ) {
        self.input = .characterSet(input)
        self.components = components
    }

    public init(
        _ input: String,
        @ComponentsBuilder _ components: @escaping (String) -> [IComponent]
    ) {
        self.input = .string(input)
        self.components = components
    }

    public init(
        _ input: [String],
        @ComponentsBuilder components: @escaping (String) -> [IComponent]
    ) {
        self.input = .strings(input)
        self.components = components
    }

    public func scan(_ scanner: KindStringScanner.Scanner, in context: Pattern.Context) throws {
        let match = scanner.scope(flags: [], {
            switch self.input {
            case .character(let input): return scanner.match(input)
            case .characters(let input): return scanner.match(input)
            case .characterSet(let input): return scanner.match(input)
            case .string(let input): return scanner.match(input)
            case .strings(let input): return scanner.match(input)
            }
        })
        guard let match = match else {
            throw Pattern.Error.notFound
        }
        let components = self.components(.init(match.content))
        for component in components {
            try component.scan(scanner, in: context)
        }
    }
    
}

public extension MatchExtComponent {
    
    enum Input {
        
        case character(Character)
        case characters([Character])
        case characterSet(CharacterSet)
        case string(String)
        case strings([String])
        
    }
    
}
