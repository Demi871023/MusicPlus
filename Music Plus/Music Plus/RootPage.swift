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

class RootViewController: UIViewController,FetchSelectRow{
    func fetchInt(rowNumber: Int) {
        // 檢查此 page 是否已被載入過
        if isViewLoaded
        {
            print("Load!")
        }
        else
        {
            print("===")
            print(rowNumber)
            print("===")
            print("Not load")
            return
        }
        
        DispatchQueue.main.async(){
            self.NowPlayingView.isHidden = true
        }
        NowPlayingSongNameText.text = SongSearchArray[rowNumber].SongName
    }
    
    
    var loadcount = 0
    var SearchRecordFilePath = String()
    
    @IBOutlet weak var NowPlayingView: UIView!
    @IBOutlet weak var NowPlayingCoverImage: UIView!
    @IBOutlet weak var NowPlayingSongNameText: UILabel!
    @IBAction func LogoutButtonHandler(_ sender: Any) {
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "LogoutSegue", sender: self)
        }
    }
    
    let fileManger = FileManager.default
    let UserSearchRecordFile = NSHomeDirectory() + "/Documents/SearchRecord.txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        DispatchQueue.main.async(){
            self.NowPlayingView.isHidden = true
        }
        
        // 在一登入的時候就創建、檢查該手機的個人搜尋紀錄檔案
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        SearchRecordFilePath = mainPath + "/SearchRecord.txt"
        let SearchRecordFileIsExit = FileManager.default.fileExists(atPath: SearchRecordFilePath)
        
        if SearchRecordFileIsExit == false
        {
            print("Yes")
            do{
                fileManger.createFile(atPath:UserSearchRecordFile, contents: nil, attributes: nil)
            }
            catch
            {
                print("error")
            }
        }
        else
        {
            print("File is exist")
        }
    }
    
    // PageViewController
    var CenterPVC:CenterPageViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "PVCSegue")
        {
            if(segue.destination.isKind(of: CenterPageViewController.self))
            {
                CenterPVC = segue.destination as? CenterPageViewController
            }
        }
    }
    
    // Change Page By Index Number
    @IBAction func FourPageFirst(_ sender: Any) {
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
    }
    
}





