////
////  KindKit
////
//
//import KindLayout
//
//fileprivate enum Defaults {
//    
//    static let inset = Inset.zero
//    
//}
//
//public final class CellView< Background : IView, Content : ITemplate > : IComposite, IView, IViewSupportDynamicSize, IViewSupportContent, IViewSupportContentInset,  IViewSupportPress, IViewSupportAlpha, IViewContainBackground, IViewContainTemplate {
//    
//    public let body: PressView< AnyLayout >
//    
//    public var background: Background {
//        set { self._layout.substrate.content = newValue }
//        get { self._layout.substrate.content }
//    }
//    
//    public var content: Content {
//        didSet {
//            guard self.content != oldValue else { return }
//            self._layout.content.content = self.content.layout
//        }
//    }
//    
//    public var contentInset: Inset {
//        set { self._layout.content.inset = newValue }
//        get { self._layout.content.inset }
//    }
//    
//    private let _layout: SubstrateLayout<
//        ViewLayout< Background >,
//        MarginLayout< 
//            Content.Layout
//        >
//    >
//    
//    public init(
//        background: Background,
//        content: Content
//    ) {
//        self.content = content
//        
//        self._layout = SubstrateLayout(
//            substrate: ViewLayout(background),
//            content: MarginLayout(
//                content.layout
//            ).update(on: {
//                $0.inset = Defaults.inset
//            })
//        )
//        
//        self.body = .init(self._layout)
//    }
//    
//}
//
//extension CellView : IViewSupportHighlighted where Background : IViewSupportHighlighted, Content : IViewSupportHighlighted {
//    
//    public var isHighlighted: Bool {
//        set {
//            self.body.isHighlighted = newValue
//            self.background.isHighlighted = newValue
//            self.content.isHighlighted = newValue
//        }
//        get { self.body.isHighlighted }
//    }
//    
//}
//
//extension CellView : IViewSupportSelected where Background : IViewSupportSelected, Content : IViewSupportSelected {
//    
//    public var isSelected: Bool {
//        set {
//            self.body.isSelected = newValue
//            self.background.isSelected = newValue
//            self.content.isSelected = newValue
//        }
//        get { self.body.isSelected }
//    }
//    
//}
//
//extension CellView : IViewSupportEnable where Background : IViewSupportEnable, Content : IViewSupportEnable {
//    
//    public var isEnabled: Bool {
//        set {
//            self.body.isEnabled = newValue
//            self.background.isEnabled = newValue
//            self.content.isEnabled = newValue
//        }
//        get { self.body.isEnabled }
//    }
//    
//}
