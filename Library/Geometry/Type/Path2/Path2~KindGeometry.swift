//
//  KindKit
//

import KindNumeric

extension Path2 : MulMatrix3Trait {
    
    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init(elements: self.elements.map({
            switch $0 {
            case .move(to: let to):
                return .move(
                    to: to.multiplying(by: matrix)
                )
            case .line(let to):
                return .line(
                    to: to.multiplying(by: matrix)
                )
            case .quad(let to, let control):
                return .quad(
                    to: to.multiplying(by: matrix),
                    control: control.multiplying(by: matrix)
                )
            case .cubic(let to, let control1, let control2):
                return .cubic(
                    to: to.multiplying(by: matrix),
                    control1: control1.multiplying(by: matrix),
                    control2: control2.multiplying(by: matrix)
                )
            case .close:
                return .close
            }
        }))
    }
    
}
