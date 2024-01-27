//
//  KindKit
//

#if canImport(CoreGraphics)
import CoreGraphics
#endif

public protocol ToNumberTrait {
    
    func to< To : BinaryInteger >() -> To
    
    func to< To : BinaryFloatingPoint >() -> To
    
}

public extension ToNumberTrait {
    
    @inlinable
    var int: Int {
        return self.to()
    }
    
    @inlinable
    var int8: Int8 {
        return self.to()
    }
    
    @inlinable
    var int16: Int16 {
        return self.to()
    }
    
    @inlinable
    var int32: Int32 {
        return self.to()
    }
    
    @inlinable
    var int64: Int64 {
        return self.to()
    }
    
}

public extension ToNumberTrait {
    
    @inlinable
    var uint: UInt {
        return self.to()
    }
    
    @inlinable
    var uint8: UInt8 {
        return self.to()
    }
    
    @inlinable
    var uint16: UInt16 {
        return self.to()
    }
    
    @inlinable
    var uint32: UInt32 {
        return self.to()
    }
    
    @inlinable
    var uint64: UInt64 {
        return self.to()
    }
    
}

public extension ToNumberTrait {
    
    @inlinable
    @available(iOS 14, macCatalyst 14.5, macOS 11, tvOS 14, watchOS 7, *)
    var float16: Float16 {
        return self.to()
    }
    
    @inlinable
    var float32: Float32 {
        return self.to()
    }
    
    @inlinable
    var float64: Float64 {
        return self.to()
    }
    
#if canImport(CoreGraphics)
    
    @inlinable
    var cgFloat: CGFloat {
        return self.to()
    }
    
#endif
    
}

public extension ToNumberTrait where Self : BinaryInteger {
    
    @inlinable
    func to< To : BinaryInteger >() -> To {
        return To(self)
    }
    
    @inlinable
    func to< To : BinaryFloatingPoint >() -> To {
        return To(self)
    }
    
}

public extension ToNumberTrait where Self : BinaryFloatingPoint {
    
    @inlinable
    func to< To : BinaryInteger >() -> To {
        return To(self)
    }
    
    @inlinable
    func to< To : BinaryFloatingPoint >() -> To {
        return To(self)
    }
    
}
