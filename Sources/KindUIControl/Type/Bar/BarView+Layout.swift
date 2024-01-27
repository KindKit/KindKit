//
//  KindKit
//

import KindUI

extension BarView {
    
    public final class Layout : IComposite, ILayout {
        
        public let body: LayersLayout
        
        public let placement: BarView.Placement
        
        public var background: BackgroundType? {
            set { self.backgroundLayout.content = newValue }
            get { self.backgroundLayout.content }
        }
        
        public var contentInset: Inset {
            set { self.contentMarginLayout.inset = newValue }
            get { self.contentMarginLayout.inset }
        }
        
        public var content: ContentType? {
            set { self.contentLayout.content = newValue }
            get { self.contentLayout.content }
        }
        
        public var separator: SeparatorType? {
            set { self.separatorLayout.content = newValue }
            get { self.separatorLayout.content }
        }
        
        let backgroundLayout: ViewLayout< BackgroundType >
        let contentLayout: ViewLayout< ContentType >
        let contentMarginLayout: MarginLayout< ViewLayout< ContentType > >
        let separatorLayout: ViewLayout< SeparatorType >
        let separatorAlignmentLayout: AlignmentLayout< ViewLayout< SeparatorType > >
        
        init(placement: BarView.Placement) {
            self.placement = placement
            
            self.backgroundLayout = .init()
            
            self.contentLayout = .init()
            
            self.contentMarginLayout = .init()
                .content(self.contentLayout)
            
            self.separatorLayout = .init()
            
            self.separatorAlignmentLayout = .init()
                .vertical({
                    switch placement {
                    case .top: return .top
                    case .bottom: return .bottom
                    }
                })
                .content(self.separatorLayout)
            
            self.body = .init()
                .content([
                    self.backgroundLayout,
                    self.contentMarginLayout,
                    self.separatorAlignmentLayout
                ])
        }
        
    }
    
}

