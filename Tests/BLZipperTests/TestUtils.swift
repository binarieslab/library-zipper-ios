//
//  TestUtils.swift
//  
//
//  Created by Marcelo Sarquis on 26.06.22.
//

import Foundation

public class TestUtils: NSObject {
    
    static let bundle = Bundle.module
    
    static public func contentsOfFile(name: String) -> Data {
        let pubPath  = bundle.path(forResource: name, ofType: nil)!
        return (try! Data(contentsOf: URL(fileURLWithPath: pubPath)))
    }
}
