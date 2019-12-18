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
        print("===")
        print(rowNumber)
        
        
        print(SongSearchArray[rowNumber].SongName)
        print(SongSearchArray[rowNumber].Singer)
        //let cover = SongSearchArray[rowNumber].Cover.path
        //let songname = SongSearchArray[rowNumber].SongName
        //let singer = SongSearchArray[rowNumber].Singer
        
        //CoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
        
        
        NowPlayingSongNameText.text = SongSearchArray[rowNumber].SongName
        //SingerText.text = SongSearchArray[rowNumber].Singer
        
        
        /*CoverImage.image = UIImage(contentsOfFile: SongSearchArray[rowNumber].Cover.path)
         SongNameText.text = SongSearchArray[rowNumber].SongName
         SingerText.text = SongSearchArray[rowNumber].Singer*/
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
    
    //let SearchRecordFile:String = "SearchRecord.txt"
    
    let fileManger = FileManager.default
    let UserSearchRecordFile = NSHomeDirectory() + "/Documents/SearchRecord.txt"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async(){
            self.NowPlayingView.isHidden = true
        }
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(mainPath)
        SearchRecordFilePath = mainPath + "/SearchRecord.txt"
        //print(<#T##items: Any...##Any#>)
        let SearchRecordFileIsExit = FileManager.default.fileExists(atPath: SearchRecordFilePath)
        
        print(SearchRecordFileIsExit)
        //let path = try FileManager.default.url(for: .documentDirectory, in:.userDomainMask, appropriateFor: nil, create: true)
        
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
        
        
        /*var SearchRecordFileURL = URL(fileURLWithPath: UserSearchRecordFile)
        
        do{
            var noBackUp = URLResourceValues()
            noBackUp.isExcludedFromBackup = true
            try SearchRecordFileURL.setResourceValues(noBackUp)
        }
        catch
        {
            print("noBackUp setting fail")
        }*/
        
        // Do any additional setup after loading the view.
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





