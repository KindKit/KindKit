//
//  KindKit
//

import Foundation

public extension UI.View {

    final class StackBar : IUIWidgetView {
        
        public let body: UI.View.Bar
        public var size: Float? {
            set {
                guard self.body.size != newValue else { return }
                self.body.size = newValue
                self._relayout()
            }
            get { self.body.size }
        }
        public var inset: InsetFloat {
            set { self._contentLayout.inset = newValue }
            get { self._contentLayout.inset }
        }
        public var header: IUIView? {
            didSet { self._relayout() }
        }
        public var headerSpacing: Float = 8 {
            didSet {
                guard self.headerSpacing != oldValue else { return }
                self._relayout()
            }
        }
        public var leadings: [IUIView] = [] {
            didSet { self._relayout() }
        }
        public var leadingsSpacing: Float = 4 {
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
        public var centerSpacing: Float = 4 {
            didSet {
                guard self.centerSpacing != oldValue else { return }
                self._relayout()
            }
        }
        public var trailings: [IUIView] = [] {
            didSet { self._relayout() }
        }
        public var trailingsSpacing: Float = 4 {
            didSet {
                guard self.trailingsSpacing != oldValue else { return }
                self._relayout()
            }
        }
        public var footer: IUIView? {
            didSet { self._relayout() }
        }
        public var footerSpacing: Float = 8 {
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
        inset: InsetFloat,
        header: IUIView?,
        headerSpacing: Float,
        leadings: [IUIView],
        leadingsSpacing: Float,
        center: IUIView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailings: [IUIView],
        trailingsSpacing: Float,
        footer: IUIView?,
        footerSpacing: Float,
        size: Float?
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
        headerSpacing: Float,
        leadings: [IUIView],
        leadingsSpacing: Float,
        center: IUIView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailings: [IUIView],
        trailingsSpacing: Float,
        footer: IUIView?,
        footerSpacing: Float,
        size: Float?
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
        leadingsSpacing: Float,
        center: IUIView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailings: [IUIView],
        trailingsSpacing: Float
    ) -> IUICompositionLayoutEntity {
        let centerEntity: IUICompositionLayoutEntity
        if let center = center {
            centerEntity = .margin(
                inset: InsetFloat(
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
    func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @inlinable
    @discardableResult
    func header(_ value: IUIView?) -> Self {
        self.header = value
        return self
    }
    
    @inlinable
    @discardableResult
    func headerSpacing(_ value: Float) -> Self {
        self.headerSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadings(_ value: [IUIView]) -> Self {
        self.leadings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingsSpacing(_ value: Float) -> Self {
        self.leadingsSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func center(_ value: IUIView?) -> Self {
        self.center = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerFilling(_ value: Bool) -> Self {
        self.centerFilling = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerSpacing(_ value: Float) -> Self {
        self.centerSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailings(_ value: [IUIView]) -> Self {
        self.trailings = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingsSpacing(_ value: Float) -> Self {
        self.trailingsSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footer(_ value: IUIView?) -> Self {
        self.footer = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footerSpacing(_ value: Float) -> Self {
        self.footerSpacing = value
        return self
    }
    
}

extension UI.View.StackBar : IUIViewReusable {
}

extension UI.View.StackBar : IUIViewColorable {
}

extension UI.View.StackBar : IUIViewAlphable {
}

extension UI.View.StackBar : IUIViewLockable {
}
