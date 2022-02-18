//
//  KindKitCore
//

import Foundation

public extension Bundle {
    
    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    var isTestFlight: Bool {
        return self.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }
    
    var shortVersion: String? {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var version: String? {
        return self.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    var semaVersion: SemaVersion? {
        guard let shortVersion = self.shortVersion else { return nil }
        guard let version = self.version else { return nil }
        return SemaVersion("\(shortVersion)+\(version)")
    }

    func containsUrlSheme(url: URL) -> Bool {
        var shemes: [String] = []
        guard let scheme = url.scheme else { return false }
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [Any] else { return false }
        urlTypes.forEach({
            guard let dictionary = $0 as? [String : Any], let urlSchemes = dictionary["CFBundleURLSchemes"] as? [String] else { return }
            shemes.append(contentsOf: urlSchemes)
        })
        return shemes.contains(scheme)
    }
    
}
