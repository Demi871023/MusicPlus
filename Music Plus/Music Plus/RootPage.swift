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
    
    
    @IBOutlet weak var NowPlayingView: UIView!
    
    @IBOutlet weak var NowPlayingCoverImage: UIView!
    
    @IBOutlet weak var NowPlayingSongNameText: UILabel!
    
    @IBAction func LogoutButtonHandler(_ sender: Any) {
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "LogoutSegue", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async(){
            self.NowPlayingView.isHidden = true
        }
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





