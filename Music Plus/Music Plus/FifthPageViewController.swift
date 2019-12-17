//
//  FifthPageViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/9/21.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// PlaySong

var timer: Timer?
var timerCheckIndex: Timer?
var LyricShow:Bool = false

class FifthPageViewController: UIViewController, FetchSelectRow{
    
    @IBOutlet weak var CoverImage: UIImageView!
    @IBOutlet weak var SongNameText: UILabel!
    @IBOutlet weak var SingerText: UILabel!
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var LyricTextView: UITextView!
    @IBOutlet weak var SongPlayButton: UIButton!
    @IBOutlet weak var SongProgress: UIProgressView!
    @IBOutlet weak var SongSlider: UISlider!
    @IBOutlet weak var SongLengthMaxText: UILabel!
    
    func fetchInt(rowNumber: Int) {
        if isViewLoaded
        {
            print("Load!")
        }
        else
        {
            print("Not load")
            return
        }
        print("===")
        print(rowNumber)
        
        
        print(SongSearchArray[rowNumber].SongName)
        print(SongSearchArray[rowNumber].Singer)
        
        SongNameText.text = SongSearchArray[rowNumber].SongName
        SingerText.text = SongSearchArray[rowNumber].Singer
        
    }
    
    @objc func SongSliderChangeAct(_sender: UISlider)
    {
        audioPlayer.currentTime = TimeInterval(_sender.value)
    }
    
    func SetUpSongSlider()
    {
        SongSlider.minimumValue = 0
        //SongSlider.maximumValue = Float(audioPlayer.duration)
        SongSlider.addTarget(self, action: #selector(FifthPageViewController.SongSliderChangeAct), for: .touchUpInside)
        if timer == nil
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FifthPageViewController.UpdateSongSlider), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimeInterval()
    {
        if timer != nil
        {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func UpdateSongSlider()
    {
        SongSlider.value = Float(audioPlayer.currentTime)
    }
    
    
    var songindex = 0
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isViewLoaded
        {
            print("Load!")
        }
        
        SongPlayButton.isSelected = true
        
        CoverImage.image = UIImage(contentsOfFile: SongSearchArray[songindex].Cover.path)
        SongNameText.text = SongSearchArray[songindex].SongName
        SingerText.text = SongSearchArray[songindex].Singer
        LyricTextView.text = SongSearchArray[songindex].Lyrics
        
        // 背景使用專輯封面霧化
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        BackgroundImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
        BackgroundImage.addSubview(blurEffectView)
        
        SongSlider.minimumValue = 0
        
        DispatchQueue.main.async(){
            self.LyricTextView.isHidden = true
        }
    }
 
    
    @IBAction func ButtonShowLyricTapped(_ sender: UIButton) {
        if(LyricShow == false)
        {
            print("Show Lyric")
            DispatchQueue.main.async(){
                self.LyricTextView.isHidden = false
            }
            LyricShow = true
        }
        else
        {
            print("Close Lyric!")
            DispatchQueue.main.async(){
                self.LyricTextView.isHidden = true
            }
            LyricShow = false
        }
    }
    
    //播放音樂介面 播放與暫停按鈕切換
    @IBAction func ButtomMusicPlayTapped(sender:UIButton)
    {
        if(sender.isSelected)
        {
            sender.isSelected = false
            print("Music pause")
            stopTimeInterval()
            audioPlayer.pause()
        }
        else
        {
            sender.isSelected = true
            print("Music play")
            audioPlayer.play()
            if timer == nil
            {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FifthPageViewController.UpdateSongSlider), userInfo: nil, repeats: true)
            }
            
        }
    }
    
    
    @IBAction func NextSong(_ sender: Any) {
        if(selectSongNumber + 1 == SongHaveNumber)
        {
            print("已經是最後一首！")
        }
        else
        {
            SongPlayButton.isSelected = true
            selectSongNumber = selectSongNumber + 1
            let singer = SongSearchArray[selectSongNumber].Singer
            let album = SongSearchArray[selectSongNumber].Album
            let song = SongSearchArray[selectSongNumber].SongName
            let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                audioPlayer.play()
            }
            catch{
                
            }
            
            CoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
            SongNameText.text = SongSearchArray[selectSongNumber].SongName
            SingerText.text = SongSearchArray[selectSongNumber].Singer
            LyricTextView.text = SongSearchArray[selectSongNumber].Lyrics
            BackgroundImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
        }
    }
    
    
    @IBAction func PreSong(_ sender: Any) {
        if(selectSongNumber - 1 < 0)
        {
            print("已經沒有前面一首！！！")
        }
        else
        {
            SongPlayButton.isSelected = true
            selectSongNumber = selectSongNumber - 1
            let singer = SongSearchArray[selectSongNumber].Singer
            let album = SongSearchArray[selectSongNumber].Album
            let song = SongSearchArray[selectSongNumber].SongName
            let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                audioPlayer.play()
            }
            catch{
                
            }
            CoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
            SongNameText.text = SongSearchArray[selectSongNumber].SongName
            SingerText.text = SongSearchArray[selectSongNumber].Singer
            LyricTextView.text = SongSearchArray[selectSongNumber].Lyrics
            BackgroundImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
        }
        
    }
    
    func SetUpPlayingSong(rowNumber:Int)
    {
        print(rowNumber)
        self.CoverImage?.image = UIImage(contentsOfFile: SongSearchArray[rowNumber].Cover.path)
        self.SongNameText?.text = SongSearchArray[rowNumber].SongName
        self.SingerText?.text = SongSearchArray[rowNumber].Singer
    }
}

class PlayingSongInfo
{
    let Cover: URL
    let Album: String
    let SongName: String
    let Singer: String
    let Category: SongType
    var SongPath: URL
    var SongLyric: String
    
    
    init(Cover: URL, Album:String, SongName: String, Singer: String, Category: SongType, SongPath: URL, SongLyric: String)
    {
        self.Cover = Cover
        self.Album = Album
        self.SongName = SongName
        self.Singer = Singer
        self.Category = Category
        self.SongPath = SongPath
        self.SongLyric = SongLyric
    }
}


