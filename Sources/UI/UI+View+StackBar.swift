//
//  KindKit
//

import Foundation

public extension UI.View {

    final class StackBar : IUIWidgetView, IUIViewLockable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var size: Float? {
            set(value) {
                guard self.body.size != value else { return }
                self._relayout()
            }
            get { return self.body.size }
        }
        public var inset: InsetFloat {
            set(value) { self._contentLayout.inset = value }
            get { return self._contentLayout.inset }
        }
        public var headerView: IUIView? {
            didSet { self._relayout() }
        }
        public var headerSpacing: Float = 8 {
            didSet { self._relayout() }
        }
        public var leadingViews: [IUIView] = [] {
            didSet { self._relayout() }
        }
        public var leadingViewSpacing: Float = 4 {
            didSet { self._relayout() }
        }
        public var centerView: IUIView? {
            didSet { self._relayout() }
        }
        public var centerFilling: Bool = false {
            didSet { self._relayout() }
        }
        public var centerSpacing: Float = 4 {
            didSet { self._relayout() }
        }
        public var trailingViews: [IUIView] = [] {
            didSet { self._relayout() }
        }
        public var trailingViewSpacing: Float = 4 {
            didSet { self._relayout() }
        }
        public var footerView: IUIView? {
            didSet { self._relayout() }
        }
        public var footerSpacing: Float = 8 {
            didSet { self._relayout() }
        }
        public private(set) var body: UI.View.Bar

        private var _contentLayout: UI.Layout.Composition {
            didSet {
                self._contentView.contentLayout = self._contentLayout
            }
        }
        private var _contentView: UI.View.Custom
        
