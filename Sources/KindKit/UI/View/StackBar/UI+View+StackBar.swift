//
//  KindKit
//

import Foundation

public extension UI.View {

    final class StackBar : IUIWidgetView {
        
        public let body: UI.View.Bar
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
        public var header: IUIView? {
            didSet { self._relayout() }
        }
        public var headerSpacing: Double = 8 {
            didSet {
                guard self.headerSpacing != oldValue else { return }
                self._relayout()
            }
        }
        public var leadings: [IUIView] = [] {
            didSet { self._relayout() }
        }
        public var leadingsSpacing: Double = 4 {
            didSet {
                guard self.leadingsSpacing != oldValue else { return }
                self._relayout()
            }
        }
        public var center: IUIView? {
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
        public var trailings: [IUIView] = [] {
            didSet { self._relayout() }
        }
        public var trailingsSpacing: Double = 4 {
            didSet {
                guard self.trailingsSpacing != oldValue else { return }
                self._relayout()
            }
        }
        public var footer: IUIView? {
            didSet { self._relayout() }
        }
        public var footerSpacing: Double = 8 {
            didSet {
                guard self.footerSpacing != oldValue else { return }
                self._relayout()
            }
        }

        private var _contentLayout: UI.Layout.Composition {
            didSet {
                self._contentView.content = self._contentLayout
            }
        }
        private var _contentView: UI.View.Custom
        
        public init() {
            self._contentLayout = UI.Layout.Composition(
                inset: .init(horizontal: 8, vertical: 4),
                entity: .none()
            )
            self._contentView = UI.View.Custom()
                .content(self._contentLayout)
            self.body = .init(
                placement: .top,
                content: self._contentView
            )
        }
        
    }
    
}

private extension UI.View.StackBar {
    
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
        header: IUIView?,
        headerSpacing: Double,
        leadings: [IUIView],
        leadingsSpacing: Double,
        center: IUIView?,
        centerFilling: Bool,
        centerSpacing: Double,
        trailings: [IUIView],
        trailingsSpacing: Double,
        footer: IUIView?,
        footerSpacing: Double,
        size: Double?
    ) -> UI.Layout.Composition {
        if header == nil && leadings.isEmpty == true && center == nil && trailings.isEmpty == true && footer == nil {
            return .composition(
                inset: inset,
                entity: .none()
            )
        }
        return .composition(
            inset: inset,
            entity: self._entity(
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
    
    static func _entity(
        header: IUIView?,
        headerSpacing: Double,
        leadings: [IUIView],
        leadingsSpacing: Double,
        center: IUIView?,
        centerFilling: Bool,
        centerSpacing: Double,
        trailings: [IUIView],
        trailingsSpacing: Double,
        footer: IUIView?,
        footerSpacing: Double,
        size: Double?
    ) -> IUICompositionLayoutEntity {
        let contentEntity = Self._entity(
            leadings: leadings,
            leadingsSpacing: leadingsSpacing,
            center: center,
            centerFilling: centerFilling,
            centerSpacing: centerSpacing,
            trailings: trailings,
            trailingsSpacing: trailingsSpacing
        )
        let leadingEntity: IUICompositionLayoutEntity?
        if let header = header {
            leadingEntity = .margin(
                inset: .init(top: 0, left: 0, right: 0, bottom: headerSpacing),
                entity: .view(header)
            )
        } else {
            leadingEntity = nil
        }
        let trailingEntity: IUICompositionLayoutEntity?
        if let footer = footer {
            trailingEntity = .margin(
                inset: .init(top: footerSpacing, left: 0, right: 0, bottom: 0),
                entity: .view(footer)
            )
        } else {
            trailingEntity = nil
        }
        if leadingEntity == nil && trailingEntity == nil {
            return contentEntity
        }
        if size != nil {
            var stackEntities: [IUICompositionLayoutEntity] = []
            if let leadingEntity = leadingEntity {
                stackEntities.append(leadingEntity)
            }
            stackEntities.append(contentEntity)
            if let trailingEntity = trailingEntity {
                stackEntities.append(trailingEntity)
            }
            return .vStack(
                alignment: .fill,
                entities: stackEntities
            )
        }
        return .vAccessory(
            leading: leadingEntity,
            center: contentEntity,
            trailing: trailingEntity,
            filling: true
        )
    }
    
    static func _entity(
        leadings: [IUIView],
        leadingsSpacing: Double,
        center: IUIView?,
        centerFilling: Bool,
        centerSpacing: Double,
        trailings: [IUIView],
        trailingsSpacing: Double
    ) -> IUICompositionLayoutEntity {
        let centerEntity: IUICompositionLayoutEntity
        if let center = center {
            centerEntity = .margin(
                inset: Inset(
                    top: 0,
                    left: leadings.count > 0 ? centerSpacing : 0,
                    right: trailings.count > 0 ? centerSpacing : 0,
                    bottom: 0
                ),
                entity: .view(center)
            )
        } else {
            centerEntity = .none()
        }
        let leadingEntity: IUICompositionLayoutEntity?
        if leadings.isEmpty == false {
            leadingEntity = .hStack(
                alignment: .fill,
                spacing: leadingsSpacing,
                entities: leadings.map({ UI.Layout.Composition.View($0) })
            )
        } else {
            leadingEntity = nil
        }
        let trailingEntity: IUICompositionLayoutEntity?
        if trailings.isEmpty == false {
            trailingEntity = .hStack(
                alignment: .fill,
                spacing: trailingsSpacing,
                entities: trailings.reversed().map({ UI.Layout.Composition.View($0) })
            )
        } else {
            trailingEntity = nil
        }
        return .hAccessory(
            leading: leadingEntity,
            center: centerEntity,
            trailing: trailingEntity,
            filling: centerFilling
        )
    }
    
}

public extension UI.View.StackBar {
    
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
    func header(_ value: IUIView?) -> Self {
        self.header = value
        return self
    }
    
    @inlinable
    @discardableResult
    func header(_ value: () -> IUIView?) -> Self {
        return self.header(value())
    }

    @inlinable
    @discardableResult
    func header(_ value: (Self) -> IUIView?) -> Self {
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
    func leadings(_ value: [IUIView]) -> Self {
        self.leadings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadings(_ value: () -> [IUIView]) -> Self {
        return self.leadings(value())
    }

    @inlinable
    @discardableResult
    func leadings(_ value: (Self) -> [IUIView]) -> Self {
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
    func center(_ value: IUIView?) -> Self {
        self.center = value
        return self
    }
    
    @inlinable
    @discardableResult
    func center(_ value: () -> IUIView?) -> Self {
        return self.center(value())
    }

    @inlinable
    @discardableResult
    func center(_ value: (Self) -> IUIView?) -> Self {
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
    func trailings(_ value: [IUIView]) -> Self {
        self.trailings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailings(_ value: () -> [IUIView]) -> Self {
        return self.trailings(value())
    }

    @inlinable
    @discardableResult
    func trailings(_ value: (Self) -> [IUIView]) -> Self {
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
    func footer(_ value: IUIView?) -> Self {
        self.footer = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footer(_ value: () -> IUIView?) -> Self {
        return self.footer(value())
    }

    @inlinable
    @discardableResult
    func footer(_ value: (Self) -> IUIView?) -> Self {
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

extension UI.View.StackBar : IUIViewReusable {
}

#if os(iOS)

extension UI.View.StackBar : IUIViewTransformable {
}

#endif

extension UI.View.StackBar : IUIViewColorable {
}

extension UI.View.StackBar : IUIViewAlphable {
}

extension UI.View.StackBar : IUIViewLockable {
}

public extension IUIView where Self == UI.View.StackBar {
    
    @inlinable
    static func stackBar() -> Self {
        return .init()
    }
    
}
