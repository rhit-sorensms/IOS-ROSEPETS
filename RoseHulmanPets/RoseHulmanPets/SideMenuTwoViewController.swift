//
//  SideMenuViewController.swift
//  MovieQuotes
//
//  Created by Maddie Sorensen on 4/21/22.
//

import UIKit

class SideMenuTwoViewController: UIViewController {
     
    var tableViewController : EditPhotoViewController {
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as!EditPhotoViewController
    }
    
   
    
    @IBAction func myPhotosButton(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: kMyPageSegue, sender: tableViewController)
    }
    @IBAction func homePageButton(_ sender: Any) {
    }
    @IBAction func profilePageButton(_ sender: Any) {
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






