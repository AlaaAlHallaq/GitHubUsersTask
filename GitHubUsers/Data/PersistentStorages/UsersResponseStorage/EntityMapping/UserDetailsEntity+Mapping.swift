//
//  GetAllUsersResponseEntity+Mapping.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import CoreData
extension UserDetailsEntity {
    func toDTO() -> UserDetailsDTO {
        return .init(
            login: login,
            id: Int(id),
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
            publicRepos: Int(publicRepos),
            publicGists: Int(publicGists),
            followers: Int(followers),
            following: Int(following)//,
            //createdAt: createdAt,
            //updatedAt: updatedAt
        )
    }
}

extension UserDetailsDTO {
    func toEntity(in context: NSManagedObjectContext) -> UserDetailsEntity {
        let entity: UserDetailsEntity = .init(context: context)

        entity.login = login
        entity.id = id.map { Int64($0) } ?? 0
        entity.nodeID = nodeID
        entity.avatarURL = avatarURL
        entity.gravatarID = gravatarID
        entity.url = url
        entity.htmlURL = htmlURL
        entity.followersURL = followersURL
        entity.followingURL = followingURL
        entity.gistsURL = gistsURL
        entity.starredURL = starredURL
        entity.subscriptionsURL = subscriptionsURL
        entity.organizationsURL = organizationsURL
        entity.reposURL = reposURL
        entity.eventsURL = eventsURL
        entity.receivedEventsURL = receivedEventsURL
        entity.type = type
        entity.siteAdmin = siteAdmin ?? false
        entity.name = name
        entity.company = company
        entity.blog = blog
        entity.location = location
        entity.email = email
        entity.hireable = hireable
        entity.bio = bio
        entity.twitterUsername = twitterUsername
        entity.publicRepos = publicRepos.map { Int64($0) } ?? 0
        entity.publicGists = publicGists.map { Int64($0) } ?? 0
        entity.followers = followers.map { Int64($0) } ?? 0
        entity.following = following.map { Int64($0) } ?? 0
        //entity.createdAt = createdAt
        //entity.updatedAt = updatedAt

        return entity
    }
}
