//
//  KindKit
//

import KindDebuggerNative

public func isDebuggerPresent() -> Bool {
    return kk_is_debugger_present()
}

public func debuggerBreakpoint() {
    kk_debugger_breakpoint()
}
