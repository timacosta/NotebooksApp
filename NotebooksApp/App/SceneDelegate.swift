//
//  SceneDelegate.swift
//  NotebooksApp
//
//  Created by Tim Acosta on 26/1/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var dataController: DataController!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        //integrar coredate al principio de nuestra app
        //crear un data controller que vamos a pasar a nuestro view controller
        
        dataController = DataController(modelName: "NotebooksModel", optionalStoreName: nil, completionHandler: { [weak self] (persistentContainer) in
            
            //aqui va estar nuestro core data stack inicializado
            guard persistentContainer != nil else {
                fatalError("the core data stack was not created")
            }
            
            self?.preloadData()
            
        })
        
        //instanciar nuestro vc pasandole el dataController / setear el rootViewController del window
        
        guard let tableNotebookViewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NotebookTableViewController") as? NotebookTableViewController else {
            fatalError("NotebookTableViewController could not be created")
        }
        
        
        tableNotebookViewcontroller.dataController = dataController
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = UINavigationController(rootViewController: tableNotebookViewcontroller)
        self.window?.makeKeyAndVisible()
        
    }
    
    func preloadData() {
        
        guard !UserDefaults.standard.bool(forKey: "hasPreloadData") else {return}
        UserDefaults.standard.set(true, forKey: "hasPreloadData")
        
        dataController.performInBackground { (managedObjectContext) in
            DataController.preloadData(managedObjectContext: managedObjectContext)
        }
        
        //dataController?.loadNotesIntoViewContext()

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        dataController.save()
        
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


}

