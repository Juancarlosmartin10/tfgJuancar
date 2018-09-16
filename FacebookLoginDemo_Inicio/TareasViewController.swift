//
//  TareasViewController.swift
//  FacebookLoginDemo_Inicio
//

import UIKit

class TareasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let exercisesList = ["IMC", "HTA", "TABAQUISMO", "CALCULADOR DE BOLOS", "COLESTEROL"]
    let  idintities = ["A", "B", "C", "D", "E"]
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.navigationBar.barTintColor = UIColor.black

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell
        cell.labelCell.text = exercisesList[indexPath.row]
        cell.imageCell.image = UIImage(named: exercisesList[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: idintities[indexPath.row]  , sender: self)
    }


   

}
