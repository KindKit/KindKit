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

extension TabBarItemTemplate {
    
    public struct IconTitle<
        Icon : IView & IViewSupportStyleSheet,
        Title : IView & IViewSupportStyleSheet
    > : ITemplate {
        
        public typealias Layout = MarginLayout<
            VAccessoryLayout<
                ViewLayout< Icon >,
                MarginLayout<
                    ViewLayout< Title >
                >,
                EmptyLayout
            >
        >
        
        public typealias StyleSheet = Selected< Highlighted< StyleSheet > >
        
        public let layout: Layout
        
        public var inset: Inset {
            nonmutating set { self.layout.inset = newValue }
            get { self.layout.inset }
        }
        
        public var icon: Icon {
            nonmutating set { self.layout.content.leading.content = newValue }
            get { self.layout.content.leading.content }
        }
        
        public var spacing: Double {
            nonmutating set { self.layout.content.center.inset.left = newValue }
            get { self.layout.content.center.inset.left }
        }
        
        public var title: Title {
            nonmutating set { self.layout.content.center.content.content = newValue }
            get { self.layout.content.center.content.content }
        }
        
        public init(
            inset: Inset? = nil,
            icon: Icon,
            spacing: Double? = nil,
            title: Title
        ) {
            self.layout = MarginLayout(
                VAccessoryLayout(
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
        }
        
        public func apply(_ styleSheet: StyleSheet.Resolve) {
            self.layout.update(on: {
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

extension TabBarItemTemplate.IconTitle {
    
    public struct StyleSheet : StyleSheetTrait {
        
        public let inset: Inset?
        
        public let icon: Icon.StyleSheet
        
        public let spacing: Double?
        
        public let title: Title.StyleSheet
        
        public init(
            inset: Inset? = nil,
            icon: Icon.StyleSheet,
            spacing: Double? = nil,
            title: Title.StyleSheet
        ) {
            self.inset = inset
            self.icon = icon
            self.spacing = spacing
            self.title = title
        }
        
    }
    
}
