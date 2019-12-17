//
//  ViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/9/19.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var UserNickName:String = ""
var UserEmail:String = ""
var UserFrequency:String = ""
var UserSongAmount: String = ""
var UserRemainingTime: String = ""


class ViewController: UIViewController{
    
    var loadcount = 0
    
    
    //@IBOutlet weak var NowPlayingView: UIView!
    
    //@IBOutlet weak var NowPlayingCoverImage: UIView!
    
    //@IBOutlet weak var NowPlayingSongNameText: UILabel!
    
    /*@IBAction func LogoutButtonHandler(_ sender: Any) {
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "LogoutSegue", sender: self)
        }
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        /*DispatchQueue.main.async(){
            self.NowPlayingView.isHidden = true
        }*/
        // Do any additional setup after loading the view.
    }
    
    // Sign Up treaty agree buttom
    /*@IBAction func checkboxTuapped(sender:UIButton)
    {
        if(sender.isSelected)
        {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }*/
    
    
    // PageViewController
    //var CenterPVC:CenterPageViewController!
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "PVCSegue")
        {
            if(segue.destination.isKind(of: CenterPageViewController.self))
            {
                CenterPVC = segue.destination as? CenterPageViewController
            }
        }
    }*/
    
    // Change Page By Index Number
    /*@IBAction func FourPageFirst(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 0)
    }
    
    @IBAction func FourPageSecond(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 1)
    }
    
    @IBAction func FourPageThird(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 2)
    }
    
    @IBAction func FourPageFourth(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 3)
    }
    
    @IBAction func FourPageFifth(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 4)
    }*/
    
}

class UserProfileViewController: UIViewController{
    
    var EditStatus:Bool = false
    
    @IBOutlet weak var NickNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var FrequencyLabel: UILabel!
    @IBOutlet weak var RemainingTimeLabel: UILabel!
    @IBOutlet weak var SongAmountLabel: UILabel!
    
    
    @IBOutlet weak var EditUserProfileButton: UIButton!
    
    @IBOutlet weak var MyPhotoImage: UIImageView!
    
    
    func GetUserInfo()
    {
        //let EmailWithSHA256 = EmailTextField.text
        //let PasswordWithSHA256 = PasswordTextField.text?.sha256String ?? ""
        
        let parameters:[String:Any] = ["UserId": UserId] as! [String:Any]
        
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/info") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with:  request){
            (data, response, error) in
            if let response = response{
                print(response)
            }
            
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    let json2 = try JSONDecoder().decode(UserInfo.self, from: data)
                    UserNickName = json2.user_nickname
                    UserEmail = json2.user_mail
                    UserFrequency = String(json2.frequency) + "次"
                    UserSongAmount = String(json2.song_amount) + "首"
                    UserRemainingTime = String(json2.remaining_time) + "小時"
                    print(UserRemainingTime)
                    print(UserSongAmount)
                    print(UserFrequency)
                    //print(json2)
                    
                }
                catch{
                    print(error)
                }
            }
            self.SetUpUserInfo()
        }.resume()
    }
    
    func SetUpUserInfo()
    {
        DispatchQueue.main.async(){
            self.NickNameTextField.text = UserNickName
            self.EmailTextField.text = UserEmail
            self.FrequencyLabel.text = UserFrequency
            self.SongAmountLabel.text = UserSongAmount
            self.RemainingTimeLabel.text = UserRemainingTime
        }
    }
    
    override func viewDidLoad() {
        
        GetUserInfo()
        //NickNameTextField.text = "Demi871023"
        //EmailTextField.text = "demi871023@gmail.com"
        EditUserProfileButton.backgroundColor = UIColor.orange
        MyPhotoImage.image = UIImage(named: "MyPhoto")
       
        //MyPhotoImage.clipsToBounds = true
        //MyPhotoImage.layer.cornerRadius = MyPhotoImage.frame.size.width / 2
        
        //MyPhotoImage.layer.borderColor = UIColor.orange as! CGColor
        //MyPhotoImage.layer.borderWidth = 2
        NickNameTextField.isEnabled = false
        EmailTextField.isEnabled = false
        super.viewDidLoad()
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func EditUserProfile()
    {
        print("Editing Now!")
        
        if(!EditStatus)
        {
            // 修改個神資料
            EditStatus = true
            EditUserProfileButton.setTitle("save", for: .normal)
            EditUserProfileButton.backgroundColor = UIColor.white
            NickNameTextField.isEnabled = true
            EmailTextField.isEnabled = true
        }
        else
        {
            // 無法修改個人資料
            EditStatus = false
            EditUserProfileButton.setTitle("edit", for: .normal)
            
            EditUserProfileButton.backgroundColor = UIColor.orange
            NickNameTextField.isEnabled = false
            EmailTextField.isEnabled = false
            
            PostDataUpdateDB()
            
        }
    }
    
    func PostDataUpdateDB()
    {
        let parameters:[String:Any] = ["UserId": UserId, "Email": EmailTextField.text, "Nickname": NickNameTextField.text] as! [String:Any]
        
        print(UserId)
        print(EmailTextField.text)
        print(NickNameTextField.text)
        
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/edit") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with:  request){
            (data, response, error) in
            if let response = response{
                print(response)
            }
            
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    //print(json)
                    /*let json2 = try JSONDecoder().decode(UserInfo.self, from: data)
                    UserNickName = json2.user_nickname
                    UserEmail = json2.user_mail*/
                    
                    //print(json2)
                    
                }
                catch{
                    print(error)
                }
            }
        }.resume()
    }
}


class CustomButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBUttomStyle()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBUttomStyle()
    }
    func setBUttomStyle(){
        layer.cornerRadius = 20 // 邊框橢圓
    }
}

