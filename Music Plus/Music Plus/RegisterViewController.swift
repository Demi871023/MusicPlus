//
//  RegisterViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/10/25.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit

// 用於 Parse 註冊完成後回傳回來的 Token
struct RegisterToken: Decodable{
    let Check: String
}

// 註冊頁面
class RegisterViewController:UIViewController{
    
    var token = String("")
    
    var AgreeCheck = false
    
    
    @IBOutlet weak var EmailErrorText: UILabel!
    @IBOutlet weak var EmailErrorImage: UIImageView!
    
    @IBOutlet weak var UserNameErrorText: UILabel!
    @IBOutlet weak var UserNameErrorImage: UIImageView!
    
    @IBOutlet weak var PasswordErrorText: UILabel!
    @IBOutlet weak var PasswordErrorImage: UIImageView!
    
    @IBOutlet weak var ConfirmPasswordErrorText: UILabel!
    @IBOutlet weak var ConfirmPasswordErrorImage: UIImageView!
    
    @IBOutlet weak var AgreeErrorText: UILabel!
    @IBOutlet weak var AgreeErrorImage: UIImageView!
    
    @IBOutlet weak var ErrorImage: UIImageView!
    @IBOutlet weak var ErrorText: UILabel!
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBAction func AgreeCheckBox(_ sender: UIButton) {
        if(sender.isSelected)
        {
            sender.isSelected = false
            AgreeCheck = false
            print(AgreeCheck)
        }
        else
        {
            sender.isSelected = true
            AgreeCheck = true
            print(AgreeCheck)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpErrorTextAndImage()
    }
    
    // 觸碰到背景畫面 鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func SetUpErrorTextAndImage()
    {
        EmailErrorText.isHidden = true
        EmailErrorImage.isHidden = true
        
        UserNameErrorText.isHidden = true
        UserNameErrorImage.isHidden = true
        
        PasswordErrorText.isHidden = true
        PasswordErrorImage.isHidden = true
        
        ConfirmPasswordErrorText.isHidden = true
        ConfirmPasswordErrorImage.isHidden = true
        
        AgreeErrorText.isHidden = true
        AgreeErrorImage.isHidden = true
        
        ErrorText.isHidden = true
        ErrorImage.isHidden = true
    }
    
    @IBAction func SignUpWithPOST(_ sender: Any) {
        
        SetUpErrorTextAndImage()
        
        let Email = EmailTextField.text!
        let PasswordNoSha256 = PasswordTextField.text!
        let Password = PasswordTextField.text?.sha256String ?? ""
        let Nickname = UserNameTextField.text!
        let ConfirmPassword = ConfirmPasswordTextField.text!
        
        if(!Email.isEmpty && !PasswordNoSha256.isEmpty && (PasswordNoSha256 == ConfirmPassword) && AgreeCheck)
        {
            let parameters:[String:Any] = ["Email": Email, "Password": Password, "Nickname": Nickname] as! [String:Any]
            
            guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/register") else {return}
            
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
                        let json2 = try JSONDecoder().decode(RegisterToken.self, from: data)
                        self.token = json2.Check
                        print("Check", json2.Check)
                        if self.token == "Yes"
                        {
                            DispatchQueue.main.async(){
                                self.performSegue(withIdentifier: "RegisterYesSegue", sender: self)
                            }
                            print("correct")
                        }
                        else if self.token == "No"
                        {
                            DispatchQueue.main.async {
                                self.ErrorImage.isHidden = false
                                self.ErrorText.isHidden = false
                            }
                            print("wrong")
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }.resume()
        }
        else
        {
            if(Email.isEmpty)
            {
                EmailErrorText.isHidden = false
                EmailErrorImage.isHidden = false
            }
            if(Nickname.isEmpty)
            {
                UserNameErrorText.isHidden = false
                UserNameErrorImage.isHidden = false
            }
            if(PasswordNoSha256.isEmpty)
            {
                PasswordErrorText.isHidden = false
                PasswordErrorImage.isHidden = false
            }
            if(PasswordNoSha256 != ConfirmPassword)
            {
                ConfirmPasswordErrorText.isHidden = false
                ConfirmPasswordErrorImage.isHidden = false
            }
            if(!AgreeCheck)
            {
                AgreeErrorText.isHidden = false
                AgreeErrorImage.isHidden = false
            }
        }
    }
}


