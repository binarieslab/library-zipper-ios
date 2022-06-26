//
//  GzipperError.swift
//  
//
//  Created by Marcelo Sarquis on 26.06.22.
//

import Foundation

public enum GzipperError: Error {
    case wrongOverhead
    case notGzippedData
    case deflateFailed
    case inflateFailed
}
