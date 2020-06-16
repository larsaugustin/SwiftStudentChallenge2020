//  SceneDelegate.swift

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let tabBarController = UITabBarController()

            let page0 = Page0ViewController(style: .insetGrouped)
            page0.title = "Hearing Test"
            page0.tabBarItem.image = UIImage(systemName: "ear")

            let page1 = Page1ViewController()
            page1.title = "Clear Voice"
            page1.tabBarItem.image = UIImage(systemName: "waveform")

            let page2 = Page2ViewController(style: .insetGrouped)
            page2.title = "Recognition"
            page2.tabBarItem.image = UIImage(systemName: "tag")

            tabBarController.viewControllers = [UINavigationController(rootViewController: page0),
                                                UINavigationController(rootViewController: page1),
                                                UINavigationController(rootViewController: page2)]
            tabBarController.tabBar.tintColor = .systemPink

            window.rootViewController = tabBarController
            self.window = window
            window.makeKeyAndVisible()
            UINavigationBar.appearance().tintColor = .systemPink
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

