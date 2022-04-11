//
//  KindKitMath
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension CGPath {
    
    typealias EachClosure = @convention(block) (CGPathElement) -> Void
    
    @inlinable
    var elements: [CGPathElement] {
        var elements: [CGPathElement] = []
        self.forEach({ element in
            elements.append(element)
        })
        return elements
    }
    
    func forEach(_ body: @escaping EachClosure) {
        let callback: CGPathApplierFunction = { (info, element) in
            let body = unsafeBitCast(info, to: EachClosure.self)
            body(element.pointee)
        }
        self.apply(info: unsafeBitCast(body, to: UnsafeMutableRawPointer.self), function: callback)
    }
    
}

#endif
