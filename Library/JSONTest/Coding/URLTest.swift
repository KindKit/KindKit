//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class URLTest : XCTestCase {
    
    func testDecode() throws {
        let base = URL(string: "https://user:password@site.free:443")!
        let require = URLComponentOptions([ .scheme, .user, .password, .host, .port ])
        do {
            let json = try Document(string: "{\"field\":\"https://user:password@site.free:443\"}")
            XCTAssert(try json.decode(URL.self, in: #Path("field"), with: .require(require)) == base)
        }
        do {
            let url = URL(string: "product", relativeTo: base)!.absoluteURL
            let json = try Document(string: "{\"field\":\"/product\"}")
            XCTAssert(try json.decode(URL.self, in: #Path("field"), with: .require(require).base(base)) == url)
        }
    }
    
    func testEncode() throws {
        do {
            let url = URL(string: "https://site.free")!
            let json = Document()
            XCTAssertNoThrow(try json.encode(URL.self, value: url, in: #Path("field")))
        }
        do {
            let url = URL(string: "https://site.free/product")!
            let json = Document()
            XCTAssertNoThrow(try json.encode(URL.self, value: url, in: #Path("field"), with: .removing([ .scheme, .user, .password, .host, .port ])))
            XCTAssert(try json.decode(URL.self, in: #Path("field"), with: .base(URL(string: "https://site.free")!)) == url)
        }
    }
    
}
