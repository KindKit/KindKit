//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class VGridLayout : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        didSet {
            self._sequence.each({
                $0.owner = self.owner
            })
        }
    }
    
    public private(set) var frame = Rect.zero
    
    @KindMonadicProperty
    public var columns: [GridPolicy] = [ .auto ] {
        didSet {
            guard self.columns != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var hAlignment: HAlignment = .left {
        didSet {
            guard self.hAlignment != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var vAlignment: VAlignment = .top {
        didSet {
            guard self.vAlignment != oldValue else { return }
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var spacing: Point = .zero {
        didSet {
            guard self.spacing != oldValue else { return }
            self.update()
        }
    }
    
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
    
    public convenience init(@SequenceBuilder _ builder: () -> [ILayout]) {
        self.init()
        self.content = builder()
    }
    
    public func invalidate() {
        self._sequence.invalidate()
    }
    
    public func invalidate(_ layout: ILayout) {
        self._sequence.invalidate(layout)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        return GridHelper.vSize(
            purpose: request,
            columns: self.columns,
            spacing: self.spacing,
            content: self._sequence
        )
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        let frames = GridHelper.vFrames(
            purpose: request,
            columns: self.columns,
            hAlignment: self.hAlignment,
            vAlignment: self.vAlignment,
            spacing: self.spacing,
            content: self._sequence
        )
        self.frame = frames.final
        self._sequence.arrange(frames)
        return frames.final.size
    }
    
    public func collect(_ collector: Collector) {
        self._sequence.vCollect(collector)
    }
    
}

extension VGridLayout : ILayoutSupportList {
    
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

extension VGridLayout : ISequenceCacheDelegate {
    
    func commit(_ listHelper: SequenceCache) {
        self.update()
    }
    
}
