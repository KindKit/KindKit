//
//  KindKit-Test
//

import XCTest
import KindStringScanner

class TestPattern : XCTestCase {
    
    func testDictionary() throws {
        enum Keys : String {
            case user
        }
        do {
            let pattern = Pattern({
                SkipToComponent("@")
                CaptureComponent(in: Keys.user, {
                    MatchComponent("@")
                    UntilComponent(.letters)
                })
            })
            do {
                let match = try pattern.match("Hello @name!")
                XCTAssert(match[string: Keys.user] == "name")
            }
            do {
                let match = try pattern.match("Hello $name!")
                XCTAssert(match[string: Keys.user] == nil)
            }
        }
        do {
            let pattern = Pattern({
                SkipToComponent("{")
                CaptureComponent(in: Keys.user, {
                    MatchComponent("{")
                    UntilComponent(.letters)
                    MatchComponent("}")
                })
            })
            do {
                let match = try pattern.match("Hello {name}!")
                XCTAssert(match[string: Keys.user] == "name")
            }
            do {
                XCTAssertThrowsError(try pattern.match("Hello {fake {name}!"))
            }
        }
        do {
            let pattern = Pattern({
                SkipToComponent("{")
                OptionalComponent(
                    CaptureComponent(in: Keys.user, {
                        MatchComponent("{")
                        UntilComponent(.letters)
                        MatchComponent("}")
                    })
                )
            })
            do {
                let match = try pattern.matches("Hello {fake {first}, {last}!")
                XCTAssert(match[0][string: Keys.user] == "first")
                XCTAssert(match[1][string: Keys.user] == "last")
            }
        }
    }
    
}
