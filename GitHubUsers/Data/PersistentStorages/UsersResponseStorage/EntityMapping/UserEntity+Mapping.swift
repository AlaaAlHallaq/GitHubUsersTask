//
//  UserEntity+Mapping.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 28/04/2022.
//

import Foundation
import CoreData
extension UserEntity {
    func toDTO() -> UserDTO {
        return .init(
            id: Int(id),
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

extension UserDTO {
    func toEntity(in context: NSManagedObjectContext) -> UserEntity {
        let entity: UserEntity = .init(context: context)

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

        return entity
    }
}
