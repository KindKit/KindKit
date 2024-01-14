//
//  KindKit-Test
//

import XCTest
import KindForm

class TestBase : XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func testComboBox() {
        let items: [IField] = [
            .static(id: .init("field_1_item_1"), value: 1),
            .static(id: .init("field_1_item_2"), value: 2),
            .static(id: .init("field_1_item_2"), value: 3)
        ]
        let field = Field.Select(id: .init("field"), policy: .one)
            .mandatory(.const(true))
            .items(items)
        
        let form = field
        
        XCTAssertFalse(form.valid())
        
        field.value = [ items[0], items[1] ]
        
        XCTAssertFalse(form.valid())
        
        field.value = [ items[0] ]
        
        XCTAssertTrue(form.valid())
        
        let result = form.result
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testCheckBox() {
        let items: [IField] = [
            .static(id: .init("field_1_item_1"), value: 1),
            .static(id: .init("field_1_item_2"), value: 2),
            .static(id: .init("field_1_item_3"), value: 3)
        ]
        let field = Field.Select(id: .init("field"), policy: .any)
            .mandatory(.const(true))
            .items(items)
        
        let form = field
        
        XCTAssertFalse(form.valid())
        
        field.value = [ items[0], items[1] ]
        
        XCTAssertTrue(form.valid())
        
        field.value = [ items[0] ]
        
        XCTAssertTrue(form.valid())
        
        let result = form.result
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testAll() {
        let items1: [IField] = [
            .static(id: .init("field_1_item_1"), value: 1),
            .static(id: .init("field_1_item_2"), value: 2),
            .static(id: .init("field_1_item_3"), value: 3)
        ]
        let field1 = Field.Select(id: .init("field_1"), policy: .one)
            .mandatory(.const(true))
            .items(items1)
        
        let items2: [IField] = [
            .static(id: .init("field_2_item_1"), value: 1),
            .static(id: .init("field_2_item_2"), value: 2),
            .static(id: .init("field_2_item_3"), value: 3)
        ]
        let field2 = Field.Select(id: .init("field_2"), policy: .any)
            .mandatory(.const(true))
            .items(items2)
        
        let field3 = Field.Sequence(id: .init("field_3"), policy: .all)
            .mandatory(.const(true))
            .items([ field1, field2 ])
        
        let form = field3
        
        XCTAssertFalse(form.valid())
        
        field1.value = [ items1[0] ]
        
        XCTAssertFalse(form.valid())
        
        field2.value = [ items2[0], items2[1] ]
        
        XCTAssertTrue(form.valid())
        
        let result = form.result
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testAny() {
        let items1: [IField] = [
            .static(id: .init("field_1_item_1"), value: 1),
            .static(id: .init("field_1_item_2"), value: 2),
            .static(id: .init("field_1_item_3"), value: 3)
        ]
        let field1 = Form.Field.Select(id: .init("field_1"), policy: .one)
            .mandatory(.const(true))
            .items(items1)
        
        let items2: [IField] = [
            .static(id: .init("field_2_item_1"), value: 1),
            .static(id: .init("field_2_item_2"), value: 2),
            .static(id: .init("field_2_item_3"), value: 3)
        ]
        let field2 = Field.Select(id: .init("field_2"), policy: .any)
            .mandatory(.const(true))
            .items(items2)
        
        let field3 = Field.Sequence(id: .init("field_3"), policy: .any)
            .mandatory(.const(true))
            .items([ field1, field2 ])
        
        let form = field3
        
        XCTAssertFalse(form.valid())
        
        field1.value = [ items1[0] ]
        
        XCTAssertTrue(form.valid())
        
        field2.value = [ items2[0], items2[1] ]
        
        XCTAssertTrue(form.valid())
        
        let result = form.result
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testDouble() {
        let field = Field.Dynamic(id: .init("double"), value: 0)
            .mandatory(.const(true))
            .validator({
                return $0 > 1 && $0 < 5
            })
        
        let form = field
        
        XCTAssertFalse(form.valid())
        
        field.value = 3
        
        XCTAssertTrue(form.valid())
        
        let result = form.result
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testString() {
        let field = Field.Dynamic(id: .init("string"), value: "")
            .mandatory(.const(true))
            .validator({
                guard $0.isEmpty == false else {
                    return false
                }
                return $0.count < 5
            })
        
        let form = field
        
        XCTAssertFalse(form.valid())
        
        field.value = "123"
        
        XCTAssertTrue(form.valid())
        
        let result = form.result
        
        XCTAssertFalse(result.isEmpty)
    }
    
}
