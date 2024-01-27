//
//  KindKit
//

import KindLayout
import KindStyleSheet
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let inset = Inset(horizontal: 4, vertical: 4)
    
}

extension ButtonTemplate {
    
    public struct Title<
        Background : IView & IViewSupportStyleSheet,
        Title : IView & IViewSupportStyleSheet
    > : ITemplate {
        
        public typealias Layout = SubstrateLayout<
            ViewLayout< Background >,
            MarginLayout<
                ViewLayout< Title >
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
        
        public var title: Title {
            nonmutating set { self.layout.content.content.content = newValue }
            get { self.layout.content.content.content }
        }
        
        public init(
            background: Background,
            inset: Inset? = nil,
            title: Title
        ) {
            self.layout = SubstrateLayout(
                substrate: ViewLayout(background),
                content: MarginLayout(
                    ViewLayout(title)
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
                self.title.apply(styleSheet.title)
            })
        }
        
    }
    
}

extension ButtonTemplate.Title {
    
    public struct StyleSheet : StyleSheetTrait {
        
        public let background: Background.StyleSheet
        
        public let inset: Inset?
        
        public let title: Title.StyleSheet
        
        public init(
            background: Background.StyleSheet,
            inset: Inset? = nil,
            title: Title.StyleSheet
        ) {
            self.background = background
            self.inset = inset
            self.title = title
        }
        
    }
    
}
