//
//  StringExtensions.swift
//  VclReactNative
//
//  Created by Michael Avoyan on 13/07/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation

extension String {
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
            }
        }
        return nil
    }
}
