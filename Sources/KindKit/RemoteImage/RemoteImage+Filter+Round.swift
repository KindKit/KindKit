//
//  KindKit
//

#if os(iOS)

import Foundation

public extension RemoteImage.Filter {

    final class Round : IRemoteImageFilter {

        public let mode: UI.CornerRadius
        public var name: String {
            switch self.mode {
            case .auto(let percent, let edges):
                let t = edges.contains(.top) == true ? "\(percent.value)" : "0"
                let l = edges.contains(.left) == true ? "\(percent.value)" : "0"
                let r = edges.contains(.right) == true ? "\(percent.value)" : "0"
                let b = edges.contains(.bottom) == true ? "\(percent.value)" : "0"
                return "\(t)_\(l)_\(r)_\(b)"
            case .manual(let radius, let edges):
                let t = edges.contains(.top) == true ? "\(radius)" : "0"
                let l = edges.contains(.left) == true ? "\(radius)" : "0"
                let r = edges.contains(.right) == true ? "\(radius)" : "0"
                let b = edges.contains(.bottom) == true ? "\(radius)" : "0"
                return "\(t)_\(l)_\(r)_\(b)"
            case .none:
                return "none"
            }
        }
        
        public init(_ mode: UI.CornerRadius) {
            self.mode = mode
        }
        
        public func apply(_ image: UI.Image) -> UI.Image? {
            switch self.mode {
            case .auto(let percent, let edges):
                return image.round(auto: percent, edges: edges)
            case .manual(let radius, let edges):
                return image.round(radius: radius, edges: edges)
            case .none:
                return image
            }
        }
        
    }

}

#endif
