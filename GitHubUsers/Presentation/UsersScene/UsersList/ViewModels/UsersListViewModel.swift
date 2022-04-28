//
//  UsersListViewModel.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

struct UserListItemViewModel: Equatable {
    let user: User
    var userName: String { user.login ?? "" }
    var avatar: String { user.avatarURL ?? "" }
    var id: Int { user.id ?? 0 }
}
