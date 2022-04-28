//
//  LocalizedText.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
enum LocalizedText: String {
    case otherLangAbbr
    case githubUsers
}
extension LocalizedText {
    var value: String {
        NSLocalizedString(
            rawValue,
            comment: ""
        )
    }
}
