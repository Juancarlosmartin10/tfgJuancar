//
//  HTAViewController.swift
//  FacebookLoginDemo_Inicio
//
//  Created by Juan Carlos Martin Sanchez on 3/7/18.
//  Copyright © 2018 EfectoApple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HTAViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var diastolic: UITextField!
    @IBOutlet weak var sistolic: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var lastButton: UIButton!
    
    @IBOutlet weak var salirButton: UIButton!
    var reference: FIRDatabaseReference!
    var idFirebase = ""
    var HtaReference: FIRDatabaseQuery!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = FIRDatabase.database().reference()
        diastolic.delegate = self
        sistolic.delegate = self
        
        idFirebase = (FIRAuth.auth()?.currentUser?.uid)!
        HtaReference = reference.child(idFirebase).child("HTA")
        saveButton.layer.cornerRadius = 15
        lastButton.layer.cornerRadius = 15
        salirButton.layer.cornerRadius = 15
        
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
    
    

    @IBAction func saveCalculateButton(_ sender: UIButton) {
        
        diastolic.resignFirstResponder()
        sistolic.resignFirstResponder()
        
        let diastolicInt = (diastolic.text! as NSString).intValue
        let sistolicInt = (sistolic.text! as NSString).intValue
        
        if ((diastolic.text?.isEmpty)! || (sistolic.text?.isEmpty)!){
            showAlert(title: "Atención", message: "Debes rellenar todos los campos ")
        }else{
        
            let hta = (diastolicInt*2) + (sistolicInt/3)

            let entry = ["presionDiastolica": diastolicInt,
                         "presionSistolica": sistolicInt,
                         "hta" :hta]

            reference.child(idFirebase).child("HTA").childByAutoId().setValue(entry)
            showAlert(title: "HTA", message: "Tu HTA es \(hta)")
        }
        
        diastolic.text = ""
        sistolic .text = ""
        
       

        
    }
    @IBAction func lastHtaButton(_ sender: UIButton) {
        
        HtaReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                if !result.isEmpty{
                    for child in result.reversed() {
                        let hijo = child.children.allObjects
                        for element in hijo{
                            let cadena = String(describing: element)
                            if cadena.contains("hta"){
                                let divisor = cadena.split(separator: " ")
                                let hta = divisor[2]
                                self.showAlert(title: "Último HTA", message: "Tu último HTA es \(hta)")
                            }
                        }
                    }
                }else{
                    self.showAlert(title: "Error", message: "No has introducido previamente un HTA")
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
