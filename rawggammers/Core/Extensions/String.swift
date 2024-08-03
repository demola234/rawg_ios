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
    
        var capitalizedFirstLetterOfEachWord: String {
            return self.lowercased().split(separator: " ").map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined(separator: " ")
        }
}
