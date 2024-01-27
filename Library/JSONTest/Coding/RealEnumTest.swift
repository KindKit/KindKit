//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class RealEnumTest : XCTestCase {
    
    enum Enum {
        
        case case1
        case case2
        case case3
        
        enum NumberRepresentable : Int, ValueCoderTrait, RealEnumCodableTrait {
            
            case case_1 = 0
            case case_2 = 1
            case case_3 = 2
            
            var realValue: Enum {
                switch self {
                case .case_1: return .case1
                case .case_2: return .case2
                case .case_3: return .case3
                }
            }
            
            init(realValue: Enum) {
                switch realValue {
                case .case1: self = .case_1
                case .case2: self = .case_2
                case .case3: self = .case_3
                }
            }
            
        }
        
        enum StringRepresentable : String, ValueCoderTrait, RealEnumCodableTrait {
            
            case case_1 = "case_1"
            case case_2 = "case_2"
            case case_3 = "case_3"
            
            var realValue: Enum {
                switch self {
                case .case_1: return .case1
                case .case_2: return .case2
                case .case_3: return .case3
                }
            }
            
            init(realValue: Enum) {
                switch realValue {
                case .case1: self = .case_1
                case .case2: self = .case_2
                case .case3: self = .case_3
                }
            }
            
        }
        
    }
    
    func testNumber() throws {
        do {
            let json = try Document(string: "{\"field\":\"1\"}")
            XCTAssert(try json.decode(Enum.NumberRepresentable.self, in: #Path("field")) == .case2)
        }
        do {
            let json = Document()
            try json.encode(Enum.NumberRepresentable.self, value: .case2, in: #Path("field"))
            XCTAssert(try json.decode(Enum.NumberRepresentable.self, in: #Path("field")) == .case2)
        }
    }
    
    func testString() throws {
        do {
            let json = try Document(string: "{\"field\":\"case_2\"}")
            XCTAssert(try json.decode(Enum.StringRepresentable.self, in: #Path("field")) == .case2)
        }
        do {
            let json = Document()
            try json.encode(Enum.StringRepresentable.self, value: .case2, in: #Path("field"))
            XCTAssert(try json.decode(Enum.StringRepresentable.self, in: #Path("field")) == .case2)
        }
    }
    
}
