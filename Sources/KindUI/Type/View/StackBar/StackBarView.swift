//
//  KindKit
//

import KindMath

public final class StackBarView : IWidgetView {
    
    public let body: BarView
    public var size: Double? {
        set {
            guard self.body.size != newValue else { return }
            self.body.size = newValue
            self._relayout()
        }
        get { self.body.size }
    }
    public var inset: Inset {
        set { self._contentLayout.inset = newValue }
        get { self._contentLayout.inset }
    }
    public var header: IView? {
        didSet { self._relayout() }
    }
    public var headerSpacing: Double = 8 {
        didSet {
            guard self.headerSpacing != oldValue else { return }
            self._relayout()
        }
    }
    public var leadings: [IView] = [] {
        didSet { self._relayout() }
    }
    public var leadingsSpacing: Double = 4 {
        didSet {
            guard self.leadingsSpacing != oldValue else { return }
            self._relayout()
        }
    }
    public var center: IView? {
        didSet { self._relayout() }
    }
    public var centerFilling: Bool = false {
        didSet {
            guard self.centerFilling != oldValue else { return }
            self._relayout()
        }
    }
    public var centerSpacing: Double = 4 {
        didSet {
            guard self.centerSpacing != oldValue else { return }
            self._relayout()
        }
    }
    public var trailings: [IView] = [] {
        didSet { self._relayout() }
    }
    public var trailingsSpacing: Double = 4 {
        didSet {
            guard self.trailingsSpacing != oldValue else { return }
            self._relayout()
        }
    }
    public var footer: IView? {
        didSet { self._relayout() }
    }
    public var footerSpacing: Double = 8 {
        didSet {
            guard self.footerSpacing != oldValue else { return }
            self._relayout()
        }
    }

    private var _contentLayout: CompositionLayout {
        didSet {
            self._contentView.content = self._contentLayout
        }
    }
    private var _contentView: CustomView
    
    public init() {
        self._contentLayout = CompositionLayout(
            inset: .init(horizontal: 8, vertical: 4),
            content: CompositionLayout.NonePart()
        )
        self._contentView = CustomView()
            .content(self._contentLayout)
        self.body = .init(
            placement: .top,
            content: self._contentView
        )
    }
    
}

private extension StackBarView {
    
    func _relayout() {
        self._contentLayout = Self._layout(
            inset: self.inset,
            header: self.header,
            headerSpacing: self.headerSpacing,
            leadings: self.leadings,
            leadingsSpacing: self.leadingsSpacing,
            center: self.center,
            centerFilling: self.centerFilling,
            centerSpacing: self.centerSpacing,
            trailings: self.trailings,
            trailingsSpacing: self.trailingsSpacing,
            footer: self.footer,
            footerSpacing: self.footerSpacing,
            size: self.size
        )
    }
    
    static func _layout(
        inset: Inset,
        header: IView?,
        headerSpacing: Double,
        leadings: [IView],
        leadingsSpacing: Double,
        center: IView?,
        centerFilling: Bool,
        centerSpacing: Double,
        trailings: [IView],
        trailingsSpacing: Double,
        footer: IView?,
        footerSpacing: Double,
        size: Double?
    ) -> CompositionLayout {
        if header == nil && leadings.isEmpty == true && center == nil && trailings.isEmpty == true && footer == nil {
            return CompositionLayout(
                inset: inset,
                content: CompositionLayout.NonePart()
            )
        }
        return CompositionLayout(
            inset: inset,
            content: self._layoutPart(
                header: header,
                headerSpacing: headerSpacing,
                leadings: leadings,
                leadingsSpacing: leadingsSpacing,
                center: center,
                centerFilling: centerFilling,
                centerSpacing: centerSpacing,
                trailings: trailings,
                trailingsSpacing: trailingsSpacing,
                footer: footer,
                footerSpacing: footerSpacing,
                size: size
            )
        )
    }
    
