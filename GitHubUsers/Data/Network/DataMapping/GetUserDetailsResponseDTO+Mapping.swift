//
//  GetUserDetailsResponseDTO.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation

// MARK: - Data Transfer Object

typealias GetUserDetailsResponseDTO = UserDetailsDTO

struct UserDetailsDTO: Decodable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?
    let name, company, blog, location: String?
    let email: String?
    let hireable: String?
    let bio: String?
    let twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int?
    //let createdAt, updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case login
        case id
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
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        //case createdAt = "created_at"
        //case updatedAt = "updated_at"
    }
}

extension UserDetailsDTO {
    func toDomain() -> UserDetails {
        return .init(
            login: login,
            id: id,
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
            siteAdmin: siteAdmin,
            name: name,
            company: company,
            blog: blog,
            location: location,
            email: email,
            hireable: hireable,
            bio: bio,
            twitterUsername: twitterUsername,
            publicRepos: publicRepos,
            publicGists: publicGists,
            followers: followers,
            following: following//,
            //createdAt: createdAt,
            //updatedAt: updatedAt
        )
    }
}

extension UserDetails {
    func toDTO() -> UserDetailsDTO {
        return .init(
            login: login,
            id: id,
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
            siteAdmin: siteAdmin,
            name: name,
            company: company,
            blog: blog,
            location: location,
            email: email,
            hireable: hireable,
            bio: bio,
            twitterUsername: twitterUsername,
            publicRepos: publicRepos,
            publicGists: publicGists,
            followers: followers,
            following: following//,
            //createdAt: createdAt,
            //updatedAt: updatedAt
        )
    }
}
