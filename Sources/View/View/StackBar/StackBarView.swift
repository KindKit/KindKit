//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class StackBarView : BarView, IStackBarView {
    
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
    public var titleView: IView? {
        didSet { self._relayout() }
    }
    public var titleSpacing: Float {
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
        titleView: IView? = nil,
        titleSpacing: Float = 4,
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
        self.titleView = titleView
        self.titleSpacing = titleSpacing
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
                titleView: titleView,
                titleSpacing: titleSpacing,
                trailingViews: trailingViews,
                trailingViewSpacing: trailingViewSpacing,
                footerView: footerView,
                footerSpacing: footerSpacing
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
    public func titleView(_ value: IView?) -> Self {
        self.titleView = value
        return self
    }
    
    @discardableResult
    public func titleSpacing(_ value: Float) -> Self {
        self.titleSpacing = value
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
    
    static func _layout(
        inset: InsetFloat,
        headerView: IView?,
        headerSpacing: Float,
        leadingViews: [IView],
        leadingViewSpacing: Float,
        titleView: IView?,
        titleSpacing: Float,
        trailingViews: [IView],
        trailingViewSpacing: Float,
        footerView: IView?,
        footerSpacing: Float
    ) -> CompositionLayout {
        var vstack: [ICompositionLayoutEntity] = []
        if let headerView = headerView {
            vstack.append(CompositionLayout.Margin(
                inset: InsetFloat(top: 0, left: 0, right: 0, bottom: headerSpacing),
                entity: CompositionLayout.View(headerView)
            ))
        }
        vstack.append(CompositionLayout.HAccessory(
            leading: CompositionLayout.HStack(
                alignment: .fill,
                spacing: leadingViewSpacing,
                entities: leadingViews.compactMap({ CompositionLayout.View($0) })
            ),
            center: CompositionLayout.Margin(
                inset: InsetFloat(
                    top: 0,
                    left: leadingViews.count > 0 ? titleSpacing : 0,
                    right: trailingViews.count > 0 ? titleSpacing : 0,
                    bottom: 0
                ),
                entity: titleView.flatMap({ CompositionLayout.View($0) }) ?? CompositionLayout.None()
            ),
            trailing: CompositionLayout.HStack(
                alignment: .fill,
                spacing: trailingViewSpacing,
                entities: trailingViews.reversed().compactMap({ CompositionLayout.View($0) })
            ),
            filling: true
        ))
        if let footerView = footerView {
            vstack.append(CompositionLayout.Margin(
                inset: InsetFloat(top: footerSpacing, left: 0, right: 0, bottom: 0),
                entity: CompositionLayout.View(footerView)
            ))
        }
        return CompositionLayout(
            inset: inset,
            entity: CompositionLayout.VStack(
                alignment: .fill,
                entities: vstack
            )
        )
    }
    
    func _relayout() {
        self._contentView.contentLayout = Self._layout(
            inset: self.inset,
            headerView: self.headerView,
            headerSpacing: self.headerSpacing,
            leadingViews: self.leadingViews,
            leadingViewSpacing: self.leadingViewSpacing,
            titleView: self.titleView,
            titleSpacing: self.titleSpacing,
            trailingViews: self.trailingViews,
            trailingViewSpacing: self.trailingViewSpacing,
            footerView: self.footerView,
            footerSpacing: self.footerSpacing
        )
    }
    
}
