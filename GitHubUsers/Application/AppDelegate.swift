//
//  AppDelegate.swift
//  GitHubUsers
//
//  Created by AlaaHallaq on 27/04/2022.
//

import UIKit
import CoreData
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LanguageHelper.setLanguage(to: "ar")
        LanguageHelper.setupSwizzlling()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()

 
        navigationController.view.backgroundColor = .white
        window?.rootViewController = navigationController

        UsersFlowCoordinator(navigationController: navigationController)
            .start()

        window?.makeKeyAndVisible()

        return true
    }

 
}
