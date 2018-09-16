//
//  CoresterolViewController.swift
//  FacebookLoginDemo_Inicio
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class CoresterolViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var hdl: UITextField!
    
    @IBOutlet weak var cholesterolTotal: UITextField!
    
    @IBOutlet weak var trigliceridos: UITextField!
    
    
    @IBOutlet weak var salirButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var reference: FIRDatabaseReference!
    var idFirebase = ""
    var LdlReference: FIRDatabaseQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hdl.delegate = self
        cholesterolTotal.delegate = self
        trigliceridos.delegate = self
        
        saveButton.layer.cornerRadius = 15
        lastButton.layer.cornerRadius = 15
        salirButton.layer.cornerRadius = 15
        
        reference = FIRDatabase.database().reference()
        idFirebase = (FIRAuth.auth()?.currentUser?.uid)!
        LdlReference = reference.child(idFirebase).child("LDL")
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func calculateSaveButton(_ sender: UIButton) {
        
        hdl.resignFirstResponder()
        cholesterolTotal.resignFirstResponder()
        trigliceridos.resignFirstResponder()
        
        let hdlInt = (hdl.text! as NSString).intValue
        let cholesterolTotalInt = (cholesterolTotal.text! as NSString).intValue
        let trigliceridosInt = (trigliceridos.text! as NSString).intValue
        
        if ((hdl.text?.isEmpty)! || (cholesterolTotal.text?.isEmpty)! || (trigliceridos.text?.isEmpty)!){
            showAlert(title: "Atención", message: "Debes rellenar todos los campos")
        }else{
            let ldl = cholesterolTotalInt - (hdlInt + (trigliceridosInt/5)) //LDLc = CT - (HDLc + TG/5) en mg/dl
        
            let entry = ["hdl": hdlInt,
                         "colesterolTotal": cholesterolTotalInt,
                         "trigliceridos": trigliceridosInt,
                         "ldl" :ldl]
        
            reference.child(idFirebase).child("LDL").childByAutoId().setValue(entry)
            showAlert(title: "LDL", message: "Tu LDL es: \(ldl)")

        
            hdl.text = ""
            cholesterolTotal.text = ""
            trigliceridos.text = ""
        
        }
        
    }
    
    @IBAction func lastCholesterolButton(_ sender: UIButton) {
        
        LdlReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                if !result.isEmpty {
                    for child in result.reversed() {
                        let hijo = child.children.allObjects
                        for element in hijo{
                            let cadena = String(describing: element)
                            if cadena.contains("ldl"){
                                let divisor = cadena.split(separator: " ")
                                let ldl = divisor[2]
                                self.showAlert(title: "Último LDL", message: "Tu último LDL es \(ldl)")
                            }
                        }
                    }
                }else{
                    self.showAlert(title: "Error", message: "No has introducido previamente un LDL")
                }
            }
        })
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
    
    

}
