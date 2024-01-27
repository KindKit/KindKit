//
//  KindKit
//

import KindMath

struct SequenceHelper {
    
    struct Frames {
        
        var final: Rect
        var content: [Rect]
        
        init(
            final: Rect,
            content: [Rect]
        ) {
            self.final = final
            self.content = content
        }
        
        init(
            final: Rect,
            content: [Rect],
            alignment: HAlignment
        ) {
            self.init(final: final, content: content)
            self.apply(alignment: alignment)
        }
        
        init(
            final: Rect,
            content: [Rect],
            alignment: VAlignment
        ) {
            self.init(final: final, content: content)
            self.apply(alignment: alignment)
        }
        
    }
    
    struct RowsFrames {
        
        var final: Rect
        var content: [Frames]
        
        init(
            final: Rect,
            content: [Frames]
        ) {
            self.final = final
            self.content = content
        }
        
        init(
            final: Rect,
            content: [Frames],
            alignment: HAlignment
        ) {
            self.init(final: final, content: content)
            self.apply(alignment: alignment)
        }
        
    }
    
}

extension SequenceHelper.Frames {
    
    @inlinable
    mutating func apply(alignment: HAlignment) {
        switch alignment {
        case .left:
            break
        case .center:
            let anchor = self.final.x + (self.final.width / 2)
            for index in 0 ..< self.content.count {
                let frame = self.content[index]
                self.content[index] = .init(
                    origin: .init(
                        x: anchor - (frame.width / 2),
                        y: frame.y
                    ),
                    size: frame.size
                )
            }
        case .right:
            let anchor = self.final.x + self.final.width
            for index in 0 ..< self.content.count {
                let frame = self.content[index]
                self.content[index] = .init(
                    origin: .init(
                        x: anchor - frame.width,
                        y: frame.y
                    ),
                    size: frame.size
                )
            }
        }
    }
    
    @inlinable
    mutating func apply(alignment: VAlignment) {
        switch alignment {
        case .top:
            break
        case .center:
            let anchor = self.final.y + (self.final.height / 2)
            for index in 0 ..< self.content.count {
                let frame = self.content[index]
                self.content[index] = .init(
                    origin: .init(
                        x: frame.x,
                        y: anchor - (frame.height / 2)
                    ),
                    size: frame.size
                )
            }
        case .bottom:
            let anchor = self.final.y + self.final.height
            for index in 0 ..< self.content.count {
                let frame = self.content[index]
                self.content[index] = .init(
                    origin: .init(
                        x: frame.x,
                        y: anchor - frame.height
                    ),
                    size: frame.size
                )
            }
        }
    }
    
    @inlinable
    mutating func apply(offset: Point) {
        self.final.origin += offset
        for index in 0 ..< self.content.count {
            self.content[index].origin += offset
        }
    }
    
}

extension SequenceHelper.RowsFrames {
    
    @inlinable
    mutating func apply(alignment: HAlignment) {
        switch alignment {
        case .left:
            break
        case .center:
            let anchor = self.final.x + (self.final.width / 2)
            for rowIndex in 0 ..< self.content.count {
                let rowFrame = self.content[rowIndex].final
                self.content[rowIndex].apply(offset: .init(
                    x: anchor - rowFrame.midX,
                    y: 0
                ))
            }
        case .right:
            let anchor = self.final.x + self.final.width
            for rowIndex in 0 ..< self.content.count {
                let rowFrame = self.content[rowIndex].final
                self.content[rowIndex].apply(offset: .init(
                    x: anchor - rowFrame.maxX,
                    y: 0
                ))
            }
        }
    }
    
}
