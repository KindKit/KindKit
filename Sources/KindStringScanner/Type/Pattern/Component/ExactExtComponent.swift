//
//  KindKit
//

import Foundation

public struct ExactExtComponent : IComponent {
    
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
        @ComponentsBuilder _ components: @escaping (String) -> [IComponent]
    ) {
        self.input = .strings(input)
        self.components = components
    }
    
    public func scan(_ scanner: KindStringScanner.Scanner, in context: Pattern.Context) throws {let match: Scanner.Result?
        switch self.input {
        case .character(let input): match = scanner.match(input)
        case .characters(let input): match = scanner.match(input)
        case .characterSet(let input): match = scanner.match(input)
        case .string(let input): match = scanner.match(input)
        case .strings(let input): match = scanner.match(input)
        }
        guard let match = match else {
            throw Pattern.Error.notFound
        }
        try context.append(match)
        let components = self.components(.init(match.content))
        for component in components {
            try component.scan(scanner, in: context)
        }
    }
    
}

public extension ExactExtComponent {
    
    enum Input {
        
        case character(Character)
        case characters([Character])
        case characterSet(CharacterSet)
        case string(String)
        case strings([String])
        
    }
    
}
