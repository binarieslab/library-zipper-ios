import XCTest
@testable import BLZipper

final class GzipperTests: XCTestCase {
    
    func testZipper() throws {
        let data = TestUtils.contentsOfFile(name: "audiosample.mp3")
        let zipped = try Gzipper.gzip(data: data)
        let unzipped = try Gzipper.gunzip(data: zipped)
        XCTAssertEqual(data, unzipped)
    }
}
