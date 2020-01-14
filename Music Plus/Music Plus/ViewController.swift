/* 2019.12.18 更新搜尋紀錄版本 */

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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// 個人資料頁面
class UserProfileViewController: UIViewController{
    
    var EditStatus:Bool = false
    
    @IBOutlet weak var NickNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var FrequencyLabel: UILabel!
    @IBOutlet weak var RemainingTimeLabel: UILabel!
    @IBOutlet weak var SongAmountLabel: UILabel!
    
    @IBOutlet weak var EditUserProfileButton: UIButton!
    @IBOutlet weak var MyPhotoImage: UIImageView!
    
    // 利用登入時取得的 UserID，取得此 User 的基本資料
    func GetUserInfo()
    {
        
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
                }
                catch{
                    print(error)
                }
            }
            self.SetUpUserInfo()
        }.resume()
    }
    
    // 設置使用者資料
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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        // 讓 navigationController 的背景變成透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        GetUserInfo()
        EditUserProfileButton.backgroundColor = UIColor.orange
        NickNameTextField.isEnabled = false
        EmailTextField.isEnabled = false
        super.viewDidLoad()
    }
    
    // 當觸碰到空白處，鍵盤就會縮起來
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 編輯按鈕可更改個人資料
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
    
    // 將使用者更改完的資料傳送給後端更新資料庫
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

