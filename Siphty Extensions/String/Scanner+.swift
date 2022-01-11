//
//  Scanner+.swift
//  EmailParser
//
//  Created by ERNESTO on 25/09/2016.
//  Copyright © 2016 Hai Nguyen. All rights reserved.
//

import Foundation

extension Scanner {
  
  func scanUpToCharactersFrom(_ set: CharacterSet) -> String? {
    var result: NSString?                                                           // 1.
    return scanUpToCharacters(from: set, into: &result) ? (result as String?) : nil // 2.
  }
  
  func scanUpTo(_ string: String) -> String? {
    var result: NSString?
    return self.scanUpTo(string, into: &result) ? (result as String?) : nil
  }
  
  func scanDouble() -> Double? {
    var double: Double = 0
    return scanDouble(&double) ? double : nil
  }
}
