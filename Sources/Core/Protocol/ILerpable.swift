//
//  KindKit
//

import Foundation

public protocol ILerpable {

    func lerp(_ to: Self, progress: Percent) -> Self

}

extension Optional : ILerpable where Wrapped : ILerpable {
    
    public func lerp(_ to: Self, progress: Percent) -> Self {
        switch (self, to) {
        case (.some(let from), .some(let to)): return from.lerp(to, progress: progress)
        case (.some(let from), .none): return progress < .one ? from : nil
        case (.none, .some(let to)): return progress < .one ? nil : to
        case (.none, .none): return nil
        }
    }
    
}
