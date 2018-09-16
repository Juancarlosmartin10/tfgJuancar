//
//  ViewController.swift
//  FacebookLoginDemo_Inicio
//
//

import UIKit
import Firebase
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailPasswordButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    

    @IBAction func continuar(_ sender: Any) {
    }
    @IBAction func loginWithFacebook(_ sender: Any) {
        
        //1.
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            //2.
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            //2.
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            //3.
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            //4.
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                
                //5.
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                //6.
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
        
    }

}




