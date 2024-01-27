//
//  KindKit-Test
//

import Testing
import KindForm

struct ListFieldTest {
    
    @Test
    func any() {
        let valueField1 = InputField(scope: .default, id: .init("field_1"), value: 10, lower: 0, upper: 100)
            .isMandatory(true)
        
        let valueField2 = InputField(scope: .default, id: .init("field_2"), value: 20, lower: 0, upper: 100)
            .isMandatory(true)
        
        let listField = ListField(scope: .default, id: .init("list_1"))
            .fields([ valueField1, valueField2 ])
            .policy(.any)
            .isMandatory(true)
        
        let form = Form()
            .root(listField)
        
        #expect(form.isValid && valueField1.isValid && valueField2.isValid)
        #expect(form.result?.record(by: listField.id) != nil)
        #expect(form.result?.value(by: valueField1.id, as: Int.self) == 10)
        #expect(form.result?.value(by: valueField2.id, as: Int.self) == 20)
        
        valueField1.value = 110
        
        #expect(form.isValid && valueField1.isNotValid && valueField2.isValid)
        #expect(form.result?.record(by: listField.id) != nil)
        #expect(form.result?.value(by: valueField2.id, as: Int.self) == 20)
    }
    
    @Test
    func all() {
        let valueField1 = InputField(scope: .default, id: .init("field_1"), value: 10, lower: 0, upper: 100)
            .isMandatory(true)
        
        let valueField2 = InputField(scope: .default, id: .init("field_2"), value: 20, lower: 0, upper: 100)
            .isMandatory(true)
        
        let listField = ListField(scope: .default, id: .init("list_1"))
            .fields([ valueField1, valueField2 ])
            .isMandatory(true)
        
        let form = Form()
            .root(listField)
        
        #expect(form.isValid && valueField1.isValid && valueField2.isValid)
        #expect(form.result?.record(by: listField.id) != nil)
        #expect(form.result?.value(by: valueField1.id, as: Int.self) == 10)
        #expect(form.result?.value(by: valueField2.id, as: Int.self) == 20)
        
        valueField1.value = 110
        
        #expect(form.isNotValid && valueField1.isNotValid && valueField2.isValid)
        #expect(form.result?.record(by: listField.id) == nil)
        #expect(form.result?.value(by: valueField1.id, as: Int.self) == nil)
        #expect(form.result?.value(by: valueField2.id, as: Int.self) == nil)
    }
    
}
