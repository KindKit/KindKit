//
//  KindKit-Test
//

import Testing
import KindForm

struct CheckFieldTest {
    
    @Test
    func one() {
        do {
            let valueField1 = SelectField(scope: .default, id: .init("field_1"), value: 10)
            let valueField2 = SelectField(scope: .default, id: .init("field_2"), value: 20)
            let valueField3 = SelectField(scope: .default, id: .init("field_3"), value: 30)
            
            let checkField = CheckField(scope: .default, id: .init("check_1"))
                .fields([ valueField1, valueField2, valueField3 ])
                .policy(.one)
                .isMandatory(true)
            
            let form = Form()
                .root(checkField)
            
            #expect(checkField.isNotValid && valueField1.isNotValid && valueField2.isNotValid && valueField3.isNotValid)
            #expect(form.result?.record(by: checkField.id) == nil)
            #expect(form.result?.value(by: valueField1.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField2.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField3.id, as: Int.self) == nil)
            
            valueField1.isSelected = true
            
            #expect(checkField.isValid && valueField1.isValid && valueField2.isNotValid && valueField3.isNotValid)
            #expect(form.result?.record(by: checkField.id) != nil)
            #expect(form.result?.value(by: valueField1.id, as: Int.self) == 10)
            #expect(form.result?.value(by: valueField2.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField3.id, as: Int.self) == nil)
        }
        do {
            let valueField1 = SelectField(scope: .default, id: .init("field_1"), value: 10)
            let valueField2 = SelectField(scope: .default, id: .init("field_2"), value: 20)
            let valueField3 = SelectField(scope: .default, id: .init("field_3"), value: 30)
            
            let checkField = CheckField(scope: .default, id: .init("check_1"))
                .fields([ valueField1, valueField2, valueField3 ])
                .policy(.one)
                .isMandatory(true)
            
            let form = Form()
                .root(checkField)
            
            #expect(checkField.isNotValid && valueField1.isNotValid && valueField2.isNotValid && valueField3.isNotValid)
            #expect(form.result?.record(by: checkField.id) == nil)
            #expect(form.result?.value(by: valueField1.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField2.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField3.id, as: Int.self) == nil)
            
            valueField1.isSelected = true
            
            #expect(checkField.isValid && valueField1.isValid && valueField2.isNotValid && valueField3.isNotValid)
            #expect(form.result?.record(by: checkField.id) != nil)
            #expect(form.result?.value(by: valueField1.id, as: Int.self) == 10)
            #expect(form.result?.value(by: valueField2.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField3.id, as: Int.self) == nil)
            
            valueField2.isSelected = true
            
            #expect(checkField.isValid && valueField1.isNotValid && valueField2.isValid && valueField3.isNotValid)
            #expect(form.result?.record(by: checkField.id) != nil)
            #expect(form.result?.value(by: valueField1.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField2.id, as: Int.self) == 20)
            #expect(form.result?.value(by: valueField3.id, as: Int.self) == nil)
            
            checkField.selectedFields = [ valueField3 ]
            
            #expect(checkField.isValid && valueField1.isNotValid && valueField2.isNotValid && valueField3.isValid)
            #expect(form.result?.record(by: checkField.id) != nil)
            #expect(form.result?.value(by: valueField1.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField2.id, as: Int.self) == nil)
            #expect(form.result?.value(by: valueField3.id, as: Int.self) == 30)
        }
    }
    
}
