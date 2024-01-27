//
//  KindKit
//

import KindUI

extension CellView {
    
    final class Layout : IComposite, ILayout {
        
        let body: LayersLayout
        
        var background: BackgroundType? {
            set { self.backgroundLayout.content = newValue }
            get { self.backgroundLayout.content }
        }
        
        var contentInset: Inset {
            set { self.contentMarginLayout.inset = newValue }
            get { self.contentMarginLayout.inset }
        }
        
        var content: ContentType? {
            set { self.contentLayout.content = newValue }
            get { self.contentLayout.content }
        }
        
        let backgroundLayout: ViewLayout< BackgroundType >
        let contentLayout: ViewLayout< ContentType >
        let contentMarginLayout: MarginLayout< ViewLayout< ContentType > >

        init() {
            self.backgroundLayout = .init()
            
            self.contentLayout = .init()
            
            self.contentMarginLayout = .init()
                .content(self.contentLayout)
            
            self.body = .init()
                .content([
                    self.backgroundLayout,
                    self.contentMarginLayout
                ])
            
        }
        
    }
    
}
