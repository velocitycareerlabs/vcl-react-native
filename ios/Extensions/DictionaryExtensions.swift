//
//  DictionaryExtensions.swift
//  vcl-react-native
//
//  Created by Michael Avoyan on 20/12/2022.
//

import Foundation

extension Dictionary {
  func toJsonString() -> String? {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
      return String(data: jsonData, encoding: .utf8)
    } catch {
      return nil
    }
  }
}
