//
//  KindKit
//

import Foundation

public struct BundleFinder : Finder {
    
    public let bundle: Bundle
    
    public let table: Table
    
    private let _default = UUID().uuidString
    
    public init(
        bundle: Bundle,
        table: Table = .default,
        language: Language = .system
    ) {
        switch language {
        case .system:
            self.bundle = bundle
        case .custom(let language):
            if let languageBundle = bundle.kk_bundle(language: language) {
                self.bundle = languageBundle
            } else {
                self.bundle = bundle
            }
        }
        self.table = table
    }
    
    public func callAsFunction(key: String) -> String? {
        let string = bundle.localizedString(
            forKey: key,
            value: self._default,
            table: self.table.name
        )
        if string != self._default {
            return string
        }
        return nil
    }
    
}
