//
//  RequestInfoBarCodeViewController.swift
//  TableViewStory
//
//  Created by Developer on 3/9/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit

class RequestInfoBarCodeViewController: UIViewController {

    let barCode = "66664444"
    let barCodeUrl = "http://row52-beta.azurewebsites.net/api/v1/Vehicle/GetVehicle/"
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var modelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let apiBarCodeUrl = barCodeUrl + barCode
        //print(apiBarCodeUrl)
        let url:URL = URL(string: apiBarCodeUrl)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest){
            (data, response, error) in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            let json: Any?
            
            if(statusCode == 200){
                //print("BarCode request is working")
                do{
                    guard let _:Data = data, let _:URLResponse = response, error == nil else{
                        return
                    }
                    
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    guard let server_response = json as? NSDictionary else{
                        return
                    }
                    //print(server_response)
                    
                    let makeFromUrl = server_response["Make"] as? String
                    let modelFromUrl = server_response["Model"] as? String
                    
                    self.make.text = makeFromUrl!
                    self.modelDescription.text = modelFromUrl
                    
                    
                    // make this part of the code asyncronouos to speed the process
                    if let largeImage = server_response["SmallImage"] as? String{
                        print(largeImage)
                        let imageUrl = URL(string: largeImage)
                        let imageData = try? Data(contentsOf: imageUrl!)
                        self.imageView.image = UIImage(data: imageData!)
                    }
                    
                    
                }catch{
                    print("Error with Json: \(error)")
                }
                
            }
        }
        
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
