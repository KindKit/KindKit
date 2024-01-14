//
//  KindKit
//

import KindUI

public protocol IContainerParentable : AnyObject {
    
    var parent: IContainer? { set get }
    
}

public extension IContainerParentable where Self : IContainer {
    
#if os(macOS)
    
    var nsViewController: NSViewController? {
        return self.parent?.nsViewController
    }
    
#elseif os(iOS)
    
    var uiViewController: UIViewController? {
        return self.parent?.uiViewController
    }
    
#endif
    
    func parentInset() -> Container.AccumulateInset {
        guard let parent = self.parent else { return .zero }
        self.view.layoutIfNeeded()
        return parent.parentInset(for: self)
    }
    
    func refreshContentInset() {
        self.parent?.refreshContentInset()
    }
    
#if os(iOS)
    
    func refreshStatusBar() {
        self.parent?.refreshStatusBar()
    }
    
    func refreshOrientations() {
        self.parent?.refreshOrientations()
    }
    
#endif
    
}
