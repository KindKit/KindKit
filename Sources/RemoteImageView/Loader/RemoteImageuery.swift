//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitApi
import KindKitView

public class RemoteImageQuery : IRemoteImageQuery {
    
    public let url: URL
    public var key: String {
        guard let sha256 = self.url.absoluteString.sha256 else {
            return self.url.lastPathComponent
        }
        return sha256
    }
    public var isLocal: Bool {
        return self.url.isFileURL
    }
    
    public init(url: URL) {
        self.url = url
    }
    
    public func localData() throws -> Data {
        return try Data(contentsOf: self.url)
    }
    
    public func download(
        provider: IApiProvider,
        download: @escaping (_ progress: Progress) -> Void,
        success: @escaping (_ data: Data, _ image: Image) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) -> ICancellable {
        return provider.send(
            request: Request(url: self.url),
            response: Response(),
            download: download,
            completed: { request, response in
                if let error = response.error {
                    failure(error)
                } else {
                    success(response.data, response.image)
                }
            }
        )
    }
    
}

private extension RemoteImageQuery {
    
    class Request : ApiRequest {
        
        init(url: URL) {
            super.init(method: "GET", path: .absolute(url))
        }
        
    }
    
}

private extension RemoteImageQuery {
    
    class Response : ApiResponse {
        
        var data: Data!
        var image: Image!
        
        override func parse() throws {
            throw ApiError.invalidResponse
        }

        override func parse(data: Data) throws {
            guard let image = Image(data: data) else {
                throw ApiError.invalidResponse
            }
            self.data = data
            self.image = image
        }
        
    }
    
}
