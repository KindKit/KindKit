//
//  KindKit
//

import Foundation

public struct SkipToComponent : IComponent {
    
    private let input: Input
    
    public init< LengthType : BinaryInteger >(length: LengthType) {
        self.input = .length(.init(length))
    }
    
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
        switch self.input {
        case .length(let input): _ = scanner.next(length: input)
        case .character(let input): _ = scanner.next(to: input)
        case .characters(let input): _ = scanner.next(to: input)
        case .characterSet(let input): _ = scanner.next(to: input)
        case .string(let input): _ = scanner.next(to: input)
        case .strings(let input): _ = scanner.next(to: input)
        }
    }
    
}

public extension SkipToComponent {
    
    enum Input {
        
        case length(Int)
        case character(Character)
        case characters([Character])
        case characterSet(CharacterSet)
        case string(String)
        case strings([String])
        
    }
    
}
