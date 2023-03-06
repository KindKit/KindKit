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
    
    static var kk_totalMemorySpace: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    static var kk_usedMemorySpace: UInt64? {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout< mach_task_basic_info >.size) / 4
        let kerr = withUnsafeMutablePointer(to: &info, {
            return $0.withMemoryRebound(to: integer_t.self, capacity: 1, {
                return task_info(
                    mach_task_self_,
                    task_flavor_t(MACH_TASK_BASIC_INFO),
                    $0,
                    &count
                )
            })
        })
        guard kerr == KERN_SUCCESS else { return nil }
        return info.resident_size
    }
    
    static var kk_freeMemorySpace: UInt64? {
        guard let usedMemorySpace = self.kk_usedMemorySpace else { return nil }
        return self.kk_totalMemorySpace - usedMemorySpace
    }
    
}

#endif
