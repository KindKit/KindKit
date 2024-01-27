//
//  KindKit-Test
//

import KindMonadicMacro
import KindLayout

@KindMonadic
final class StaticItem : IItem {
    
    weak var layout: ILayout?
    var position: Position?
    let size: StaticSize
    var frame: Rect = .zero
    
    @KindMonadicProperty
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
