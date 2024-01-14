//
//  KindKit
//

import Foundation

public protocol ITaskQuery : IQuery {

    var task: URLSessionTask { get }
    
    func upload(bytes: Int64, totalBytes: Int64)
    func resumeDownload(bytes: Int64, totalBytes: Int64)
    func download(bytes: Int64, totalBytes: Int64)
    func receive(response: URLResponse)
    func become(task: URLSessionTask)
    func receive(data: Data)
    func download(url: URL)
    func finish(error: Swift.Error?)

}
