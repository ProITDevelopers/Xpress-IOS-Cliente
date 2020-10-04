//
//  SceneDelegate.swift
//  Xpress
//
//  Created by rpandrade2005 on 9/18/20.
//  Copyright © 2020 Proit-Consulting. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        irPaginaInicial()
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    
   func irPaginaInicial() {
    
    
           // MARK: Verificar se esta logado e salta para tela principal
                 // pegar e formatar a data actual
                        let date = Date()
                        let format = DateFormatter()
                        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        var formattedDate = format.string(from: date)
                        print(formattedDate)
                        
                       // buscar o tokem na memoria do telefone
                        let token = UserDefaults.standard.string(forKey: "token")
                        //data de expiracao
                        let dataexpiracao = UserDefaults.standard.string(forKey: "dataExpiracao")
                        //formatar data de expiracao
                        var dataConvertida = ""
                         var converteData = date
                        if dataexpiracao != nil {
                            let format1 = DateFormatter()
                            format1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            converteData = format1.date(from: dataexpiracao!)!
                            format1.timeZone = TimeZone.current
                            format1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dataConvertida = format1.string(from: converteData)
                         print(dataConvertida)
                        }
                 
                 
                 let token1 = UserDefaults.standard.string(forKey: "token")
                        if token1 != nil && date < converteData {

                         let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardID.pricipal) as! PrincipalViewController
                         
                         window!.rootViewController = homeViewController
                        }
                
      }

}

