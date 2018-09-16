//
//  BoloPrandialViewController.swift
//  FacebookLoginDemo_Inicio
//
//  Created by Juan Carlos Martin Sanchez on 6/7/18.
//  Copyright © 2018 EfectoApple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BoloPrandialViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var calcularButton: UIButton!
    @IBOutlet weak var edad: UITextField!
    @IBOutlet weak var peso: UITextField!
    @IBOutlet weak var carbohidratos: UITextField!
    @IBOutlet weak var glucosa: UITextField!
    @IBOutlet weak var ratioIC: UITextField!
    
    var reference: FIRDatabaseReference!
    var idFirebase = ""
    
    var glucosaPreComida = Double()
    
   
    var carbohidratosDouble = Double()
    var glucosaINT = Double()
    var ratioICDouble = Double()
    var unidadesInsulina = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glucosa.delegate = self
        carbohidratos.delegate = self
        ratioIC.delegate = self
        carbohidratosDouble = 6.0
        glucosaINT = 100.0
        ratioICDouble = 1.2
        calcularButton.layer.cornerRadius = 15
        reference = FIRDatabase.database().reference()
        idFirebase = (FIRAuth.auth()?.currentUser?.uid)!

        // Do any additional setup after loading the view.
        
        //Notificaciones para los eventos del teclado.
        
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func CalculateButton(_ sender: UIButton) {

        glucosa.resignFirstResponder()
        carbohidratos.resignFirstResponder()
        ratioIC.resignFirstResponder()
        
        if !(carbohidratos.text?.isEmpty)!{
            carbohidratosDouble = Double((carbohidratos.text! as NSString).doubleValue)
        }
        if !(glucosa.text?.isEmpty)!{
            glucosaINT = Double((glucosa.text! as NSString).doubleValue)
        }
        if !(ratioIC.text?.isEmpty)!{
            ratioICDouble = Double((ratioIC.text! as NSString).doubleValue)
        }
        
        /* Ya tenemos los valores necesarios, pero tenemos tres casos */
        
        if glucosaINT < 65 { /*Bolo prandial con correcion negativa*/
            unidadesInsulina = (carbohidratosDouble * ratioICDouble) + ((glucosaPreComida-glucosaINT)/40)
        }else if glucosaINT > 140{ /*Bolo Prandial con correción positiva*/
            unidadesInsulina = (carbohidratosDouble * ratioICDouble) + ((glucosaINT-glucosaPreComida)/40)
        }else{/*Bolo prandial sin necesidad de corrección*/
            unidadesInsulina = carbohidratosDouble * ratioICDouble
        }
        
        let entry = ["carbohidratos": carbohidratosDouble,
                     "glucosa": glucosaINT,
                     "ratio": ratioICDouble,
                     "glucosaObjevivoPreComida" :glucosaPreComida,
                     "unidadesInsulina": unidadesInsulina]
        
        reference.child(idFirebase).child("BOLOPRANDRIAL").childByAutoId().setValue(entry)
        showAlert(title: "Bolo Prandrial", message: "Debes tomar \(unidadesInsulina)U de insulina")
        
        
        glucosa.text = ""
       
        carbohidratos.text = ""
        ratioIC.text = ""
 
        
        
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
