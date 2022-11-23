//
//  KindKit
//

import Foundation

public protocol ILerpable {

    func lerp(_ to: Self, progress: Percent) -> Self

}