        public init() {
            self._contentLayout = UI.Layout.Composition(
                inset: Inset(horizontal: 8, vertical: 4),
                entity: UI.Layout.Composition.None()
            )
            self._contentView = UI.View.Custom(self._contentLayout)
            self.body = .init(
                placement: .top,
                contentView: self._contentView
            )
        }
        
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
    func headerView(_ value: IUIView?) -> Self {
        self.headerView = value
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
    func leadingViews(_ value: [IUIView]) -> Self {
        self.leadingViews = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingViewSpacing(_ value: Float) -> Self {
        self.leadingViewSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func centerView(_ value: IUIView?) -> Self {
        self.centerView = value
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
    func trailingViews(_ value: [IUIView]) -> Self {
        self.trailingViews = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingViewSpacing(_ value: Float) -> Self {
        self.trailingViewSpacing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footerView(_ value: IUIView?) -> Self {
        self.footerView = value
        return self
    }
    
    @inlinable
    @discardableResult
    func footerSpacing(_ value: Float) -> Self {
        self.footerSpacing = value
        return self
    }
    
}

private extension UI.View.StackBar {
    
    func _relayout() {
        self._contentLayout = Self._layout(
            inset: self.inset,
            headerView: self.headerView,
            headerSpacing: self.headerSpacing,
            leadingViews: self.leadingViews,
            leadingViewSpacing: self.leadingViewSpacing,
            centerView: self.centerView,
            centerFilling: self.centerFilling,
            centerSpacing: self.centerSpacing,
            trailingViews: self.trailingViews,
            trailingViewSpacing: self.trailingViewSpacing,
            footerView: self.footerView,
            footerSpacing: self.footerSpacing,
            size: self.size
        )
    }
    
    static func _layout(
        inset: InsetFloat,
        headerView: IUIView?,
        headerSpacing: Float,
        leadingViews: [IUIView],
        leadingViewSpacing: Float,
        centerView: IUIView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailingViews: [IUIView],
        trailingViewSpacing: Float,
        footerView: IUIView?,
        footerSpacing: Float,
        size: Float?
    ) -> UI.Layout.Composition {
        if headerView == nil && leadingViews.isEmpty == true && centerView == nil && trailingViews.isEmpty == true && footerView == nil {
            return UI.Layout.Composition(
                inset: inset,
                entity: UI.Layout.Composition.None()
            )
        }
        return UI.Layout.Composition(
            inset: inset,
            entity: self._entity(
                headerView: headerView,
                headerSpacing: headerSpacing,
                leadingViews: leadingViews,
                leadingViewSpacing: leadingViewSpacing,
                centerView: centerView,
                centerFilling: centerFilling,
                centerSpacing: centerSpacing,
                trailingViews: trailingViews,
                trailingViewSpacing: trailingViewSpacing,
                footerView: footerView,
                footerSpacing: footerSpacing,
                size: size
            )
        )
    }
    
    static func _entity(
        headerView: IUIView?,
        headerSpacing: Float,
        leadingViews: [IUIView],
        leadingViewSpacing: Float,
        centerView: IUIView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailingViews: [IUIView],
        trailingViewSpacing: Float,
        footerView: IUIView?,
        footerSpacing: Float,
        size: Float?
    ) -> IUICompositionLayoutEntity {
        let content = Self._entity(
            leadingViews: leadingViews,
            leadingViewSpacing: leadingViewSpacing,
            centerView: centerView,
            centerFilling: centerFilling,
            centerSpacing: centerSpacing,
            trailingViews: trailingViews,
            trailingViewSpacing: trailingViewSpacing
        )
        let leading: IUICompositionLayoutEntity?
        if let headerView = headerView {
            leading = UI.Layout.Composition.Margin(
                inset: InsetFloat(top: 0, left: 0, right: 0, bottom: headerSpacing),
                entity: UI.Layout.Composition.View(headerView)
            )
        } else {
            leading = nil
        }
        let trailing: IUICompositionLayoutEntity?
        if let footerView = footerView {
            trailing = UI.Layout.Composition.Margin(
                inset: InsetFloat(top: footerSpacing, left: 0, right: 0, bottom: 0),
                entity: UI.Layout.Composition.View(footerView)
            )
        } else {
            trailing = nil
        }
        if leading == nil && trailing == nil {
            return content
        }
        if size != nil {
            var stackEntities: [IUICompositionLayoutEntity] = []
            if let leading = leading {
                stackEntities.append(leading)
            }
            stackEntities.append(content)
            if let trailing = trailing {
                stackEntities.append(trailing)
            }
            return UI.Layout.Composition.VStack(
                alignment: .fill,
                entities: stackEntities
            )
        }
        return UI.Layout.Composition.VAccessory(
            leading: leading,
            center: content,
            trailing: trailing,
            filling: true
        )
    }
    
    static func _entity(
        leadingViews: [IUIView],
        leadingViewSpacing: Float,
        centerView: IUIView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailingViews: [IUIView],
        trailingViewSpacing: Float
    ) -> IUICompositionLayoutEntity {
        let center: IUICompositionLayoutEntity
        if let centerView = centerView {
            center = UI.Layout.Composition.Margin(
                inset: InsetFloat(
                    top: 0,
                    left: leadingViews.count > 0 ? centerSpacing : 0,
                    right: trailingViews.count > 0 ? centerSpacing : 0,
                    bottom: 0
                ),
                entity: UI.Layout.Composition.View(centerView)
            )
        } else {
            center = UI.Layout.Composition.None()
        }
        let leading: IUICompositionLayoutEntity?
        if leadingViews.isEmpty == false {
            leading = UI.Layout.Composition.HStack(
                alignment: .fill,
                spacing: leadingViewSpacing,
                entities: leadingViews.map({ UI.Layout.Composition.View($0) })
            )
        } else {
            leading = nil
        }
        let trailing: IUICompositionLayoutEntity?
        if trailingViews.isEmpty == false {
            trailing = UI.Layout.Composition.HStack(
                alignment: .fill,
                spacing: trailingViewSpacing,
                entities: trailingViews.reversed().map({ UI.Layout.Composition.View($0) })
            )
        } else {
            trailing = nil
        }
        return UI.Layout.Composition.HAccessory(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: centerFilling
        )
    }
    
}
