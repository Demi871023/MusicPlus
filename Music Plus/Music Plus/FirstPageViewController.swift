//
//  FirstPageViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/9/20.
//  Copyright © 2019 劉品萱. All rights reserved.
//

// Page View Controller - First Page: My page

import Foundation
import UIKit

class FirstPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var MyPageTVC: UITableView!
    
    var MyPageFuncArray = [MyPageFunc]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MyPageTVC?.estimatedRowHeight = 0
        SetUpMyPageFunc()
    }
    
    func SetUpMyPageFunc(){
        MyPageFuncArray.append(MyPageFunc(FuncIcon: "DownloadingSong", FuncLabel: "Downloading Song"))
        MyPageFuncArray.append(MyPageFunc(FuncIcon: "MyFavorite", FuncLabel: "My Favorite"))
        
    }
    
    //let MyPageList = ["Downloading Song", "My Favorite"]
    
    /*public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MyPageList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = MyPageList[indexPath.row]
        
        return cell
        
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageFuncArray.count
    }
    // Set Table View DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyPageTVC.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! MyPageTableViewCell
        
        cell.MyPageFuncIconCell.image = UIImage(named: MyPageFuncArray[indexPath.row].FuncIcon)
        cell.MyPageFuncLabelCell.text = MyPageFuncArray[indexPath.row].FuncLabel
        
        return cell
    }
    
    // Set Table View Cell high
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
   
}

class MyPageFunc{
    let FuncIcon: String
    let FuncLabel: String
    
    init(FuncIcon: String, FuncLabel: String) {
        self.FuncIcon = FuncIcon
        self.FuncLabel = FuncLabel
    }
}
