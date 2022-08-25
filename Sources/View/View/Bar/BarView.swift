//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public class BarView : IBarView {
    
    public var layout: ILayout? {
        get { return self._view.layout }
    }
    public unowned var item: LayoutItem? {
        set(value) { self._view.item = value }
        get { return self._view.item }
    }
    public var native: NativeView {
        return self._view.native
    }
    public var isLoaded: Bool {
        return self._view.isLoaded
    }
    public var bounds: RectFloat {
        return self._view.bounds
    }
    public var isVisible: Bool {
        return self._view.isVisible
    }
    public var isHidden: Bool {
        set(value) { self._view.isHidden = value }
        get { return self._view.isHidden }
    }
    public var placement: BarViewPlacement {
        set(value) { self._view.contentLayout.placement = value }
        get { return self._view.contentLayout.placement }
    }
    public var size: Float? {
        set(value) { self._view.contentLayout.size = value }
        get { return self._view.contentLayout.size }
    }
    public var safeArea: InsetFloat {
        set(value) { self._view.contentLayout.safeArea = value }
        get { return self._view.contentLayout.safeArea }
    }
    public var separatorView: IView? {
        didSet(oldValue) {
            guard self.separatorView !== oldValue else { return }
            self._view.contentLayout.separatorItem = self.separatorView.flatMap({ LayoutItem(view: $0) })
        }
    }
    public var color: Color? {
        set(value) { self._backgroundView.color = value }
        get { return self._backgroundView.color }
    }
    public var cornerRadius: ViewCornerRadius {
        set(value) { self._backgroundView.cornerRadius = value }
        get { return self._backgroundView.cornerRadius }
    }
    public var border: ViewBorder {
        set(value) { self._backgroundView.border = value }
        get { return self._backgroundView.border }
    }
    public var shadow: ViewShadow? {
        set(value) { self._backgroundView.shadow = value }
        get { return self._backgroundView.shadow }
    }
    public var alpha: Float {
        set(value) { self._view.alpha = value }
        get { return self._view.alpha }
    }
    
    private var _view: CustomView< Layout >
    private var _backgroundView: EmptyView

    public init(
        placement: BarViewPlacement,
        size: Float? = nil,
        separatorView: IView? = nil,
        contentView: IView? = nil,
        color: Color? = nil,
        border: ViewBorder = .none,
        cornerRadius: ViewCornerRadius = .none,
        shadow: ViewShadow? = nil,
        alpha: Float = 1,
        isHidden: Bool = false
    ) {
        self.separatorView = separatorView
        self._backgroundView = EmptyView(
            width: .fill,
            height: .fill,
            color: color,
            border: border,
            cornerRadius: cornerRadius,
            shadow: shadow,
            alpha: alpha
        )
        self._view = CustomView(
            contentLayout: Layout(
                placement: placement,
                size: size,
                safeArea: .zero,
                separatorItem: separatorView.flatMap({ LayoutItem(view: $0) }),
                contentItem: contentView.flatMap({ LayoutItem(view: $0) }),
                backgroundItem: LayoutItem(view: self._backgroundView)
            ),
            isHidden: isHidden
        )
    }
    
    public func loadIfNeeded() {
        self._view.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self._view.size(available: available)
    }
    
    public func appear(to layout: ILayout) {
        self._view.appear(to: layout)
    }
    
    public func disappear() {
        self._view.disappear()
    }
    
    public func visible() {
        self._view.visible()
    }
    
    public func visibility() {
        self._view.visibility()
    }
    
    public func invisible() {
        self._view.invisible()
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self._view.onAppear(value)
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self._view.onDisappear(value)
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self._view.onVisible(value)
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self._view.onVisibility(value)
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self._view.onInvisible(value)
        return self
    }
    
}

extension BarView {
    