    static func _layoutPart(
        header: IView?,
        headerSpacing: Double,
        leadings: [IView],
        leadingsSpacing: Double,
        center: IView?,
        centerFilling: Bool,
        centerSpacing: Double,
        trailings: [IView],
        trailingsSpacing: Double,
        footer: IView?,
        footerSpacing: Double,
        size: Double?
    ) -> ILayoutPart {
        let contentPart = Self._layoutPart(
            leadings: leadings,
            leadingsSpacing: leadingsSpacing,
            center: center,
            centerFilling: centerFilling,
            centerSpacing: centerSpacing,
            trailings: trailings,
            trailingsSpacing: trailingsSpacing
        )
        let leadingPart: ILayoutPart?
        if let header = header {
            leadingPart = CompositionLayout.MarginPart(
                inset: .init(top: 0, left: 0, right: 0, bottom: headerSpacing),
                content: CompositionLayout.ViewPart(header)
            )
        } else {
            leadingPart = nil
        }
        let trailingPart: ILayoutPart?
        if let footer = footer {
            trailingPart = CompositionLayout.MarginPart(
                inset: .init(top: footerSpacing, left: 0, right: 0, bottom: 0),
                content: CompositionLayout.ViewPart(footer)
            )
        } else {
            trailingPart = nil
        }
        if leadingPart == nil && trailingPart == nil {
            return contentPart
        }
        if size != nil {
            var stackEntities: [ILayoutPart] = []
            if let leadingPart = leadingPart {
                stackEntities.append(leadingPart)
            }
            stackEntities.append(contentPart)
            if let trailingPart = trailingPart {
                stackEntities.append(trailingPart)
            }
            return CompositionLayout.VStackPart(
                alignment: .fill,
                items: stackEntities
            )
        }
        return CompositionLayout.VAccessoryPart(
            leading: leadingPart,
            center: contentPart,
            trailing: trailingPart,
            filling: true
        )
    }
    
    static func _layoutPart(
        leadings: [IView],
        leadingsSpacing: Double,
        center: IView?,
        centerFilling: Bool,
        centerSpacing: Double,
        trailings: [IView],
        trailingsSpacing: Double
    ) -> ILayoutPart {
        let centerPart: ILayoutPart
        if let center = center {
            centerPart = CompositionLayout.MarginPart(
                inset: Inset(
                    top: 0,
                    left: leadings.count > 0 ? centerSpacing : 0,
                    right: trailings.count > 0 ? centerSpacing : 0,
                    bottom: 0
                ),
                content: CompositionLayout.ViewPart(center)
            )
        } else {
            centerPart = CompositionLayout.NonePart()
        }
        let leadingPart: ILayoutPart?
        if leadings.isEmpty == false {
            leadingPart = CompositionLayout.HStackPart(
                alignment: .fill,
                spacing: leadingsSpacing,
                items: leadings.map({ CompositionLayout.ViewPart($0) })
            )
        } else {
            leadingPart = nil
        }
        let trailingPart: ILayoutPart?
        if trailings.isEmpty == false {
            trailingPart = CompositionLayout.HStackPart(
                alignment: .fill,
                spacing: trailingsSpacing,
                items: trailings.reversed().map({ CompositionLayout.ViewPart($0) })
            )
        } else {
            trailingPart = nil
        }
        return CompositionLayout.HAccessoryPart(
            leading: leadingPart,
            center: centerPart,
            trailing: trailingPart,
            filling: centerFilling
        )
    }
    
}

public extension StackBarView {
    
    @inlinable
    @discardableResult
    func size(_ value: Double?) -> Self {
        self.size = value
        return self
    }
    
    @inlinable
    @discardableResult
    func size(_ value: () -> Double?) -> Self {
        return self.size(value())
    }

    @inlinable
    @discardableResult
    func size(_ value: (Self) -> Double?) -> Self {
        return self.size(value(self))
    }
    
    @inlinable
    @discardableResult
    func inset(_ value: Inset) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func inset(_ value: () -> Inset) -> Self {
        return self.inset(value())
    }

    @inlinable
    @discardableResult
    func inset(_ value: (Self) -> Inset) -> Self {
        return self.inset(value(self))
    }
    
    @inlinable
    @discardableResult
    func header(_ value: IView?) -> Self {
        self.header = value
        return self
    }
    
