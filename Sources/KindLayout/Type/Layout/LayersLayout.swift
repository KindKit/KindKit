//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class LayersLayout : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self._sequence.each({
                $0.owner = self.owner
            })
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    @KindMonadicProperty
    public var content: [ILayout] {
        set {
            self._sequence.replace({
                $0.owner = nil
                $0.parent = nil
            }, newValue, {
                $0.parent = self
                $0.owner = self.owner
            })
            self.update()
        }
        get {
            return self._sequence.content()
        }
    }
    
    private let _sequence = SequenceCache()
    
    public init() {
        self._sequence.delegate = self
    }
    
    public func invalidate() {
        self._sequence.invalidate()
    }
    
    public func invalidate(_ layout: ILayout) {
        self._sequence.invalidate(layout)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        var maxSize = Size.zero
        self._sequence.each({ index in
            let size = self._sequence.size(
                of: request,
                at: index
            )
            maxSize = maxSize.normalized.max(size)
        })
        return maxSize
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        var maxSize = Size.zero
        let purpose = SizeRequest(request)
        self._sequence.each({ index in
            let size = self._sequence.size(
                of: purpose,
                at: index
            )
            maxSize = maxSize.normalized.max(size)
        })
        self._sequence.each({ content in
            _ = content.arrange(.init(
                container: .init(origin: request.container.origin, size: maxSize)
            ))
        })
        return maxSize
    }
    
    public func collect(_ collector: Collector) {
        self._sequence.collect(collector)
    }
    
}

extension LayersLayout : ILayoutSupportList {
    
    public func contains(_ content: ILayout) -> Bool {
        return self._sequence.contains(content)
    }
    
    public func index(_ content: ILayout) -> Int? {
        return self._sequence.index(content)
    }
    
    public func index(`where`: (ILayout) -> Bool) -> Int? {
        return self._sequence.index(where: `where`)
    }
    
    public func index< FindType : ILayout >(as type: FindType.Type, where: (FindType) -> Bool) -> Int? {
        return self._sequence.index(as: type, where: `where`)
    }
    
    public func indices(_ content: [ILayout]) -> [Int] {
        return self._sequence.indices(content)
    }
    
    public func indices< FindType : ILayout >(as type: FindType.Type, where: (FindType) -> Bool) -> [Int] {
        return self._sequence.indices(as: type, where: `where`)
    }
    
    public func insert(_ content: ILayout, at index: Int) {
        self._sequence.insert(content, at: index)
    }
    
    public func insert(_ content: [ILayout], at index: Int) {
        self._sequence.insert(content, at: index)
    }
    
    public func delete(_ index: Int) {
        self._sequence.delete(index)
    }
    
    public func delete(_ content: ILayout) {
        self._sequence.delete(content)
    }
    
    public func delete(_ content: [ILayout]) {
        self._sequence.delete(content)
    }
    
    public func delete(_ range: Range< Int >) {
        self._sequence.delete(range)
    }
    
}

extension LayersLayout : ISequenceCacheDelegate {
    
    func commit(_ listHelper: SequenceCache) {
        self.update()
    }
    
}

public extension LayersLayout {
    
    @inlinable
    convenience init(@SequenceBuilder _ builder: () -> [ILayout]) {
        self.init()
        self.content(builder())
    }
    
}
