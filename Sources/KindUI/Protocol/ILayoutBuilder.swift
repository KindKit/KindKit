//
//  KindKit
//

public protocol ILayoutBuilder {
    
    associatedtype AssociatedLayout : ILayout
    
    var layout: AssociatedLayout { get }
    
}