    final class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var placement: BarViewPlacement {
            didSet { self.setNeedForceUpdate() }
        }
        var size: Float? {
            didSet { self.setNeedForceUpdate() }
        }
        var safeArea: InsetFloat {
            didSet { self.setNeedForceUpdate() }
        }
        var separatorItem: LayoutItem? {
            didSet { self.setNeedForceUpdate(item: self.separatorItem) }
        }
        var contentItem: LayoutItem? {
            didSet { self.setNeedForceUpdate(item: self.contentItem) }
        }
        var backgroundItem: LayoutItem {
            didSet { self.setNeedForceUpdate(item: self.backgroundItem) }
        }
        
        init(
            placement: BarViewPlacement,
            size: Float?,
            safeArea: InsetFloat,
            separatorItem: LayoutItem?,
            contentItem: LayoutItem?,
            backgroundItem: LayoutItem
        ) {
            self.placement = placement
            self.size = size
            self.safeArea = safeArea
            self.separatorItem = separatorItem
            self.contentItem = contentItem
            self.backgroundItem = backgroundItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            guard let contentItem = self.contentItem else { return .zero }
            let safeBounds = bounds.inset(self.safeArea)
            switch self.placement {
            case .top:
                let separatorHeight: Float
                if let separatorItem = self.separatorItem {
                    let separatorSize = separatorItem.size(available: SizeFloat(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separatorItem.frame = RectFloat(
                        bottomLeft: safeBounds.bottomLeft,
                        size: separatorSize
                    )
                    separatorHeight = separatorSize.height
                } else {
                    separatorHeight = 0
                }
                let contentHeight: Float
                if let size = self.size {
                    contentHeight = size
                } else {
                    let contentSize = contentItem.size(available: SizeFloat(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                contentItem.frame = RectFloat(
                    bottom: safeBounds.bottom - PointFloat(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.backgroundItem.frame = RectFloat(
                    topLeft: bounds.topLeft,
                    bottomRight: contentItem.frame.bottomRight
                )
                return SizeFloat(
                    width: bounds.width,
                    height: separatorHeight + contentHeight + self.safeArea.vertical
                )
            case .bottom:
                let separatorHeight: Float
                if let separatorItem = self.separatorItem {
                    let separatorSize = separatorItem.size(available: SizeFloat(
                        width: bounds.width,
                        height: .infinity
                    ))
                    separatorItem.frame = RectFloat(
                        topLeft: safeBounds.topLeft,
                        size: separatorSize
                    )
                    separatorHeight = separatorSize.height
                } else {
                    separatorHeight = 0
                }
                let contentHeight: Float
                if let size = self.size {
                    contentHeight = size
                } else {
                    let contentSize = contentItem.size(available: SizeFloat(
                        width: bounds.width - self.safeArea.horizontal,
                        height: .infinity
                    ))
                    contentHeight = contentSize.height
                }
                contentItem.frame = RectFloat(
                    top: safeBounds.top + PointFloat(x: 0, y: separatorHeight),
                    width: safeBounds.width,
                    height: contentHeight
                )
                self.backgroundItem.frame = RectFloat(
                    topLeft: contentItem.frame.topLeft,
                    bottomRight: bounds.bottomRight
                )
                return SizeFloat(
                    width: bounds.width,
                    height: separatorHeight + contentHeight + self.safeArea.vertical
                )
            }
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            guard let contentItem = self.contentItem else { return .zero }
            var height: Float
            if let size = self.size {
                height = size
            } else {
                let contentSize = contentItem.size(available: SizeFloat(
                    width: available.width - self.safeArea.horizontal,
                    height: .infinity
                ))
                height = contentSize.height
            }
            if let separatorItem = self.separatorItem {
                let separatorSize = separatorItem.size(available: SizeFloat(
                    width: available.width - self.safeArea.horizontal,
                    height: .infinity
                ))
                height += separatorSize.height
            }
            return SizeFloat(
                width: available.width,
                height: height + self.safeArea.vertical
            )
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            var items: [LayoutItem] = [
                self.backgroundItem
            ]
            if let separatorItem = self.separatorItem {
                items.append(separatorItem)
            }
            if let contentItem = self.contentItem {
                items.append(contentItem)
            }
            return items
        }
        
    }
    
}
