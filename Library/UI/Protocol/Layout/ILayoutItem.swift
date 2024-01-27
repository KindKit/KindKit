//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindEvent
import KindLayout

public protocol ILayoutItem : IItem {
    
    var isLoaded: Bool { get }

    var handle: NativeView { get }
    
    var onAppear: Signal< Void, Bool > { get }
    
    var onDisappear: Signal< Void, Void > { get }
    
}
