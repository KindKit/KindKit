//
//  KindKit-Test
//

import Testing
import KindCore

struct TestSemaVersion {
    
    @Test
    func fromStringZeroMajorMinor() {
        guard let version = SemaVersion("01.01") else {
            Issue.record()
            return
        }
        #expect(version.major == 1)
        #expect(version.minor == 1)
    }
    
    @Test
    func fromStringMajorMinor() {
        guard let version = SemaVersion("1.1") else {
            Issue.record()
            return
        }
        #expect(version.major == 1)
        #expect(version.minor == 1)
    }
    
    @Test
    func fromStringMajorMinorPatch() {
        guard let version = SemaVersion("1.1.1") else {
            Issue.record()
            return
        }
        #expect(version.major == 1)
        #expect(version.minor == 1)
        #expect(version.patch == 1)
    }
    
    @Test
    func comparable() {
        do {
            guard let a = SemaVersion("1.1") else {
                Issue.record()
                return
            }
            guard let b = SemaVersion("1.1.1") else {
                Issue.record()
                return
            }
            #expect(a != b)
        }
        do {
            guard let a = SemaVersion("2.61.1") else {
                Issue.record()
                return
            }
            guard let b = SemaVersion("2.61.2") else {
                Issue.record()
                return
            }
            #expect(a != b)
        }
        do {
            guard let a = SemaVersion("2.61") else {
                Issue.record()
                return
            }
            guard let b = SemaVersion("2.61.2") else {
                Issue.record()
                return
            }
            #expect(a < b)
        }
    }

}
