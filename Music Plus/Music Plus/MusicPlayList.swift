//
//  MusicPlayList.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/9/21.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MusicPlayList:UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

var songs:[String] = []
//var audioPlayer = AVAudioPlayer()
var loadcount = 0;

class TheTest: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = songs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do
        {
            let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
        }
        catch
        {
            print("ERROR")
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        GetSongName()
        // Do any additional setup after loading the view.
    }
    
    func GetSongName()
    {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do
        {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songPath
            {
                var mySong = song.absoluteString
                if mySong.contains(".mp3")
                {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count-1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    
                        songs.append(mySong)
                        loadcount+=1
                }
            }
            
            myTableView.reloadData()
        }
        catch
        {
            
        }
    }
}
