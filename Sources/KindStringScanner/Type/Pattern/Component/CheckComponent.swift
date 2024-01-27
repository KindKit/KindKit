//
//  KindKit
//

import Foundation

public struct CheckComponent : IComponent {
    
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
        let match = scanner.scope(flags: .restoreAlways, {
            switch self.input {
            case .character(let input): return scanner.match(input)
            case .characters(let input): return scanner.match(input)
            case .characterSet(let input): return scanner.match(input)
            case .string(let input): return scanner.match(input)
            case .strings(let input): return scanner.match(input)
            }
        })
        if match == nil {
            throw Pattern.Error.notFound
        }
    }
    
}

public extension CheckComponent {
    
    enum Input {
        
        case character(Character)
        case characters([Character])
        case characterSet(CharacterSet)
        case string(String)
        case strings([String])
        
    }
    
}
