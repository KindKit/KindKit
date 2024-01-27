//
//  KindKit-Test
//

import KindMonadicMacro
import KindLayout

@Monadic
final class StaticItem : Item {
    
    weak var layout: (any Layout)?
    var position: Position?
    let size: StaticSize
    var frame: Rect = .zero
    
    @MonadicField
    var isHidden: Bool = false
    
    var isLocked: Bool = false
    
    init(width: StaticSize.Axis, height: StaticSize.Axis) {
        self.size = .init(width: width, height: height)
    }
    
    func sizeOf(_ request: SizeRequest) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.resolve(by: request)
    }
    
}
