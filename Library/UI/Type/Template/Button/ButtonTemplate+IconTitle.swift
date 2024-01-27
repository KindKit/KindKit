//
//  KindKit
//

import KindLayout
import KindStyleSheet
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let inset = Inset(horizontal: 4, vertical: 4)
    static let spacing = 4.0
    
}

extension ButtonTemplate {
    
    public struct IconTitle<
        Background : IView & IViewSupportStyleSheet,
        Icon : IView & IViewSupportStyleSheet,
        Title : IView & IViewSupportStyleSheet
    > : ITemplate {
        
        public typealias Layout = SubstrateLayout<
            ViewLayout< Background >,
            MarginLayout<
                HAccessoryLayout<
                    ViewLayout< Icon >,
                    MarginLayout<
                        ViewLayout< Title >
                    >,
                    EmptyLayout
                >
            >
        >
        
        public typealias StyleSheet = Disabled< Selected< Highlighted< StyleSheet > > >
        
        public let layout: Layout
        
        public var background: Background {
            nonmutating set { self.layout.substrate.content = newValue }
            get { self.layout.substrate.content }
        }
        
        public var inset: Inset {
            nonmutating set { self.layout.content.inset = newValue }
            get { self.layout.content.inset }
        }
        
        public var icon: Icon {
            nonmutating set { self.layout.content.content.leading.content = newValue }
            get { self.layout.content.content.leading.content }
        }
        
        public var spacing: Double {
            nonmutating set { self.layout.content.content.center.inset.left = newValue }
            get { self.layout.content.content.center.inset.left }
        }
        
        public var title: Title {
            nonmutating set { self.layout.content.content.center.content.content = newValue }
            get { self.layout.content.content.center.content.content }
        }
        
        public init(
            background: Background,
            inset: Inset? = nil,
            icon: Icon,
            spacing: Double? = nil,
            title: Title
        ) {
            self.layout = SubstrateLayout(
                substrate: ViewLayout(background),
                content: MarginLayout(
                    HAccessoryLayout(
                        leading: ViewLayout(icon),
                        center: MarginLayout(
                            ViewLayout(title)
                        ).update(on: {
                            $0.inset.left = spacing ?? Defaults.spacing
                        })
                    ).update(on: {
                        $0.alignment = .center
                    })
                ).update(on: {
                    $0.inset = inset ?? Defaults.inset
                })
            )
        }
        
        public func apply(_ styleSheet: StyleSheet.Resolve) {
            self.layout.update(on: {
                self.background.apply(styleSheet.background)
                if let inset = styleSheet.inset {
                    self.inset = inset
                }
                self.icon.apply(styleSheet.icon)
                if let spacing = styleSheet.spacing {
                    self.spacing = spacing
                }
                self.title.apply(styleSheet.title)
            })
        }
        
    }
    
}

extension ButtonTemplate.IconTitle {
    
    public struct StyleSheet : StyleSheetTrait {
        
        public let background: Background.StyleSheet
        
        public let inset: Inset?
        
        public let icon: Icon.StyleSheet
        
        public let spacing: Double?
        
        public let title: Title.StyleSheet
        
        public init(
            background: Background.StyleSheet,
            inset: Inset? = nil,
            icon: Icon.StyleSheet,
            spacing: Double? = nil,
            title: Title.StyleSheet
        ) {
            self.background = background
            self.inset = inset
            self.icon = icon
            self.spacing = spacing
            self.title = title
        }
        
    }
    
}
