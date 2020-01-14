//
//  LoginViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/10/3.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit

var UserId:Int = 0

struct LoginToken: Decodable{
    let Check: String
    let user_id: Int
    let user_nickname: String
}

struct SongInfo: Decodable{
    let song_album: String
    let song_artist: String
    let song_id: Int
    var song_lyrics: String?
    let song_name: String
    let song_photo: URL
}

struct TopicInfo: Decodable{
    let list_id: Int
    let list_name: String
}

struct ListContent: Decodable{
    let song_id: Int
}

struct SongFindWithKey: Decodable{
    let song_id: Int
    let song_artist: String
    var song_lyrics: String?
    let song_name: String
    let song_photo: URL
    let song_album: String
}

struct UserInfo: Decodable{
    let frequency: Int
    let remaining_time: Int
    let song_amount: Int
    let user_mail: String
    let user_nickname: String
}

struct MyList : Decodable {
    let personal_list: [String]
    enum CodingKeys: String, CodingKey {
        case personal_list
    }
}

struct MyRecommend: Decodable{
    let Recommend_list: [String]
}

struct GenreList: Decodable{
    let SondList: [Int]
    enum CodingKeys: String, CodingKey {
        case SondList
    }
}

// Login Request By POST with User Information
class LoginViewController: UIViewController{
    
    var token = String("")
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var ErrorText: UILabel!
    
    @IBOutlet weak var ErrorImage: UIImageView!
    
    
    @IBOutlet weak var LoginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorImage.isHidden = true
        ErrorText.isHidden = true
    }
    
    // 觸碰到背景畫面 鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func EmailTextFieldEditChange(_ sender: UITextField) {
        print(sender.text!)
    }
    
    // 登入按鈕可傳送使用者輸入的帳密給後端與，使其與資料庫比對即登入（密碼使用 HASH）
    @IBAction func LoginWithPost(_ sender: Any) {
        
        let EmailWithSHA256 = EmailTextField.text
        let PasswordWithSHA256 = PasswordTextField.text?.sha256String ?? ""
        
        let parameters:[String:Any] = ["Email": EmailWithSHA256, "Password": PasswordWithSHA256] as! [String:Any]
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/login") else {return}
        
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
                    let json2 = try JSONDecoder().decode(LoginToken.self, from: data)
                    UserId = json2.user_id
                    UserNickName = json2.user_nickname
                    self.token = json2.Check
                    if self.token == "Yes"
                    {
                        DispatchQueue.main.async(){
                            self.ErrorImage.isHidden = true
                            self.ErrorText.isHidden = true
                            self.performSegue(withIdentifier: "LoginSegue", sender: self)
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
}

class LoginNavigationController:UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
