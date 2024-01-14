//
//  KindKit
//

public protocol IAccessoryView : IAnyView {
    
    var parentView: IView? { get }
    
    func appear(to view: IView)
    
}
