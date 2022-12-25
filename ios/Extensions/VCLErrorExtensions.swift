//
//  VCLErrorExtensions.swift
//  vcl-react-native
//
//  Created by Michael Avoyan on 20/12/2022.
//

import Foundation
import VCL

extension VCLError {
    func toJsonDictionary() -> [String: String] {
        var msg = [String: String]()
        msg["description"] = self.description
        msg["code"] = "\(self.code ?? 0)"
        return msg
    }
    func toJsonString() -> String {
        return self.toJsonDictionary().toJsonString() ?? ""
    }
}
