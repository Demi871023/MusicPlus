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


var timerCheckIndex: Timer?
var LyricShow:Bool = true
var CoverShow:Bool = false
var SongRemain = 0
var SongRemainMinute = 0
var SongRemainSecond = 0
var SongElapsed = 0
var SongElapsedMinute = 0
var SongElapsedSecond = 0
var LoopControl:Bool = false

// 現在播放歌曲頁面
class FifthPageViewController: UIViewController, FetchSelectRow{
    
    var timer: Timer?
    
    @IBOutlet weak var CoverImage: UIImageView!
    @IBOutlet weak var SongNameText: UILabel!
    @IBOutlet weak var SingerText: UILabel!
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var LyricTextView: UITextView!
    @IBOutlet weak var SongPlayButton: UIButton!
    @IBOutlet weak var SongProgress: UIProgressView!
    @IBOutlet weak var SongSlider: UISlider!
    @IBOutlet weak var SongLengthMaxText: UILabel!
    @IBOutlet weak var SongLengthMinText: UILabel!
    
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
    
    
    
    
    @IBAction func ChooseSongRepeat(_ sender: UIButton) {
        
        if(sender.isSelected)
        {
            sender.isSelected = false
            LoopControl = false
            // 單首不重複播放
            audioPlayer.numberOfLoops = 0
            print(audioPlayer.numberOfChannels)
            print("List Song Repeate")
        }
        else
        {
            sender.isSelected = true
            LoopControl = true
            // 單首重複播放
            audioPlayer.numberOfLoops = -1
            print("One Song Repeat")
        }
    }
    
    
    func SetUpSongSlider()
    {
        SongSlider.minimumValue = 0
        SongSlider.maximumValue = Float(SongRemain)
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
        SongRemain = Int(audioPlayer.duration) - Int(audioPlayer.currentTime)
        SongElapsed = Int(audioPlayer.currentTime)
        
        SongRemainMinute = SongRemain / 60
        SongRemainSecond = SongRemain - (SongRemainMinute * 60)
        if(SongRemainSecond < 10)
        {
            SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":0" + String(SongRemainSecond)
        }
        else
        {
            SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":" + String(SongRemainSecond)
        }
        
        SongElapsedMinute = SongElapsed / 60
        SongElapsedSecond = SongElapsed - (SongElapsedMinute * 60)
        if(SongElapsedSecond < 10)
        {
            SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":0" + String(SongElapsedSecond)
        }
        else
        {
            SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":" + String(SongElapsedSecond)
        }
        
        if(SongRemain == 1)
        {
            print("Last one second")
        }
    }
    
    
    var songindex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationController?.isNavigationBarHidden = true

        SongRemainMinute = SongRemain / 60
        SongRemainSecond = SongRemain - (SongRemainMinute * 60)
        if(SongRemainSecond < 10)
        {
            SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":0" + String(SongRemainSecond)
        }
        else
        {
            SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":" + String(SongRemainSecond)
        }
        
        SongElapsedMinute = SongElapsed / 60
        SongElapsedSecond = SongElapsed - (SongElapsedMinute * 60)
        if(SongElapsedSecond < 10)
        {
            SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":0" + String(SongElapsedSecond)
        }
        else
        {
            SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":" + String(SongElapsedSecond)
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
        
        SetUpSongSlider()
        
        DispatchQueue.main.async(){
            self.LyricTextView.isHidden = LyricShow
                self.CoverImage.isHidden = CoverShow
        }
    }
 
    
    @IBAction func ButtonShowLyricTapped(_ sender: UIButton) {
        if(LyricShow == true)
        {
            print("Show Lyric")
            DispatchQueue.main.async(){
                self.LyricTextView.isHidden = false
                    self.CoverImage.isHidden = true
            }
            LyricShow = false
            CoverShow = true
        }
        else
        {
            print("Close Lyric!")
            DispatchQueue.main.async(){
                self.LyricTextView.isHidden = true
                self.CoverImage.isHidden = false
            }
            LyricShow = true
            CoverShow = false
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
        if(songindex + 1 == SongHaveNumber)
        {
            print("已經是最後一首！")
        }
        else
        {
            SongPlayButton.isSelected = true
            songindex = songindex + 1
            let singer = SongSearchArray[songindex].Singer
            let album = SongSearchArray[songindex].Album
            let song = SongSearchArray[songindex].SongName
            let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                audioPlayer.play()
                SongRemain = Int(audioPlayer.duration)
                if LoopControl == true
                {
                    audioPlayer.numberOfLoops = -1
                }
                else
                {
                    audioPlayer.numberOfLoops = 0
                }
                SetUpSongSlider()
                SongRemainMinute = SongRemain / 60
                SongRemainSecond = SongRemain - (SongRemainMinute * 60)
                if(SongRemainSecond < 10)
                {
                    SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":0" + String(SongRemainSecond)
                }
                else
                {
                    SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":" + String(SongRemainSecond)
                }
                
                SongElapsedMinute = SongElapsed / 60
                SongElapsedSecond = SongElapsed - (SongElapsedMinute * 60)
                if(SongElapsedSecond < 10)
                {
                    SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":0" + String(SongElapsedSecond)
                }
                else
                {
                    SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":" + String(SongElapsedSecond)
                }
            }
            catch{
                
            }
            
            CoverImage.image = UIImage(contentsOfFile: SongSearchArray[songindex].Cover.path)
            SongNameText.text = SongSearchArray[songindex].SongName
            SingerText.text = SongSearchArray[songindex].Singer
            LyricTextView.text = SongSearchArray[songindex].Lyrics
            BackgroundImage.image = UIImage(contentsOfFile: SongSearchArray[songindex].Cover.path)
        }
    }
    
    
    @IBAction func PreSong(_ sender: Any) {
        if(songindex - 1 < 0)
        {
            print("已經沒有前面一首！！！")
        }
        else
        {
            SongPlayButton.isSelected = true
            songindex = songindex - 1
            let singer = SongSearchArray[songindex].Singer
            let album = SongSearchArray[songindex].Album
            let song = SongSearchArray[songindex].SongName
            let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                audioPlayer.play()
                SongRemain = Int(audioPlayer.duration)
                if LoopControl == true
                {
                    audioPlayer.numberOfLoops = -1
                }
                else
                {
                    audioPlayer.numberOfLoops = 0
                }
                SetUpSongSlider()
                SongRemainMinute = SongRemain / 60
                SongRemainSecond = SongRemain - (SongRemainMinute * 60)
                if(SongRemainSecond < 10)
                {
                    SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":0" + String(SongRemainSecond)
                }
                else
                {
                    SongLengthMaxText.text = "0" + String(SongRemainMinute) + ":" + String(SongRemainSecond)
                }
                
                SongElapsedMinute = SongElapsed / 60
                SongElapsedSecond = SongElapsed - (SongElapsedMinute * 60)
                if(SongElapsedSecond < 10)
                {
                    SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":0" + String(SongElapsedSecond)
                }
                else
                {
                    SongLengthMinText.text = "0" + String(SongElapsedMinute) + ":" + String(SongElapsedSecond)
                }
            }
            catch{
                
            }
            CoverImage.image = UIImage(contentsOfFile: SongSearchArray[songindex].Cover.path)
            SongNameText.text = SongSearchArray[songindex].SongName
            SingerText.text = SongSearchArray[songindex].Singer
            LyricTextView.text = SongSearchArray[songindex].Lyrics
            BackgroundImage.image = UIImage(contentsOfFile: SongSearchArray[songindex].Cover.path)
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


