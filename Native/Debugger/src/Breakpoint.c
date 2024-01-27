//
//  KindKit
//

#include <KindDebugger.h>

#if __has_include(<version>)
#include <version>
#endif

#if defined(__cpp_lib_debugging)
#include <debugging>
#else
#if defined(_WIN32)
#include <intrin.h>
#include <windows.h>
#elif defined(__APPLE__)
#include <sys/sysctl.h>
#include <unistd.h>
#endif
#endif

bool kk_is_debugger_present() {
#if defined(_WIN32)
    return IsDebuggerPresent() != 0;
#elif defined(__APPLE__)
    int mib[4];
    struct kinfo_proc info;
    size_t size = sizeof(info);
    info.kp_proc.p_flag = 0;
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    if (sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, 0, 0) != 0) {
        return false;
    }
    return (info.kp_proc.p_flag & P_TRACED) != 0;
#else
    return false;
#endif
}

void kk_debugger_breakpoint() {
#    if defined(_MSC_VER)
    __debugbreak();
#    elif defined(__clang__)
    __builtin_debugtrap();
#    endif
}
