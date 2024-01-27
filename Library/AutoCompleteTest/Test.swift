//
//  KindKit-Test
//

import Testing
@testable import KindAutoComplete

struct Test {
    
    @Test
    func `static`() {
        let entity = StaticController(
            items: [ "Aa", "Aa_Bb", "Aa_Bb_Cc" ]
        )
        
        #expect(entity.update("")?.estimate == nil)
        #expect(entity.update("A")?.estimate == "a")
        #expect(entity.update("Aa")?.estimate == nil)
        
        #expect(entity.update("Aa_")?.estimate == "Bb")
        #expect(entity.update("Aa_B")?.estimate == "b")
        #expect(entity.update("Aa_Bb")?.estimate == nil)
        
        #expect(entity.update("Aa_Bb_")?.estimate == "Cc")
        #expect(entity.update("Aa_Bb_C")?.estimate == "c")
        #expect(entity.update("Aa_Bb_Cc")?.estimate == nil)

    }
    
}
