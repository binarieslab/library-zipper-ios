import XCTest
@testable import BLZipper

final class GzipperTests: XCTestCase {
    
    func testCompressionDecompression_whenCompressionTypeLzma_shouldReturnOriginalData() throws {
        // Given
        let originalData = TestUtils.contentsOfFile(name: "audiosample.mp3")
        let startedAt = Date()
        
        // When
        let zippedData = try BLZipper.compress(data: originalData, algorithmsType: .lzma)
        let unzippedData = try BLZipper.decompress(data: zippedData, algorithmsType: .lzma)
        print("duration: \(Date().timeIntervalSince1970 - startedAt.timeIntervalSince1970) @ lzma: \(100*(1-(Double(zippedData.count)/Double(unzippedData.count))))")
        
        // Expected
        XCTAssertEqual(originalData, unzippedData)
    }
    
    func testCompressionDecompression_whenCompressionTypeLz4_shouldReturnOriginalData() throws {
        // Given
        let originalData = TestUtils.contentsOfFile(name: "audiosample.mp3")
        let startedAt = Date()
        
        // When
        let zippedData = try BLZipper.compress(data: originalData, algorithmsType: .lz4)
        let unzippedData = try BLZipper.decompress(data: zippedData, algorithmsType: .lz4)
        print("duration: \(Date().timeIntervalSince1970 - startedAt.timeIntervalSince1970) @ lz4: \(100*(1-(Double(zippedData.count)/Double(unzippedData.count))))")
        
        // Expected
        XCTAssertEqual(originalData, unzippedData)
    }
    
    func testCompressionDecompression_whenCompressionTypeZlib_shouldReturnOriginalData() throws {
        // Given
        let originalData = TestUtils.contentsOfFile(name: "audiosample.mp3")
        let startedAt = Date()
        
        // When
        let zippedData = try BLZipper.compress(data: originalData, algorithmsType: .zlib)
        let unzippedData = try BLZipper.decompress(data: zippedData, algorithmsType: .zlib)
        print("duration: \(Date().timeIntervalSince1970 - startedAt.timeIntervalSince1970) @ zlib: \(100*(1-(Double(zippedData.count)/Double(unzippedData.count))))")
        
        // Expected
        XCTAssertEqual(originalData, unzippedData)
    }
    
    func testCompressionDecompression_whenCompressionTypeLzfse_shouldReturnOriginalData() throws {
        // Given
        let originalData = TestUtils.contentsOfFile(name: "audiosample.mp3")
        let startedAt = Date()
        
        // When
        let zippedData = try BLZipper.compress(data: originalData, algorithmsType: .lzfse)
        let unzippedData = try BLZipper.decompress(data: zippedData, algorithmsType: .lzfse)
        print("duration: \(Date().timeIntervalSince1970 - startedAt.timeIntervalSince1970) @ lzfse: \(100*(1-(Double(zippedData.count)/Double(unzippedData.count))))")
        
        // Expected
        XCTAssertEqual(originalData, unzippedData)
    }
    
    func test() {
        XCTAssertEqual(1, 2)
    }
}
