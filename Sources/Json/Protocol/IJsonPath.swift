//
//  KindKitJson
//

import Foundation
import KindKitCore

protocol IJsonPath {

    var jsonPathKey: String? { get }
    var jsonPathIndex: Int? { get }

}

extension String : IJsonPath {

    var jsonPathKey: String? { return self }
    var jsonPathIndex: Int? { return nil }

}

extension NSNumber : IJsonPath {

    var jsonPathKey: String? { return nil }
    var jsonPathIndex: Int? { return self.intValue }

}
