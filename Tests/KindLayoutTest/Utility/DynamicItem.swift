//
//  KindKit-Test
//

import KindMonadicMacro
import KindLayout

@KindMonadic
final class DynamicItem : IItem {
    
    weak var layout: ILayout?
    var position: Position?
    let size: DynamicSize
    var frame: Rect = .zero
    
    @KindMonadicProperty
    var isHidden: Bool = false
    
    var isLocked: Bool = false
    
    let elementSize: Size
    let lines: [Int]
    
    init(
        width: DynamicSize.Axis,
        height: DynamicSize.Axis,
        elementSize: Size,
        lines: [Int]
    ) {
        self.size = .init(width: width, height: height)
        self.elementSize = elementSize
        self.lines = lines
    }
    
    func sizeOf(_ request: SizeRequest) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.size.resolve(
            by: request,
            calculate: { limit in
                var accumulator = Size.zero
                for line in self.lines {
                    accumulator = .init(
                        width: max(accumulator.width, self.elementSize.width * Double(line)),
                        height: accumulator.height + self.elementSize.height
                    )
                }
                return limit.min(accumulator)
            }
        )
    }
    
}
