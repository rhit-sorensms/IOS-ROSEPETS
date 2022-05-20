//
//  SideMenuViewController.swift
//  MovieQuotes
//
//  Created by Maddie Sorensen on 4/21/22.
//

import UIKit

class SideMenuViewController: UIViewController {
     
    var tableViewController : HomePageController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as!HomePageController
    }
    
    @IBAction func myPhotosButton(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: kMyPageSegue, sender: tableViewController)
    }
    
    @IBOutlet weak var myPhotosButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func editProfileButton(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: keditProfileSegue, sender: tableViewController)
    }
    @IBAction func signOut(_ sender: Any) {
        dismiss(animated: true) {
            AuthManager.shared.signOut()
        }
    }
    
   
    
    

     /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


