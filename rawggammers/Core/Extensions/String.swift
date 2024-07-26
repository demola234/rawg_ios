//
//  String.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import Foundation
import SwiftUI

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
