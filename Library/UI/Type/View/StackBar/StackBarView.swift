//
//  KindKit
//

import KindLayout
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let placement = Placement.top
    static let inset = Inset(horizontal: 8, vertical: 4)
    static let headerSpacing = Double(8)
    static let leadingsSpacing = Double(4)
    static let centerFilling: Bool = true
    static let centerSpacing = Double(8)
    static let trailingsSpacing = Double(4)
    static let footerSpacing = Double(8)
    
}

@Monadic
public final class StackBarView< Background : IView, Header : IView, Center : IView, Footer : IView, Separator : IView > : CompositorTrait, IView, IViewSupportDynamicSize, IViewSupportContentInset, IViewSupportPlacement, IViewSupportAlpha, IViewContainBackground, IViewContainSeparator {
    
    public let body: BarView< Background, LayoutView< AnyLayout >, Separator >
    
    public var size: DynamicSize {
        set {
            self.body.width = newValue.width
            self._content.height = newValue.height
        }
        get {
            return .init(
                width: self.body.width,
                height: self._content.height
            )
        }
    }
    
    @MonadicField(default: EmptyView.self)
    public var background: Background {
        set { self.body.background = newValue }
        get { self.body.background }
    }
    
    @MonadicField(default: EmptyView.self)
    public var separator: Separator {
        set { self.body.separator = newValue }
        get { self.body.separator }
    }
    
    @MonadicField
    @MonadicField(default: EmptyView.self)
    public var header: Header {
        set { self._contentLayout.leading.content.content = newValue }
        get { self._contentLayout.leading.content.content }
    }
    
    @MonadicField
    public var headerSpacing: Double {
        set { self._contentLayout.leading.inset = .init(top: 0, left: 0, right: 0, bottom: newValue) }
        get { self._contentLayout.leading.inset.bottom }
    }
    
    @MonadicField
    public var leadings: [any IView] = [] {
        didSet {
            guard self.leadings.elementsEqual(oldValue, by: { $0 === $1 }) == false else { return }
            self._contentLayout.center.leading.content.content = self.leadings.map({
                AnyViewLayout($0)
            })
        }
    }
    
    @MonadicField
    public var leadingsSpacing: Double {
        set { self._contentLayout.center.leading.content.spacing = newValue }
        get { self._contentLayout.center.leading.content.spacing }
    }
    
    @MonadicField
    @MonadicField(default: EmptyView.self)
    public var center: Center {
        set { self._contentLayout.center.center.content = newValue }
        get { self._contentLayout.center.center.content }
    }
    
    @MonadicField
    public var centerFilling: Bool {
        set { self._contentLayout.center.filling = newValue }
        get { self._contentLayout.center.filling }
    }
    
    @MonadicField
    public var centerSpacing: Double = Defaults.centerSpacing {
        didSet {
            guard self.centerSpacing != oldValue else { return }
            self._contentLayout.center.leading.inset = .init(top: 0, left: 0, right: self.centerSpacing, bottom: 0)
            self._contentLayout.center.trailing.inset = .init(top: 0, left: self.centerSpacing, right: 0, bottom: 0)
        }
    }
    
    @MonadicField
    public var trailings: [any IView] = [] {
        didSet {
            guard self.trailings.elementsEqual(oldValue, by: { $0 === $1 }) == false else { return }
            self._contentLayout.center.trailing.content.content = self.trailings.map({
                AnyViewLayout($0)
            })
        }
    }
    
    @MonadicField
    public var trailingsSpacing: Double {
        set { self._contentLayout.center.trailing.content.spacing = newValue }
        get { self._contentLayout.center.trailing.content.spacing }
    }
    
    @MonadicField
    @MonadicField(default: EmptyView.self)
    public var footer: Footer {
        set { self._contentLayout.trailing.content.content = newValue }
        get { self._contentLayout.trailing.content.content }
    }
    
    @MonadicField
    public var footerSpacing: Double {
        set { self._contentLayout.trailing.inset = .init(top: newValue, left: 0, right: 0, bottom: 0) }
        get { self._contentLayout.trailing.inset.top }
    }
    
    private let _contentLayout: VAccessoryLayout<
        MarginLayout<
            ViewLayout< Header >
        >,
        HAccessoryLayout<
            MarginLayout< HStackLayout >,
            ViewLayout< Center >,
            MarginLayout< HStackLayout >
        >,
        MarginLayout<
            ViewLayout< Footer >
        >
    >
    
    private let _content: LayoutView< AnyLayout >
    
    public init(
        background: Background,
        header: Header,
        center: Center,
        footer: Footer,
        separator: Separator
    ) {
        self._contentLayout = VAccessoryLayout(
            leading: MarginLayout(ViewLayout(header)).update(on: {
                $0.inset.bottom = Defaults.headerSpacing
            }),
            center: HAccessoryLayout(
                leading: MarginLayout(HStackLayout()).update(on: {
                    $0.inset.right = Defaults.centerSpacing
                }),
                center: ViewLayout(center),
                trailing: MarginLayout(HStackLayout()).update(on: {
                    $0.inset.left = Defaults.centerSpacing
                })
            ).update(on: {
                $0.alignment = .center
                $0.filling = Defaults.centerFilling
            }),
            trailing: MarginLayout(ViewLayout(footer)).update(on: {
                $0.inset.top = Defaults.footerSpacing
            })
        ).update(on: {
            $0.alignment = .center
        })
        
        self._content = .init(self._contentLayout)
            .width(.fill)
        
        self.body = .init(background: background, content: self._content, separator: separator)
            .placement(Defaults.placement)
    }
    
}

extension StackBarView : IViewSupportColor where Body : IViewSupportColor {
}
