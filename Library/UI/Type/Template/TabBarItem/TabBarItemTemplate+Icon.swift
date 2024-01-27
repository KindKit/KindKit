//
//  KindKit
//

import KindLayout
import KindStyleSheet
import KindMonadicMacro

fileprivate enum Defaults {
    
    static let inset = Inset(horizontal: 4, vertical: 4)
    
}

extension TabBarItemTemplate {
    
    public struct Icon<
        Icon : IView & IViewSupportStyleSheet
    > : ITemplate {
        
        public typealias Layout = MarginLayout<
            ViewLayout< Icon >
        >
        
        public typealias StyleSheet = Selected< Highlighted< StyleSheet > >
        
        public let layout: Layout
        
        public var inset: Inset {
            nonmutating set { self.layout.inset = newValue }
            get { self.layout.inset }
        }
        
        public var icon: Icon {
            nonmutating set { self.layout.content.content = newValue }
            get { self.layout.content.content }
        }
        
        public init(
            inset: Inset? = nil,
            icon: Icon
        ) {
            self.layout = MarginLayout(
                ViewLayout(icon)
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
            })
        }
        
    }
    
}

extension TabBarItemTemplate.Icon {
    
    public struct StyleSheet : StyleSheetTrait {
        
        public let inset: Inset?
        
        public let icon: Icon.StyleSheet
        
        public init(
            inset: Inset? = nil,
            icon: Icon.StyleSheet
        ) {
            self.inset = inset
            self.icon = icon
        }
        
    }
    
}
