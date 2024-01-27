//
//  KindKit
//

import KindUI
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

@KindMonadic
public final class StackBarView< BackgroundType : IView, HeaderType : IView, CenterType : IView, FooterType : IView, SeparatorType : IView > : IComposite, IView {
    
    public let body: BarView< BackgroundType, LayoutView< AnyLayout >, SeparatorType >
    
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
    
    @KindMonadicProperty(default: EmptyView.self)
    public var background: BackgroundType {
        set { self.body.background = newValue }
        get { self.body.background }
    }
    
    @KindMonadicProperty(default: EmptyView.self)
    public var separator: SeparatorType {
        set { self.body.separator = newValue }
        get { self.body.separator }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyView.self)
    public var header: HeaderType {
        set { self._contentLayout.leading.content.content = newValue }
        get { self._contentLayout.leading.content.content }
    }
    
    @KindMonadicProperty
    public var headerSpacing: Double {
        set { self._contentLayout.leading.inset = .init(top: 0, left: 0, right: 0, bottom: newValue) }
        get { self._contentLayout.leading.inset.bottom }
    }
    
    @KindMonadicProperty
    public var leadings: [any IView] = [] {
        didSet {
            guard self.leadings.elementsEqual(oldValue, by: { $0 === $1 }) == false else { return }
            self._contentLayout.center.leading.content.content = self.leadings.map({
                AnyViewLayout($0)
            })
        }
    }
    
    @KindMonadicProperty
    public var leadingsSpacing: Double {
        set { self._contentLayout.center.leading.content.spacing = newValue }
        get { self._contentLayout.center.leading.content.spacing }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyView.self)
    public var center: CenterType {
        set { self._contentLayout.center.center.content = newValue }
        get { self._contentLayout.center.center.content }
    }
    
    @KindMonadicProperty
    public var centerFilling: Bool {
        set { self._contentLayout.center.filling = newValue }
        get { self._contentLayout.center.filling }
    }
    
    @KindMonadicProperty
    public var centerSpacing: Double = Defaults.centerSpacing {
        didSet {
            guard self.centerSpacing != oldValue else { return }
            self._contentLayout.center.leading.inset = .init(top: 0, left: 0, right: self.centerSpacing, bottom: 0)
            self._contentLayout.center.trailing.inset = .init(top: 0, left: self.centerSpacing, right: 0, bottom: 0)
        }
    }
    
    @KindMonadicProperty
    public var trailings: [any IView] = [] {
        didSet {
            guard self.trailings.elementsEqual(oldValue, by: { $0 === $1 }) == false else { return }
            self._contentLayout.center.trailing.content.content = self.trailings.map({
                AnyViewLayout($0)
            })
        }
    }
    
    @KindMonadicProperty
    public var trailingsSpacing: Double {
        set { self._contentLayout.center.trailing.content.spacing = newValue }
        get { self._contentLayout.center.trailing.content.spacing }
    }
    
    @KindMonadicProperty
    @KindMonadicProperty(default: EmptyView.self)
    public var footer: FooterType {
        set { self._contentLayout.trailing.content.content = newValue }
        get { self._contentLayout.trailing.content.content }
    }
    
    @KindMonadicProperty
    public var footerSpacing: Double {
        set { self._contentLayout.trailing.inset = .init(top: newValue, left: 0, right: 0, bottom: 0) }
        get { self._contentLayout.trailing.inset.top }
    }
    
    private let _contentLayout: VAccessoryLayout<
        MarginLayout<
            ViewLayout< HeaderType >
        >,
        HAccessoryLayout<
            MarginLayout< HStackLayout >,
            ViewLayout< CenterType >,
            MarginLayout< HStackLayout >
        >,
        MarginLayout<
            ViewLayout< FooterType >
        >
    >
    
    private let _content: LayoutView< AnyLayout >
    
    public init(
        background: BackgroundType,
        header: HeaderType,
        center: CenterType,
        footer: FooterType,
        separator: SeparatorType
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
            .height(.fit)
    }
    
}

extension StackBarView : IViewSupportDynamicSize {
}

extension StackBarView : IViewSupportColor where BodyType : IViewSupportColor {
}

extension StackBarView : IViewSupportAlpha {
}

extension StackBarView : IViewSupportPlacement {
}

extension StackBarView : IViewSupportInset {
}

extension StackBarView : IViewSupportBackground {
}

extension StackBarView : IViewSupportSeparator {
}
