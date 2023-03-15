//
//  KindKit-Test
//

import XCTest
import KindKit

class TestRemoteImageLoader : XCTestCase {
    
    func testLoad() {
        let loader = RemoteImage.Loader(
            provider: Api.Provider(
                authenticationChallenge: .allowUntrusted,
                configuration: .default
            )
        )
        let expectation1 = self.expectation(description: "Test")
        let target1 = RemoteImage.Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation1.fulfill()
            },
            onError: { error in
                expectation1.fulfill()
            }
        )
        let expectation2 = self.expectation(description: "Test")
        let target2 = RemoteImage.Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation2.fulfill()
            },
            onError: { error in
                expectation2.fulfill()
            }
        )
        let url = URL(string: "https://images.unsplash.com/photo-1594568284297-7c64464062b1")!
        loader.cleanup(before: 0)
        loader.download(
            target: target1,
            query: RemoteImage.Query(url: url)
        )
        loader.download(
            target: target2,
            query: RemoteImage.Query(url: url)
        )
        self.wait(for: [ expectation1, expectation2 ], timeout: 60 * 2)
    }
    
    func testFilter() {
        let loader = RemoteImage.Loader(
            provider: Api.Provider(
                authenticationChallenge: .allowUntrusted,
                configuration: .default
            )
        )
        let expectation1 = self.expectation(description: "Test")
        let target1 = RemoteImage.Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation1.fulfill()
            },
            onError: { error in
                expectation1.fulfill()
            }
        )
        let expectation2 = self.expectation(description: "Test")
        let target2 = RemoteImage.Target(
            onImage: { image in
                if image.size == .zero {
                    XCTFail("Invalid image size \(image.size)")
                }
                expectation2.fulfill()
            },
            onError: { error in
                expectation2.fulfill()
            }
        )
        let url = URL(string: "https://images.unsplash.com/photo-1594568284297-7c64464062b1")!
        loader.cleanup(before: 0)
        loader.download(
            target: target1,
            query: RemoteImage.Query(url: url)
        )
        loader.download(
            target: target2,
            query: RemoteImage.Query(url: url),
            filter: RemoteImage.Filter.Group([
                RemoteImage.Filter.Thumbnail(Size(width: 512, height: 512)),
                RemoteImage.Filter.Grayscale()
            ])
        )
        self.wait(for: [ expectation1, expectation2 ], timeout: 60 * 2)
    }

}
