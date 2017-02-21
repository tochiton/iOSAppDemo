//
//  FirstViewController.swift
//  TableViewStory
//
//  Created by Developer on 2/9/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    let login_url = "http://row52-beta.azurewebsites.net/Api/V1/Account/Authenticate"
    let checksession_url = "http://row52-beta.azurewebsites.net/Api/V1/Account/TokenIsValid"
    
    var login_session:String = ""
    
   
    @IBOutlet weak var username_input: UITextField!
  
    @IBOutlet weak var password_input: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var login_button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //login_button.backgroundColor = .clear
        login_button.layer.cornerRadius = 5
        //logInButtom.layer.borderWidth = 1
        login_button.layer.borderColor = UIColor.white.cgColor
        
        
        //login_now(username: "tochiton", password: "password")
        
        let preferences = UserDefaults.standard
        if preferences.object(forKey: "session") != nil{
            login_session = preferences.object(forKey: "session") as! String
            check_session()
        }
        else{
           LoginToDo()
        }
    }

    @IBAction func DoLogin(_ sender: Any) {
        
        if(login_button.titleLabel?.text == "Logout"){
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            LoginToDo()
        }
        else{
            login_now(username: username_input.text!, password: password_input.text!)
        }
        
        
    }
    
    func login_now(username: String, password: String){
        //print("\(username) is login now...")
    
        let post_data: NSDictionary = NSMutableDictionary()
    
        //TODO: add check for input username and password
        post_data.setValue(username, forKey: "Username")
        post_data.setValue(password, forKey: "Password")
        
        let url:URL = URL(string: login_url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        var paramString = ""
        
        for(key, value) in post_data{
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            //print("Got response\(response)")
            
            let responseData = String(data: data!, encoding: String.Encoding.utf8)
            print(responseData!)
            if responseData != nil{
                self.login_session = responseData!
                let preferences = UserDefaults.standard
                preferences.set(responseData!, forKey: "session")
                DispatchQueue.main.async(execute: self.LoginDone)
            }
        
            let httpResponse = response as! HTTPURLResponse
           // print(httpResponse.statusCode)
            
        
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else{
                return
            }
            
            let json: Any?
            do{
                
                json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json!)
            }
            catch{
                return
            }
            guard let server_response = json as? NSDictionary else{
                return
            }
            if let data_block = server_response["Set-Cookie"] as? NSDictionary{
               
                if let session_data = data_block["session"] as? String{
                    self.login_session = session_data
                    
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    DispatchQueue.main.async(execute: self.LoginDone)
                }
            }
        })
        task.resume()
    
    }
    
    func LoginDone(){
        username_input.isEnabled = false
        password_input.isEnabled = false
        
        login_button.isEnabled = true
        
        login_button.setTitle("Logout", for: .normal)
        
    }
    func LoginToDo(){
        username_input.isEnabled = true
        password_input.isEnabled = true
        
        login_button.isEnabled = true
        
        login_button.setTitle("Login", for: .normal)
        
    }
    func check_session()
    {
        let post_data: NSDictionary = NSMutableDictionary()
        
        
        post_data.setValue(login_session, forKey: "session")
        
        let url:URL = URL(string: checksession_url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Spider " + login_session, forHTTPHeaderField: "Authorization")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            print("firing this now")
            print(response)
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            let json: Any?
            
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch
            {
                return
            }
            
            guard let server_response = json as? NSDictionary else
            {
                return
            }
            
            if let response_code = server_response["response_code"] as? Int
            {
                if(response_code == 200)
                {
                    DispatchQueue.main.async(execute: self.LoginDone)
                    
                    
                }
                else
                {
                    DispatchQueue.main.async(execute: self.LoginToDo)
                }
            }
            
            
            
        })
        
        task.resume()
        
        
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







