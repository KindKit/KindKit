//
//  KindKit
//

extension Gradient {
    
    public enum Mode {
        
        case axial
        case radial
        
    }
    
}

extension Gradient.Mode : Hashable {
}

extension Gradient.Mode : Equatable {
}

extension Gradient.Mode : Sendable {
}
