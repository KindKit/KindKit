//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class ModelTest : XCTestCase {
    
    struct Model : Equatable, ModelCoderTrait {
        
        typealias JsonDecodeOptions = EmptyCodingOptions
        typealias JsonDecoded = Model
        typealias JsonEncodeOptions = EmptyCodingOptions
        typealias JsonEncoded = Model
    
        let name: String
        let age: Int
        
        static func json(decode document: Document, with options: JsonDecodeOptions) throws -> JsonDecoded {
            return .init(
                name: try document.decode(String.self, in: #Path("name")),
                age: try document.decode(Int.self, in: #Path("age"))
            )
        }
        
        static func json(encode model: JsonEncoded, from document: Document, with options: JsonEncodeOptions) throws {
            try document.encode(String.self, value: model.name, in: #Path("name"))
            try document.encode(Int.self, value: model.age, in: #Path("age"))
        }
        
    }
    
    struct CustomModelDecoder : ModelDecoderTrait {
        
        typealias JsonDecoded = Model
        
        struct JsonDecodeOptions : CodingOptions {
            
            let age: Int
            
        }
        
        static func json(decode document: Document, with options: JsonDecodeOptions) throws -> JsonDecoded {
            return .init(
                name: try document.decode(String.self, in: #Path("name")),
                age: try document.decode(Int?.self, in: #Path("age")) ?? options.age
            )
        }
        
    }
    
    func testDecode() throws {
        let model = Model(name: "Alex", age: 20)
        do {
            let json = try Document(string: "{\"name\":\"Alex\",\"age\":20}")
            XCTAssert(try json.decode(Model.self) == model)
        }
        do {
            let json = try Document(string: "{\"model\":{\"name\":\"Alex\",\"age\":20}}")
            XCTAssert(try json.decode(Model.self, in: #Path("model")) == model)
        }
        do {
            let json = try Document(string: "{\"name\":\"Alex\"}")
            XCTAssert(try json.decode(CustomModelDecoder.self, with: .init(age: model.age)) == model)
        }
    }
    
    func testEncode() throws {
        let model = Model(name: "Alex", age: 20)
        do {
            let json = Document()
            try json.encode(Model.self, value: model)
            XCTAssert(try json.decode(Model.self) == model)
        }
        do {
            let json = Document()
            try json.encode(Model.self, value: model, in: #Path("model"))
            XCTAssert(try json.decode(Model.self, in: #Path("model")) == model)
        }
    }
    
}
