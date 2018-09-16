//
//  DatosBolosViewController.swift
//  FacebookLoginDemo_Inicio
//
//  Created by Juan Carlos Martin Sanchez on 6/7/18.
//  Copyright © 2018 EfectoApple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class DatosBolosViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var glucosaNMinutos: UITextField!
    @IBOutlet weak var glucosaComidas: UITextField!
    @IBOutlet weak var glucosaNoche: UITextField!
    @IBOutlet weak var glucosaDia: UITextField!
    
    @IBOutlet weak var guardarBuuton: UIButton!
    
    @IBOutlet weak var salirButton: UIButton!
    
    
    var glucosaDiaInt = Double()
    var glucosaNocheInt = Double()
    var glucosaComidaInt = Double()
    var glucosaNMinutosInt = Double()
   
    var reference: FIRDatabaseReference!
    var idFirebase = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glucosaDiaInt = 100.0
        glucosaNocheInt = 100.0
        glucosaComidaInt = 100.0
        glucosaNMinutosInt = 190.0
        salirButton.layer.cornerRadius = 15
        guardarBuuton.layer.cornerRadius = 15
        
        glucosaNMinutos.delegate = self
        glucosaNoche.delegate = self
        glucosaDia.delegate = self
        glucosaComidas.delegate = self
        
        
        reference = FIRDatabase.database().reference()
        
        idFirebase = (FIRAuth.auth()?.currentUser?.uid)!
        
        //Notificaciones para los eventos del teclado.
        
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let boloPrandialController = segue.destination as! BoloPrandialViewController
        boloPrandialController.glucosaPreComida = glucosaComidaInt
        
        /* let boloCorrectorController = segue.destination as! BoloCorrectorViewController
         boloCorrectorController.glucosaPreComida = glucosaComidaInt */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
       
        glucosaDia.resignFirstResponder()
        glucosaNoche.resignFirstResponder()
        glucosaComidas.resignFirstResponder()
        glucosaNMinutos.resignFirstResponder()
        
        if !(glucosaDia.text?.isEmpty)!{
            glucosaDiaInt = Double((glucosaDia.text! as NSString).doubleValue)
        }
        if !(glucosaNoche.text?.isEmpty)!{
            glucosaNocheInt = Double((glucosaNoche.text! as NSString).doubleValue)
        }
        if !(glucosaComidas.text?.isEmpty)!{
            glucosaComidaInt = Double((glucosaComidas.text! as NSString).doubleValue)
        }
        if !(glucosaNMinutos.text?.isEmpty)!{
            glucosaNMinutosInt = Double((glucosaNMinutos.text! as NSString).doubleValue)
        }
        
        //performSegue(withIdentifier: "precomida", sender: self)
        
        let entry = ["glucosaObjetivoDia": glucosaDiaInt,
                     "glucosaObjetivoNoche": glucosaNocheInt,
                     "glucosaObjetivoComidas" :glucosaComidaInt,
                     "glucosaObjetivoNMinutosComida":glucosaNMinutosInt]
        
        reference.child(idFirebase).child("CALCULADORBOLOS").childByAutoId().setValue(entry)
        showAlert(title: "Información", message: "Si no has introducido un dato se guardará el de por defecto")
        
        
        
        glucosaDia.text = ""
        glucosaNoche.text = ""
        glucosaComidas.text = ""
        glucosaNMinutos.text = ""
        
        
    }
    
    
    
    @IBAction func exitButton(_ sender: UIButton) {
        try! FIRAuth.auth()?.signOut()
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
