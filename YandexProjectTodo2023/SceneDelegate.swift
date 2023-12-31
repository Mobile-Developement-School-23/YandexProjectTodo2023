import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
//        let vc = FirstScreenViewController()
//        vc.title = "Мои дела"
//        let nav = UINavigationController(rootViewController: vc)
//        nav.navigationBar.prefersLargeTitles = true
//
//        window = UIWindow(windowScene: scene)
//        window?.rootViewController = nav
//        window?.makeKeyAndVisible()
        
        // MARK: Homework 8
        
        let vc = FirstScreenSwiftUI()
        let host = UIHostingController(rootView: vc)

        window = UIWindow(windowScene: scene)
        window?.rootViewController = host
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
