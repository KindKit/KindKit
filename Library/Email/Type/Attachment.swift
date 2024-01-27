//
//  KindKit
//

import Foundation

public struct Attachment {
    
    public let data: Data
    public let mimeType: String
    public let filename: String
    
    public init(
        data: Data,
        mimeType: String,
        filename: String
    ) {
        self.data = data
        self.mimeType = mimeType
        self.filename = filename
    }
    
}
