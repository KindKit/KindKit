//
//  KindKit
//

import KindEvent
import KindMath
import KindMonadicMacro

@KindMonadic
public final class Manager< LayoutType : ILayout > : IOwner {
    
    @KindMonadicProperty
    public var holder: IHolder? {
        didSet {
            guard self.holder !== oldValue else { return }
            self._flags.insert([ .collect ])
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var available: DynamicSize = .fit {
        didSet {
            guard self.available != oldValue else { return }
            self._flags.insert(.arrange)
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var viewOrigin: Point = .zero {
        didSet {
            guard self.viewOrigin != oldValue else { return }
            self._flags.insert(.collect)
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var viewSize: Size = .zero {
        didSet {
            guard self.viewSize != oldValue else { return }
            self._flags.insert([ .arrange, .collect ])
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var viewInset: Inset = .zero {
        didSet {
            guard self.viewInset != oldValue else { return }
            self._flags.insert([ .arrange, .collect ])
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var content: LayoutType? {
        didSet {
            guard self.content !== oldValue else { return }
            if let content = oldValue {
                content.owner = nil
            }
            if let content = self.content {
                content.owner = self
            }
            self._flags.insert([ .arrange, .collect ])
            self.update()
        }
    }
    
    @KindMonadicProperty
    public var additionalInset: Inset = .zero {
        didSet {
            guard self.additionalInset != oldValue else { return }
            self._flags.insert(.collect)
            self.update()
        }
    }
    
    public private(set) var contentSize = Size.zero {
        didSet {
            guard self.contentSize != oldValue else { return }
            self.onContentSize.emit()
        }
    }
    
    public private(set) var contentItems: [IItem] = []
    
    public let onLockUpdate = Signal< Void, Void >()
    
    public let onUnlockUpdate = Signal< Void, Void >()
    
    public let onInvalidate = Signal< Bool?, Void >()
    
    public let onContentSize = Signal< Void, Void >()
    
    private var _updateCounter = UInt.zero
    private var _flags = Flags.arrange

    public init() {
    }
    
    deinit {
        self._clear()
    }
    
}

public extension Manager {
    
    func sizeOf(_ request: SizeRequest) -> Size {
        return self.available.resolve(by: request, calculate: { size in
            guard let content = self.content else { return .zero }
            return content.sizeOf(.init(size: size))
        })
    }
    
    func invalidate() {
        self._flags.insert(.arrange)
        self._flags.insert(.collect)
        if self.onInvalidate.emit(default: true) {
            self.update()
        }
    }
    
    func remove(_ item: IItem) {
        if let index = self.contentItems.firstIndex(where: { $0 === item }) {
            self.contentItems.remove(at: index)
        }
    }
    
    @discardableResult
    func lockUpdate() -> Self {
        self._updateCounter += 1
        if self._updateCounter == 1 {
            self.onLockUpdate.emit()
        }
        return self
    }
    
    @discardableResult
    func unlockUpdate() -> Self {
        if self._updateCounter > 0 {
            self._updateCounter -= 1
        }
        if self._updateCounter == 0 {
            self.onUnlockUpdate.emit()
        }
        return self.update()
    }
    
    @discardableResult
    func update() -> Self {
        if self._updateCounter == 0 {
            self._update()
        }
        return self
    }
    
}

private extension Manager {
    
    func _update() {
        if let content = self.content {
            if self._flags.contains(.arrange) == true {
                self._flags.remove(.arrange)
                let request = ArrangeRequest(
                    container: self.viewSize,
                    available: self.available.resolve(
                        by: self.viewSize.inset(self.viewInset)
                    )
                )
                self.contentSize = content.arrange(request)
            }
            if let holder = self.holder {
                if self._flags.contains(.collect) == true {
                    self._flags.remove(.collect)
                    let collector = Collector(bounds: .init(
                        origin: self.viewOrigin,
                        size: self.viewSize.inset(-self.additionalInset)
                    ))
                    content.collect(collector)
                    do {
                        let disappearing = self.contentItems.filter({ item in
                            return collector.items.contains(where: { item === $0 }) == false
                        })
                        for item in disappearing {
                            item.position = nil
                        }
                    }
                    for index in 0 ..< collector.items.count {
                        let item = collector.items[index]
                        item.position = .init(
                            holder: holder,
                            owner: self,
                            index: index
                        )
                    }
                    self.contentItems = collector.items
                }
            }
        } else {
            self._clear()
        }
    }
    
    func _clear() {
        for item in self.contentItems {
            item.position = nil
        }
        self.contentItems.removeAll()
    }
    
}
