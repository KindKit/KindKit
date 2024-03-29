//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public protocol IUIContainerParentable : AnyObject {
    
    var parent: IUIContainer? { set get }
    
}

public extension IUIContainerParentable where Self : IUIContainer {
    
#if os(macOS)
    
    var nsViewController: NSViewController? {
        return self.parent?.nsViewController
    }
    
#elseif os(iOS)
    
    var uiViewController: UIViewController? {
        return self.parent?.uiViewController
    }
    
#endif
    
    func parentInset() -> UI.Container.AccumulateInset {
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
