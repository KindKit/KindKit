//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IScreenAnalyticsable {
    
    associatedtype AssociatedAnalytics
    
    var analytics: AssociatedAnalytics { get }
    
}
