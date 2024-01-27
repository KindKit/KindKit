//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension CGPath {
    
    @inlinable
    var kk_elements: [CGPathElement] {
        var elements: [CGPathElement] = []
        self.kk_forEach({ element in
            elements.append(element)
        })
        return elements
    }
    
}

public extension CGPath {
    
    typealias EachClosure = @convention(block) (CGPathElement) -> Void
    
    func kk_forEach(_ body: @escaping EachClosure) {
        let callback: CGPathApplierFunction = { (info, element) in
            let body = unsafeBitCast(info, to: EachClosure.self)
            body(element.pointee)
        }
        self.apply(info: unsafeBitCast(body, to: UnsafeMutableRawPointer.self), function: callback)
    }
    
}

#endif
