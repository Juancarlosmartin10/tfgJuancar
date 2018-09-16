//
//  TabaquismoViewController.swift
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class TabaquismoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cigarretes: UITextField!
    @IBOutlet weak var years: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var lastButton: UIButton!
    
    @IBOutlet weak var salirButton: UIButton!
    
    
    var reference: FIRDatabaseReference!
    var idFirebase = ""
    var TabReference: FIRDatabaseQuery!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cigarretes.delegate = self
        years.delegate = self
        reference = FIRDatabase.database().reference()
        
        idFirebase = (FIRAuth.auth()?.currentUser?.uid)!
        TabReference = reference.child(idFirebase).child("TABAQUISMO")

        saveButton.layer.cornerRadius = 15
        lastButton.layer.cornerRadius = 15
        salirButton.layer.cornerRadius = 15
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
    
    @IBAction func saveCalculateButton(_ sender: UIButton) {
        
        cigarretes.resignFirstResponder()
        years.resignFirstResponder()
        
        let cigarretesInt = (cigarretes.text! as NSString).intValue
        let yearsInt = (years.text! as NSString).intValue
        
        if ((cigarretes.text?.isEmpty)! || (years.text?.isEmpty)!){
            showAlert(title: "Atención", message: "Debes rellenar todos los campos")
        }else{
        
            let smoking = (cigarretesInt*yearsInt)/20
        
        
            let entry = ["cigarrillosDia": cigarretesInt,
                         "añosFumando": yearsInt,
                         "tabaquimso" :smoking]

            reference.child(idFirebase).child("TABAQUISMO").childByAutoId().setValue(entry)
            showAlert(title: "Tabaquismo", message: "Tu Tabaquismo es: \(smoking)")
        
            cigarretes.text = ""
            years.text = ""
    }
        

    }
    
    @IBAction func lastSmoking(_ sender: UIButton) {
        
        TabReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                if !result.isEmpty {
                    for child in result.reversed() {
                        let hijo = child.children.allObjects
                        for element in hijo{
                            let cadena = String(describing: element)
                          
                            if cadena.contains("(tabaquimso)"){
                                let divisor = cadena.split(separator: " ")
                                let tab = divisor[2]
                                print(tab)
                                self.showAlert(title: "Último Tabaquismo", message: "Tu último Tabaquismo es \(tab)")
                            }
                        }
                    }
                }else{
                    self.showAlert(title: "Error", message: "No has introducido previamente un Tabaquismo")
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
