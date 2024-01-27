//
//  KindKit
//

import KindMath

final class ElementCache {
    
    private var _available: Size = .zero
    private var _size: Size?
    
    init() {
    }
    
    func sizeOf(_ request: SizeRequest, content: (SizeRequest) -> Size) -> Size {
        if let store = self._size {
            if self._available == request.available {
                return store
            }
        }
        let size = content(request)
        self._available = request.available
        self._size = size
        return size
    }
    
    func reset() {
        self._size = nil
    }
    
}

extension ElementCache {
    
    @inlinable
    func sizeOf(_ request: SizeRequest, content: ILayout) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inlinable
    func sizeOf(_ request: ArrangeRequest, content: ILayout) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
    @inlinable
    func size< LayoutType : ILayout >(of request: SizeRequest, content: LayoutType) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inlinable
    func size< LayoutType : ILayout >(of request: ArrangeRequest, content: LayoutType) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
}

extension ElementCache {
    
    @inlinable
    func sizeOf(_ request: SizeRequest, content: IItem) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inlinable
    func sizeOf(_ request: ArrangeRequest, content: IItem) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
    @inlinable
    func size< ItemType : IItem >(of request: SizeRequest, content: ItemType) -> Size {
        return self.sizeOf(request, content: { content.sizeOf($0) })
    }
    
    @inlinable
    func size< ItemType : IItem >(of request: ArrangeRequest, content: ItemType) -> Size {
        return self.sizeOf(.init(request), content: { content.sizeOf($0) })
    }
    
}
