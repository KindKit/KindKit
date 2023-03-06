//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Web {
    
    enum Request : Equatable {
        
        case request(_ request: URLRequest)
        case file(url: URL, readAccess: URL)
        case html(string: String, baseUrl: URL?)
        case data(data: Data, mimeType: String, encoding: String, baseUrl: URL)
            
    }
    
}

#endif
