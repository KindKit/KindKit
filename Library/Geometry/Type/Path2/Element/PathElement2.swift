//
//  KindKit
//

public enum PathElement2 : Hashable, Equatable {
    
    case move(to: Point)
    case line(to: Point)
    case quad(to: Point, control: Point)
    case cubic(to: Point, control1: Point, control2: Point)
    case close
    
}
