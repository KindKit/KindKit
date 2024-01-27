//
//  KindKit-Test
//

import Testing
import KindForm

struct InputFieldTest {
    
    @Test
    func rangeValidator() {
        let field = InputField(scope: .default, id: .init("field"), value: 0, lower: 0, upper: 100)
            .isMandatory(true)
        
        let form = Form()
            .root(field)
        
        #expect(field.isValid)
        #expect(form.isValid)
        #expect(form.result?.value(by: field.id, as: Int.self) == 0)
        
        field.value = 5
        
        #expect(field.isValid)
        #expect(form.isValid)
        #expect(form.result?.value(by: field.id, as: Int.self) == 5)
        
        field.value = -1
        
        #expect(field.isNotValid)
        #expect(form.isNotValid)
        #expect(form.result?.value(by: field.id, as: Int.self) == nil)
        #expect(field.error == .lessThan(limit: 0))
        
        field.value = 101
        
        #expect(field.isNotValid)
        #expect(form.isNotValid)
        #expect(form.result?.value(by: field.id, as: Int.self) == nil)
        #expect(field.error == .moreThan(limit: 100))
    }
    
}
