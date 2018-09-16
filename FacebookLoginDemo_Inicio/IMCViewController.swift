//
//  IMCViewController.swift
//  FacebookLoginDemo_Inicio
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class IMCViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var heigth: UITextField!
    @IBOutlet weak var weigth: UITextField!
    
    @IBOutlet weak var saveType: UIButton!
    
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var salir1Button: UIButton!
    
    @IBOutlet weak var peso2: UITextField!
    
    
    var reference: FIRDatabaseReference!
    var idFirebase = ""
    var ImcReference: FIRDatabaseQuery!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peso2.delegate = self
        heigth.delegate = self
        
        
        //Notificaciones para los eventos del teclado.
        
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
       
        //Referencia a la BBDD de FireBase
        
        reference = FIRDatabase.database().reference()
        idFirebase = (FIRAuth.auth()?.currentUser?.uid)!
        ImcReference = reference.child(idFirebase).child("IMC")
        saveButton.layer.cornerRadius = 15
        lastButton.layer.cornerRadius = 15
        salir1Button.layer.cornerRadius = 15
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func calculateSaveButton(_ sender: Any) {
        
        peso2.resignFirstResponder()
        heigth.resignFirstResponder()
        
        let weigthDOUBLE = (peso2.text! as NSString).doubleValue
        let heightDOUBLE = (heigth.text! as NSString).doubleValue
        
        if ((peso2.text?.isEmpty)! || (heigth.text?.isEmpty)!){
            showAlert(title: "Atención", message: "Debes rellenar todos los campos")
        }else{
        
            let IMC = weigthDOUBLE / (heightDOUBLE * heightDOUBLE)
        
        
        
            let entry = ["peso": weigthDOUBLE,
                         "altura": heightDOUBLE,
                         "imc" :IMC]
        
            reference.child(idFirebase).child("IMC").childByAutoId().setValue(entry)
        
            showAlert(title: "IMC", message: "Tu IMC es \(IMC)")
        }

        peso2.text = ""
        heigth.text = ""
        
        

        
    }
    
    @IBAction func lastIMC(_ sender: Any) {
    
        ImcReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                if !result.isEmpty {
                    for child in result.reversed() {
                      let hijo = child.children.allObjects
                        for element in hijo{
                            let cadena = String(describing: element)
                            if cadena.contains("imc"){
                                let divisor = cadena.split(separator: " ")
                                let imc = divisor[2]
                                self.showAlert(title: "Último IMC", message: "Tu último IMC es \(imc)")
                            }
                        }
                    }
                }else{
                    self.showAlert(title: "ERROR", message: "No has introducido previamente un IMC")
                }
            }
        })
       

    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        
        try! FIRAuth.auth()?.signOut()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
   

}
