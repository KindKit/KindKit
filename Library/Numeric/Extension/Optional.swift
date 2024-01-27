//
//  KindKit
//

extension Optional : LerpTrait where Wrapped : LerpTrait {
    
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        switch (self, to) {
        case (.some(let from), .some(let to)): return from.lerp(to, by: progress)
        case (.some(let from), .none): return progress < .max ? from : nil
        case (.none, .some(let to)): return progress < .max ? nil : to
        case (.none, .none): return nil
        }
    }
    
}
