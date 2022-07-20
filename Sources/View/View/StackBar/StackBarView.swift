//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public final class StackBarView : BarView, IStackBarView {
    
    public override var size: Float? {
        set(value) {
            guard super.size != value else { return }
            self._relayout()
        }
        get { return super.size }
    }
    public var inset: InsetFloat {
        set(value) { self._contentView.contentLayout.inset = value }
        get { return self._contentView.contentLayout.inset }
    }
    public var headerView: IView? {
        didSet { self._relayout() }
    }
    public var headerSpacing: Float {
        didSet { self._relayout() }
    }
    public var leadingViews: [IView] {
        didSet { self._relayout() }
    }
    public var leadingViewSpacing: Float {
        didSet { self._relayout() }
    }
    public var centerView: IView? {
        didSet { self._relayout() }
    }
    public var centerFilling: Bool {
        didSet { self._relayout() }
    }
    public var centerSpacing: Float {
        didSet { self._relayout() }
    }
    public var trailingViews: [IView] {
        didSet { self._relayout() }
    }
    public var trailingViewSpacing: Float {
        didSet { self._relayout() }
    }
    public var footerView: IView? {
        didSet { self._relayout() }
    }
    public var footerSpacing: Float {
        didSet { self._relayout() }
    }

    private var _contentView: CustomView< CompositionLayout >
    
    public init(
        inset: InsetFloat,
        headerView: IView? = nil,
        headerSpacing: Float = 8,
        leadingViews: [IView] = [],
        leadingViewSpacing: Float = 4,
        centerView: IView? = nil,
        centerFilling: Bool = false,
        centerSpacing: Float = 4,
        trailingViews: [IView] = [],
        trailingViewSpacing: Float = 4,
        footerView: IView? = nil,
        footerSpacing: Float = 8,
        size: Float? = nil,
        separatorView: IView? = nil,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.headerView = headerView
        self.headerSpacing = headerSpacing
        self.leadingViews = leadingViews
        self.leadingViewSpacing = leadingViewSpacing
        self.centerView = centerView
        self.centerFilling = centerFilling
        self.centerSpacing = centerSpacing
        self.trailingViews = trailingViews
        self.trailingViewSpacing = trailingViewSpacing
        self.footerView = footerView
        self.footerSpacing = footerSpacing
        self._contentView = CustomView(
            contentLayout: Self._layout(
                inset: inset,
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
        super.init(
            placement: .top,
            size: size,
            separatorView: separatorView,
            contentView: self._contentView,
            color: color,
            border: border,
            cornerRadius: cornerRadius,
            shadow: shadow,
            alpha: alpha,
            isHidden: isHidden
        )
    }
    
    @discardableResult
    public func inset(_ value: InsetFloat) -> Self {
        self.inset = value
        return self
    }
    
    @discardableResult
    public func headerView(_ value: IView?) -> Self {
        self.headerView = value
        return self
    }
    
    @discardableResult
    public func headerSpacing(_ value: Float) -> Self {
        self.headerSpacing = value
        return self
    }
    
    @discardableResult
    public func leadingViews(_ value: [IView]) -> Self {
        self.leadingViews = value
        return self
    }
    
    @discardableResult
    public func leadingViewSpacing(_ value: Float) -> Self {
        self.leadingViewSpacing = value
        return self
    }
    
    @discardableResult
    public func centerView(_ value: IView?) -> Self {
        self.centerView = value
        return self
    }
    
    @discardableResult
    public func centerFilling(_ value: Bool) -> Self {
        self.centerFilling = value
        return self
    }
    
    @discardableResult
    public func centerSpacing(_ value: Float) -> Self {
        self.centerSpacing = value
        return self
    }
    
    @discardableResult
    public func trailingViews(_ value: [IView]) -> Self {
        self.trailingViews = value
        return self
    }
    
    @discardableResult
    public func trailingViewSpacing(_ value: Float) -> Self {
        self.trailingViewSpacing = value
        return self
    }
    
    @discardableResult
    public func footerView(_ value: IView?) -> Self {
        self.footerView = value
        return self
    }
    
    @discardableResult
    public func footerSpacing(_ value: Float) -> Self {
        self.footerSpacing = value
        return self
    }
    
}

private extension StackBarView {
    
    func _relayout() {
        self._contentView.contentLayout = Self._layout(
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
        headerView: IView?,
        headerSpacing: Float,
        leadingViews: [IView],
        leadingViewSpacing: Float,
        centerView: IView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailingViews: [IView],
        trailingViewSpacing: Float,
        footerView: IView?,
        footerSpacing: Float,
        size: Float?
    ) -> CompositionLayout {
        if headerView == nil && leadingViews.isEmpty == true && centerView == nil && trailingViews.isEmpty == true && footerView == nil {
            return CompositionLayout(
                entity: CompositionLayout.None()
            )
        }
        return CompositionLayout(
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
        headerView: IView?,
        headerSpacing: Float,
        leadingViews: [IView],
        leadingViewSpacing: Float,
        centerView: IView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailingViews: [IView],
        trailingViewSpacing: Float,
        footerView: IView?,
        footerSpacing: Float,
        size: Float?
    ) -> ICompositionLayoutEntity {
        let content = Self._entity(
            leadingViews: leadingViews,
            leadingViewSpacing: leadingViewSpacing,
            centerView: centerView,
            centerFilling: centerFilling,
            centerSpacing: centerSpacing,
            trailingViews: trailingViews,
            trailingViewSpacing: trailingViewSpacing
        )
        let leading: ICompositionLayoutEntity?
        if let headerView = headerView {
            leading = CompositionLayout.Margin(
                inset: InsetFloat(top: 0, left: 0, right: 0, bottom: headerSpacing),
                entity: CompositionLayout.View(headerView)
            )
        } else {
            leading = nil
        }
        let trailing: ICompositionLayoutEntity?
        if let footerView = footerView {
            trailing = CompositionLayout.Margin(
                inset: InsetFloat(top: footerSpacing, left: 0, right: 0, bottom: 0),
                entity: CompositionLayout.View(footerView)
            )
        } else {
            trailing = nil
        }
        if leading == nil && trailing == nil {
            return content
        }
        if size != nil {
            var stackEntities: [ICompositionLayoutEntity] = []
            if let leading = leading {
                stackEntities.append(leading)
            }
            stackEntities.append(content)
            if let trailing = trailing {
                stackEntities.append(trailing)
            }
            return CompositionLayout.VStack(
                alignment: .fill,
                entities: stackEntities
            )
        }
        return CompositionLayout.VAccessory(
            leading: leading,
            center: content,
            trailing: trailing,
            filling: true
        )
    }
    
    static func _entity(
        leadingViews: [IView],
        leadingViewSpacing: Float,
        centerView: IView?,
        centerFilling: Bool,
        centerSpacing: Float,
        trailingViews: [IView],
        trailingViewSpacing: Float
    ) -> ICompositionLayoutEntity {
        let center: ICompositionLayoutEntity
        if let centerView = centerView {
            center = CompositionLayout.Margin(
                inset: InsetFloat(
                    top: 0,
                    left: leadingViews.count > 0 ? centerSpacing : 0,
                    right: trailingViews.count > 0 ? centerSpacing : 0,
                    bottom: 0
                ),
                entity: CompositionLayout.View(centerView)
            )
        } else {
            center = CompositionLayout.None()
        }
        let leading: ICompositionLayoutEntity?
        if leadingViews.isEmpty == false {
            leading = CompositionLayout.HStack(
                alignment: .fill,
                spacing: leadingViewSpacing,
                entities: leadingViews.map({ CompositionLayout.View($0) })
            )
        } else {
            leading = nil
        }
        let trailing: ICompositionLayoutEntity?
        if trailingViews.isEmpty == false {
            trailing = CompositionLayout.HStack(
                alignment: .fill,
                spacing: trailingViewSpacing,
                entities: trailingViews.reversed().map({ CompositionLayout.View($0) })
            )
        } else {
            trailing = nil
        }
        return CompositionLayout.HAccessory(
            leading: leading,
            center: center,
            trailing: trailing,
            filling: centerFilling
        )
    }
    
}
