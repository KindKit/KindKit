//
//  KindKit
//

import Foundation

public protocol IObserver : AnyObject {
    
    func started(_ camera: Session)
    func stopped(_ camera: Session)
    
#if os(iOS)
    
    func changed(_ camera: Session, deviceOrientation: Orientation?)
    func changed(_ camera: Session, interfaceOrientation: Orientation?)
    
#endif
    
    func startConfiguration(_ camera: Session)
    func finishConfiguration(_ camera: Session)
    
}

public extension IObserver {
    
#if os(iOS)
    
    func changed(_ camera: Session, deviceOrientation: Orientation?) {
    }
    
    func changed(_ camera: Session, interfaceOrientation: Orientation?) {
    }
    
#endif
    
}
