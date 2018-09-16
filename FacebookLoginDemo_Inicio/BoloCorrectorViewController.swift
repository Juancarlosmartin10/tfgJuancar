//
//  BoloCorrectorViewController.swift
//  FacebookLoginDemo_Inicio
//
//  Created by Juan Carlos Martin Sanchez on 6/7/18.
//  Copyright © 2018 EfectoApple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BoloCorrectorViewController: UIViewController, UITextFieldDelegate {

    var reference: FIRDatabaseReference!
    var idFirebase = ""
    
    var glucosaPreComida = Double()
    
    @IBOutlet weak var tiempo: UITextField!
    
    @IBOutlet weak var unidadesInsulina: UITextField!
    
    @IBOutlet weak var calcularButton: UIButton!
    
    @IBOutlet weak var glucosaPostComida: UITextField!
    
    var kDia = Double()
    var c1 = Double()
    var c2 = Double()
    var iob = Double()
    var i = Int()
    var incrementoPoet = Double()
    var SI = Double()
    var boloCorrector = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tiempo.delegate = self
        unidadesInsulina.delegate = self
        glucosaPostComida.delegate = self
        
        calcularButton.layer.cornerRadius = 15
        reference = FIRDatabase.database().reference()
        idFirebase = (FIRAuth.auth()?.currentUser?.uid)!
        SI = 40
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
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        tiempo.resignFirstResponder()
        unidadesInsulina.resignFirstResponder()
        glucosaPostComida.resignFirstResponder()
        
        if ((tiempo.text?.isEmpty)! || (unidadesInsulina.text?.isEmpty)! || (glucosaPostComida.text?.isEmpty)!){
            showAlert(title: "Atención", message: "Se necesitan todos los datos para calcular el bolo")
        }else{
            
           let tiempoInt = Int((tiempo.text! as NSString).intValue)
           let unidadesInsulinaDouble = Double((unidadesInsulina.text! as NSString).doubleValue)
            let glucosaPostComidaDouble = Double((glucosaPostComida.text! as NSString).doubleValue)
            let tiempoDouble = Double((tiempo.text! as NSString).doubleValue)
            /*Calculo de incremento*/
            
            if tiempoInt < 90 {
                showAlert(title: "Atención", message: "No se puede recomendar bolo corrector")
            }else if tiempoInt >= 90 && tiempoInt < 105{
                incrementoPoet = 60.0
            }else if tiempoInt >= 105 && tiempoInt < 125{
                incrementoPoet = 80
            }else if tiempoInt >= 125 && tiempoInt < 135{
                incrementoPoet = 60.0
            }else{
                showAlert(title: "Atención", message: "No se puede recomendar bolo corrector")
            }
            
            c1 = 6 //Insulina del bolo prandrial, no el tiempo
            c2 = 0.0
            i = 1
            
            repeat{
                
                c1 = c1 - (c1 * kDia)
                c2 = kDia * (c1 - c2) + c2
                iob = c1 + c2
                i = i+1;
                
            }while i < tiempoInt
            
            print (iob)
            boloCorrector = ((100 - (120 + incrementoPoet))/SI)-iob
            
            let entry = ["glucosa_post_comida": glucosaPostComidaDouble,
                         "glucosa_pre_comida": glucosaPreComida,
                         "tiempo": tiempoInt,
                         "iob" :iob ,
                         "bolo_corrector_UD_insulina": boloCorrector] as [String : Any]
            
            reference.child(idFirebase).child("BOLOCORRECTOR").childByAutoId().setValue(entry)
            print(iob)
            
            showAlert(title: "BoloCorrector", message: "Debes tomar\(boloCorrector)U de insulina")
            
            tiempo.text = ""
            unidadesInsulina.text = ""
            glucosaPostComida.text = ""
            
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
