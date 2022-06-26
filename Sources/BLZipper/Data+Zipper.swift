//
//  Data+Zipper.swift
//  
//
//  Created by Marcelo Sarquis on 26.06.22.
//

import Foundation

extension Data {
    /// https://mjtsai.com/blog/2019/03/27/swift-5-released/
    func withUnsafePointer<ResultType>(_ body: (UnsafePointer<UInt8>) throws -> ResultType) rethrows -> ResultType {
        return try withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) -> ResultType in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let unsafePointer = unsafeBufferPointer.baseAddress else {
                var int: UInt8 = 0
                return try body(&int)
            }
            return try body(unsafePointer)
        }
    }
}
