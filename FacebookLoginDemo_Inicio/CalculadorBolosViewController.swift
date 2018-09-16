//
//  CalculadorBolosViewController.swift
//  FacebookLoginDemo_Inicio
//
//  Created by Juan Carlos Martin Sanchez on 6/7/18.
//  Copyright © 2018 EfectoApple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CarbonKit

class CalculadorBolosViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //let colorGreen = UIColor(red: 164/255, green: 188/255, blue: 83/255, alpha:1)
        
        let tabSwipe = CarbonTabSwipeNavigation(items: ["INTRODUCIR OBJETIVOS", "BOLO PRANDRIAL", "BOLO CORRECTOR "], delegate: self)
        tabSwipe.insert(intoRootViewController: self)
        tabSwipe.setIndicatorColor(UIColor.white)
        tabSwipe.setNormalColor(UIColor.white)
        tabSwipe.setSelectedColor(UIColor.white)
        tabSwipe.toolbar.barTintColor = (UIColor.black)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            return self.storyboard?.instantiateViewController(withIdentifier: "DatosBolosViewController") as! DatosBolosViewController
        case 1:
            return self.storyboard?.instantiateViewController(withIdentifier: "BoloPrandialViewController") as! BoloPrandialViewController
        default:
            return self.storyboard?.instantiateViewController(withIdentifier: "BoloCorrectorViewController") as! BoloCorrectorViewController
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
