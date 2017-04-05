//
//  CameraViewController.swift
//  TableViewStory
//
//  Created by Developer on 3/30/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
    // second part -- incorporating camera features
    
    var imagePicker: UIImagePickerController!
    var imagesDirectoyPath: String!
    var images: [UIImage]!
    var titles: [String]!
    var newDir: String!
    
    var stringPassed = ""
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myLabel.text = stringPassed
        // add asynchronous call for speed
        getLocalFolder()
        launchCamera()
        
    }

    func launchCamera(){
        // creates an object of type UIImagePikcerController and and set the type to camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        //imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            // try to connect to the local directory
            // add timestamp to differentiate between files
            //write to file here
            /*
             let mediaType = info[UIImagePickerControllerOriginalImage]
             self.dismiss(animated:true, completion: nil)
             */
            imageView.image = image
            
            var imagePath = NSDate().description
            
            imagePath = imagePath.replacingOccurrences(of: " ", with: "")
            
            
            imagePath = newDir.appending("/\(imagePath).png")
            
            print("Real path: \(imagePath)")
            
            let data = UIImagePNGRepresentation(image)
            
            let success = FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil)
            
            do{
                titles = try FileManager.default.contentsOfDirectory(atPath: newDir)
                for title in titles{
                    print(title)
                }
            }catch{
                print("Error")
            }
            
            
        }
        else{
            print("Something went wrong")
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getLocalFolder(){
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsURL = dirPaths[0]
        
        //let newDir = docsURL.appendingPathComponent("ImagePicker").path
        
        newDir = docsURL.appendingPathComponent("ImagePicker").path
        
        var objcbool: ObjCBool = true
        print(docsURL)
        let isExist = filemgr.fileExists(atPath: newDir, isDirectory: &objcbool)
        
        if isExist == false{
            do{
                try filemgr.createDirectory(atPath: newDir, withIntermediateDirectories: true, attributes: nil)
                print("File created")
                // check the path exists
                print(newDir)
            }catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
        }
        else{
            print("Exist already")
            do{
                let fileList = try filemgr.contentsOfDirectory(atPath: "/")
                for filename in fileList{
                    print(filename)
                }
            }catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
            
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
