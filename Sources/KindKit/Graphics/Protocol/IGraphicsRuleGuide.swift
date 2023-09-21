//
//  KindKit
//

import Foundation

public protocol IGraphicsRuleGuide : IGraphicsGuide {
    
    func guide(_ value: Distance) -> Distance?

}
