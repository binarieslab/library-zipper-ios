//
//  BLAlgorithmsType.swift
//  
//
//  Created by Marcelo Sarquis on 09.07.22.
//

import Compression
import Foundation

/// An enum for values that represent compression algorithms.
public enum BLAlgorithmsType {
    
    /// If speed and compression ratio are important, use type `lzfse´
    case lzfse
    
    /// If speed is critical, and you’re willing to sacrifice compression ratio to achieve it, use type `lz4`.
    case lz4
    
    /// If you require interoperability with non-Apple devices, use type `zlib`.
    case zlib
    
    /// If compression ratio is critical, and you’re willing to sacrifice speed to achieve it, use type `lzma`. Note that type `lzma` is an order of magnitude slower for both compression and decompression than other choices.
    case lzma
    
    /// Algorithms used for compression or decompression.
    var algorithm: Algorithm? {
        switch self {
        case .lzfse:
            return Algorithm(rawValue: COMPRESSION_LZFSE)
        case .lz4:
            return Algorithm(rawValue: COMPRESSION_LZ4)
        case .zlib:
            return Algorithm(rawValue: COMPRESSION_ZLIB)
        case .lzma:
            return Algorithm(rawValue: COMPRESSION_LZMA)
        }
    }
}
