//
//  Gzipper.swift
//  
//
//  Created by Marcelo Sarquis on 26.06.22.
//

import Compression
import Foundation
import zlib

public final class Gzipper {
    public static func gzip(data: Data) throws -> Data {
        var sourceBuffer = Array(data)
        
        // Sometimes gzipped data is bigger then the original
        // ex. "test" string will be deflated in 6 bytes
        let destinationBuffer = UnsafeMutablePointer<UInt32>.allocate(capacity: sourceBuffer.count * 10)
        let compressedSize = compression_encode_buffer(
            destinationBuffer,
            sourceBuffer.count * 10,
            &sourceBuffer,
            sourceBuffer.count,
            nil,
            COMPRESSION_ZLIB
        )
        
        guard compressedSize != 0 else {
            throw GzipperError.deflateFailed
        }
        
        // Create header
        var result = Data([0x1F, 0x8B, 0x08, 0x00]) // magic, magic, deflate, noflags
        
        result.append(contentsOf: [0x00, 0x00, 0x00, 0x00, 0x00, 0x13]) // normal compression level, unix file type
        
        // Append deflated data
        result.append(Data(bytes: destinationBuffer, count: compressedSize))
        // Append CRC32 checksum
        data.withUnsafePointer { (bytes: UnsafePointer<Bytef>) in
            var crc = crc32(0, nil, 0)
            crc = crc32(crc, bytes, uInt(data.count)).littleEndian
            result.append(Data(bytes: &crc, count: MemoryLayout<UInt32>.size))
        }
        
        // Append original size
        var isize: UInt32 = UInt32(truncatingIfNeeded: data.count).littleEndian
        result.append(Data(bytes: &isize, count: MemoryLayout<UInt32>.size))
        
        return result
    }
    
    public static func gunzip(data: Data) throws -> Data {
        // Check minimum size 18 (Header(10) + Data + Footer(8))
        let overhead = 10 + 8
        guard data.count >= overhead else {
            throw GzipperError.wrongOverhead
        }
        
        // Check magic numbers in header
        guard data.starts(with: [0x1F, 0x8B, 0x08]) else {
            throw GzipperError.notGzippedData
        }
        
        // Get CRC32 checksum and the original size
        let (crc32FromFooter, originalSize) = data.withUnsafePointer { (bptr: UnsafePointer<UInt8>) -> (UInt32, UInt32) in
            bptr.advanced(by: data.count - 8).withMemoryRebound(to: UInt32.self, capacity: 2) { ptr in
                (ptr[0].littleEndian, ptr[1].littleEndian)
            }
        }
        
        let deflatedData = data.subdata(in: 10 ..< data.count - 8)
        
        let destinationBuffer = UnsafeMutablePointer<UInt32>.allocate(capacity: Int(originalSize))
        
        let inflatedSize: Int = deflatedData.withUnsafePointer { encodedSourceBuffer -> Int in
            compression_decode_buffer(
                destinationBuffer,
                Int(originalSize),
                encodedSourceBuffer,
                deflatedData.count,
                nil,
                COMPRESSION_ZLIB
            )
        }
        
        guard inflatedSize != 0 else {
            throw GzipperError.inflateFailed
        }
        
        let inflatedData = Data(bytes: destinationBuffer, count: Int(originalSize))
        
        // Calculate CRC32 checksum from inflated data
        let inflatedCRC = inflatedData.withUnsafePointer { (bytes: UnsafePointer<Bytef>) -> UInt32 in
            var crc = crc32(0, nil, 0)
            crc = crc32(crc, bytes, uInt(inflatedData.count))
            return UInt32(crc)
        }
        
        // Check inflated size equals to the original size and CRC32 checksum
        guard
            originalSize == UInt32(truncatingIfNeeded: inflatedData.count),
            crc32FromFooter == inflatedCRC
        else {
            throw GzipperError.inflateFailed
        }
        
        return inflatedData
    }
}
