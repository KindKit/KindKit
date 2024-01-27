//
//  KindKit
//

import KindGeometry

public final class HPagingLayout : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        didSet {
            self._sequence.each({
                $0.scope = self.scope
            })
        }
    }
    
    public private(set) var frame: Rect = .zero
    
    public var content: [any Layout] {
        set {
            self._sequence.replace({
                $0.scope = nil
                $0.parent = nil
            }, newValue, {
                $0.parent = self
                $0.scope = self.scope
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
    
    public convenience init(_ content: [any Layout]) {
        self.init()
        self.content = content
    }
    
    public convenience init(@SequenceBuilder _ builder: () -> [any Layout]) {
        self.init()
        self.content = builder()
    }
    
    public func invalidate() {
        self._sequence.invalidate()
    }
    
    public func invalidate(_ layout: any Layout) {
        self._sequence.invalidate(layout)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return PagingHelper.hSize(
            purpose: request,
            content: self._sequence
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let frames = PagingHelper.hFrames(
            purpose: request,
            content: self._sequence
        )
        self.frame = frames.final
        self._sequence.arrange(frames)
        return frames.final.size
    }
    
    public func collect(_ collector: Collector) {
        self._sequence.hCollect(collector)
    }
    
}

extension HPagingLayout : SequenceLayoutTrait {
    
    public func contains(_ content: any Layout) -> Bool {
        return self._sequence.contains(content)
    }
    
    public func index(_ content: any Layout) -> Int? {
        return self._sequence.index(content)
    }
    
    public func index(`where`: (any Layout) -> Bool) -> Int? {
        return self._sequence.index(where: `where`)
    }
    
    public func index< Find : Layout >(as type: Find.Type, where: (Find) -> Bool) -> Int? {
        return self._sequence.index(as: type, where: `where`)
    }
    
    public func indices(_ content: [any Layout]) -> [Int] {
        return self._sequence.indices(content)
    }
    
    public func indices< Find : Layout >(as type: Find.Type, where: (Find) -> Bool) -> [Int] {
        return self._sequence.indices(as: type, where: `where`)
    }
    
    public func insert(_ content: any Layout, at index: Int) {
        self._sequence.insert(content, at: index)
    }
    
    public func insert(_ content: [any Layout], at index: Int) {
        self._sequence.insert(content, at: index)
    }
    
    public func delete(_ index: Int) {
        self._sequence.delete(index)
    }
    
    public func delete(_ content: any Layout) {
        self._sequence.delete(content)
    }
    
    public func delete(_ content: [any Layout]) {
        self._sequence.delete(content)
    }
    
    public func delete(_ range: Range< Int >) {
        self._sequence.delete(range)
    }
    
}

extension HPagingLayout : ISequenceCacheDelegate {
    
    func commit(_ listHelper: SequenceCache) {
        self.update()
    }
    
}
