//
//  KindKit-Test
//

import XCTest
import KindKit

class TestApiFlow : XCTestCase {
    
    func testPipeline() {
        let expectation = self.expectation(description: "Test")
        let provider = Api.Provider()
        let pipeline = Flow.Builder< String, Never >()
            .map({ input -> Result< URL, Query.Error > in
                switch input {
                case .success(let string):
                    guard let url = URL(string: string) else {
                        return .failure(.noUrl)
                    }
                    return .success(url)
                case .failure:
                    return .failure(.invalidRequest)
                }
            })
            .apiQuery(
                provider: provider,
                queue: .main,
                request: {
                    return .init(
                        method: .get,
                        path: .absolute($0)
                    )
                },
                response: { _ in
                    Query.Response()
                }
            )
            .mapValue({ $0.0 })
            .pipeline()
        let subscription = pipeline.subscribe(
            onReceiveValue: {
                if $0.isEmpty == true {
                    XCTFail("Invalid data size \($0.count)")
                }
            },
            onReceiveError: {
                XCTFail("Invalid loading \($0)")
            },
            onCompleted: {
                expectation.fulfill()
            }
        )
        pipeline.send(value: "https://images.unsplash.com/photo-1594568284297-7c64464062b1")
        self.wait(for: [ expectation ], timeout: 60 * 2)
        subscription.cancel()
    }

}

extension TestApiFlow {
    
    enum Query {
        
        enum Error : Swift.Error {
            
            case noUrl
            case invalidRequest
            case invalidResponse
            
        }
        
        struct Response : IApiResponse {
            
            typealias Success = (Data, Date)
            typealias Failure = TestApiFlow.Query.Error
            
            func parse(meta: Api.Response.Meta, data: Data?) -> Result< Success, Failure > {
                guard let data = data else {
                    return .failure(.invalidResponse)
                }
                return .success((data, Date()))
            }
            
            func parse(error: Swift.Error) -> Result< Success, Failure > {
                return .failure(.invalidResponse)
            }
            
        }
        
    }
    
}
