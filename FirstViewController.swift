//
//  FirstViewController.swift
//  TableViewStory
//
//  Created by Developer on 2/9/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var logInButtom: UIButton!
   
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logInButtom.backgroundColor = .clear
        logInButtom.layer.cornerRadius = 5
        logInButtom.layer.borderWidth = 1
        logInButtom.layer.borderColor = UIColor.black.cgColor
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
