//
//  GetAllUserResponseDTO.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//
import Foundation

// MARK: - Data Transfer Object

typealias GetAllUsersResponseDTO = [UserDTO]

struct UserDTO: Decodable {
    let id: Int?
    let login: String?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url: String?
    let htmlURL: String?
    let followersURL: String?
    let followingURL: String?
    let gistsURL: String?
    let starredURL: String?
    let subscriptionsURL: String?
    let organizationsURL: String?
    let reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
    
}

extension UserDTO {
    func toDomain() -> User {
        return .init(
            id: id,
            login: login,
            nodeID: nodeID,
            avatarURL: avatarURL,
            gravatarID: gravatarID,
            url: url,
            htmlURL: htmlURL,
            followersURL: followersURL,
            followingURL: followingURL,
            gistsURL: gistsURL,
            starredURL: starredURL,
            subscriptionsURL: subscriptionsURL,
            organizationsURL: organizationsURL,
            reposURL: reposURL,
            eventsURL: eventsURL,
            receivedEventsURL: receivedEventsURL,
            type: type,
            siteAdmin: siteAdmin
        )
    }
}

extension User {
    func toDTO() -> UserDTO {
        return .init(
            id: id,
            login: login,
            nodeID: nodeID,
            avatarURL: avatarURL,
            gravatarID: gravatarID,
            url: url,
            htmlURL: htmlURL,
            followersURL: followersURL,
            followingURL: followingURL,
            gistsURL: gistsURL,
            starredURL: starredURL,
            subscriptionsURL: subscriptionsURL,
            organizationsURL: organizationsURL,
            reposURL: reposURL,
            eventsURL: eventsURL,
            receivedEventsURL: receivedEventsURL,
            type: type,
            siteAdmin: siteAdmin
        )
    }
}