    @inlinable
    @discardableResult
    func header(_ value: () -> IView?) -> Self {
        return self.header(value())
    }

    @inlinable
    @discardableResult
    func header(_ value: (Self) -> IView?) -> Self {
        return self.header(value(self))
    }
    
    @inlinable
    @discardableResult
    func headerSpacing(_ value: Double) -> Self {
        self.headerSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func headerSpacing(_ value: () -> Double) -> Self {
        return self.headerSpacing(value())
    }

    @inlinable
    @discardableResult
    func headerSpacing(_ value: (Self) -> Double) -> Self {
        return self.headerSpacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func leadings(_ value: [IView]) -> Self {
        self.leadings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadings(_ value: () -> [IView]) -> Self {
        return self.leadings(value())
    }

    @inlinable
    @discardableResult
    func leadings(_ value: (Self) -> [IView]) -> Self {
        return self.leadings(value(self))
    }
    
    @inlinable
    @discardableResult
    func leadingsSpacing(_ value: Double) -> Self {
        self.leadingsSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingsSpacing(_ value: () -> Double) -> Self {
        return self.leadingsSpacing(value())
    }

    @inlinable
    @discardableResult
    func leadingsSpacing(_ value: (Self) -> Double) -> Self {
        return self.leadingsSpacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func center(_ value: IView?) -> Self {
        self.center = value
        return self
    }
    
    @inlinable
    @discardableResult
    func center(_ value: () -> IView?) -> Self {
        return self.center(value())
    }

    @inlinable
    @discardableResult
    func center(_ value: (Self) -> IView?) -> Self {
        return self.center(value(self))
    }
    
    @inlinable
    @discardableResult
    func centerFilling(_ value: Bool) -> Self {
        self.centerFilling = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerFilling(_ value: () -> Bool) -> Self {
        return self.centerFilling(value())
    }

    @inlinable
    @discardableResult
    func centerFilling(_ value: (Self) -> Bool) -> Self {
        return self.centerFilling(value(self))
    }
    
    @inlinable
    @discardableResult
    func centerSpacing(_ value: Double) -> Self {
        self.centerSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerSpacing(_ value: () -> Double) -> Self {
        return self.centerSpacing(value())
    }

    @inlinable
    @discardableResult
    func centerSpacing(_ value: (Self) -> Double) -> Self {
        return self.centerSpacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func trailings(_ value: [IView]) -> Self {
        self.trailings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailings(_ value: () -> [IView]) -> Self {
        return self.trailings(value())
    }

    @inlinable
    @discardableResult
    func trailings(_ value: (Self) -> [IView]) -> Self {
        return self.trailings(value(self))
    }
    
    @inlinable
    @discardableResult
    func trailingsSpacing(_ value: Double) -> Self {
        self.trailingsSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingsSpacing(_ value: () -> Double) -> Self {
        return self.trailingsSpacing(value())
    }

    @inlinable
    @discardableResult
    func trailingsSpacing(_ value: (Self) -> Double) -> Self {
        return self.trailingsSpacing(value(self))
    }
    
    @inlinable
    @discardableResult
    func footer(_ value: IView?) -> Self {
        self.footer = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footer(_ value: () -> IView?) -> Self {
        return self.footer(value())
    }

    @inlinable
    @discardableResult
    func footer(_ value: (Self) -> IView?) -> Self {
        return self.footer(value(self))
    }
    
    @inlinable
    @discardableResult
    func footerSpacing(_ value: Double) -> Self {
        self.footerSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footerSpacing(_ value: () -> Double) -> Self {
        return self.footerSpacing(value())
    }

    @inlinable
    @discardableResult
    func footerSpacing(_ value: (Self) -> Double) -> Self {
        return self.footerSpacing(value(self))
    }
    
}

extension StackBarView : IViewReusable {
}

#if os(iOS)

extension StackBarView : IViewTransformable {
}

#endif

extension StackBarView : IViewColorable {
}

extension StackBarView : IViewAlphable {
}

extension StackBarView : IViewLockable {
}
