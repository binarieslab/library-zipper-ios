//
//  BLZipper.swift
//  
//
//  Created by Marcelo Sarquis on 26.06.22.
//

import Compression
import Foundation

/// The Compression SPM enables your app to provide lossless compression when saving or sharing files and data.
public final class BLZipper {
    
    public static let pageSize: Int = 500000
    
    /// Iterate over the source data and call the subdata(in:) method to copy pageSize chunks to subdata. The write(_:) method compresses each chunk and uses the closure specified in the OutputFilter initializer to write the result to compressedData.
    public static func compress(data: Data, algorithmsType: BLAlgorithmsType = .zlib, pageSize: Int = BLZipper.pageSize) throws -> Data {
        guard let algorithm = algorithmsType.algorithm else {
            throw BLzipperError.compressionFailed
        }
        
        var outputData = Data()
        let filter: OutputFilter
        do {
            filter = try OutputFilter(.compress, using: algorithm, bufferCapacity: pageSize, writingTo: { $0.flatMap({ outputData.append($0) }) })
        } catch {
            throw BLzipperError.compressionFailed
        }
        
        var index = 0
        let bufferSize = data.count
        
        while true {
            let rangeLength = Swift.min(pageSize, bufferSize - index)
            
            let subdata = data.subdata(in: index ..< index + rangeLength)
            index += rangeLength
            
            try filter.write(subdata)
            
            if (rangeLength == 0) {
                break
            }
        }
        
        return outputData
    }
    
    /// You iterate over the compressed data by repeatedly calling readData(ofLength:), until the function returns nil. With each iteration, append the data returned by the input filter to decompressedData.
    public static func decompress(data: Data, algorithmsType: BLAlgorithmsType = .zlib, pageSize: Int = BLZipper.pageSize) throws -> Data {
        guard let algorithm = algorithmsType.algorithm else {
            throw BLzipperError.decompressionFailed
        }
        
        var outputData = Data()
        let bufferSize = data.count
        var decompressionIndex = 0
        
        let filter = try InputFilter(.decompress, using: algorithm) { (length: Int) -> Data? in
            let rangeLength = Swift.min(length, bufferSize - decompressionIndex)
            let subdata = data.subdata(in: decompressionIndex ..< decompressionIndex + rangeLength)
            decompressionIndex += rangeLength
            return subdata
        }
        
        while let page = try filter.readData(ofLength: pageSize) {
            outputData.append(page)
        }
        
        return outputData
    }
}
