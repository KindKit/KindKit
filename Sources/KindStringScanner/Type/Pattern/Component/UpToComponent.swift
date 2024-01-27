//
//  KindKit
//

import Foundation

public struct UpToComponent : IComponent {
    
    private let input: Input
    
    public init(_ input: Character) {
        self.input = .character(input)
    }
    
    public init(_ input: [Character]) {
        self.input = .characters(input)
    }

    public init(_ input: CharacterSet) {
        self.input = .characterSet(input)
    }

    public init(_ input: String) {
        self.input = .string(input)
    }

    public init(_ input: [String]) {
        self.input = .strings(input)
    }
    
    public func scan(_ scanner: KindStringScanner.Scanner, in context: Pattern.Context) throws {
        let match: Scanner.Result?
        switch self.input {
        case .character(let input): match = scanner.next(to: input)
        case .characters(let input): match = scanner.next(to: input)
        case .characterSet(let input): match = scanner.next(to: input)
        case .string(let input): match = scanner.next(to: input)
        case .strings(let input): match = scanner.next(to: input)
        }
        guard let match = match else {
            throw Pattern.Error.notFound
        }
        try context.append(match)
    }
    
}

public extension UpToComponent {
    
    enum Input {
        
        case character(Character)
        case characters([Character])
        case characterSet(CharacterSet)
        case string(String)
        case strings([String])
        
    }
    
}
