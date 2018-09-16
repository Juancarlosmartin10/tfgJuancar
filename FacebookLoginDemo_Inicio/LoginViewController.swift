//
//  LoginViewController.swift
//  FacebookLoginDemo_Inicio
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var login_register: UISegmentedControl!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
        email.delegate = self
  
        loginButton.layer.cornerRadius = 20
        
        //Notificaciones para los eventos del teclado.
        
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        password.resignFirstResponder()
        email.resignFirstResponder()
        
        if login_register.selectedSegmentIndex == 0 {
            loginFunction(email: email.text!, password: password.text!)
        }else{
            registerFunction(email: email.text!, password: password.text!)
        }
    }
    
    func loginFunction(email: String, password:String){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error)in
            if user != nil {
                self.performSegue(withIdentifier: "login", sender: self)
            }else{
                if let error = error?.localizedDescription{
                    print("error Firebase", error)
                }
            }
        })
    }
    
    func registerFunction(email: String, password:String){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
            
            if user != nil {
                self.performSegue(withIdentifier: "login", sender: self)
            }else{
                if let error = error?.localizedDescription{
                    print("error Firebase", error)
                }
            }
            
        })
        
    }
    
    func login (){
        FIRAuth.auth()?.addStateDidChangeListener {(auth, user) in
        
            if user == nil{
                self.showAlert(title: "Atención", message: "No estas loggeado")
            }else{
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
            
    }
    
    func showAlert(title: String, message: String) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let Ok = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            
        }
        
        alertaGuia.addAction(Ok)
        
        present(alertaGuia, animated: true, completion: nil)
    }
    
    @objc func teclado(notificacion: Notification){
        guard let tecladoUp = (notificacion.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else{
                return
        }
        if notificacion.name == Notification.Name.UIKeyboardWillShow {
            self.view.frame.origin.y = -tecladoUp.height
        }else{
            self.view.frame.origin.y = 0
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
