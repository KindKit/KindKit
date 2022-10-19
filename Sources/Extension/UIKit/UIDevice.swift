//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIDevice {
    
    static let kk_isSimulator: Bool = {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }()
    
    static let kk_identifier: String = {
        if let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return identifier
        }
        var info = utsname()
        uname(&info)
        let data = Data(bytes: &info.machine, count: Int(_SYS_NAMELEN))
        guard let machine = String(bytes: data, encoding: .ascii) else {
            return ""
        }
        return machine.trimmingCharacters(in: .controlCharacters)
    }()
    
}

#endif
