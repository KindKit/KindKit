//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class CodableCompatibleTest : XCTestCase {
    
    struct Model : Codable, Equatable {
    
        var name: String
        var age: Int
        
    }
    
    func testDecode() throws {
        let model = Model(name: "Alex", age: 20)
        do {
            let json = try Document(string: "{\"name\":\"Alex\",\"age\":20}")
            XCTAssert(try json.decode(CodableCompatible< Model >.self) == model)
        }
        do {
            let json = try Document(string: "{\"model\":{\"name\":\"Alex\",\"age\":20}}")
            XCTAssert(try json.decode(CodableCompatible< Model >.self, in: #Path("model")) == model)
        }
    }
    
    func testEncode() throws {
        let model = Model(name: "Alex", age: 20)
        do {
            let json = Document()
            try json.encode(CodableCompatible< Model >.self, value: model)
            XCTAssert(try json.decode(CodableCompatible< Model >.self) == model)
        }
        do {
            let json = Document()
            try json.encode(CodableCompatible< Model >.self, value: model, in: #Path("model"))
            XCTAssert(try json.decode(CodableCompatible< Model >.self, in: #Path("model")) == model)
        }
    }
    
}
