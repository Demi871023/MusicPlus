//
//  HomePage.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/10/3.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit
import Charts

//var jsonSongFindObjectArray = [SongFindWithKey]()

//var SongFindWithKey = [SONG_FIND_WITH_KEY]()



class HomePage: UIViewController{
    
    
    @IBOutlet weak var RankButton: UIButton!
    @IBOutlet weak var RecommendButton: UIButton!
    @IBOutlet weak var FindButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RankButton.setTitleColor(UIColor.orange, for: .normal)
        RankButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        
        //GetSongName()
        // Do any additional setup after loading the view.
    }
    
    
    var CenterPVC:HomePVC!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "HomePVCSegue")
        {
            if(segue.destination.isKind(of: HomePVC.self))
            {
                CenterPVC = segue.destination as? HomePVC
            }
        }
    }
    @IBAction func HomePageFirst(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 0)
        RankButton.setTitleColor(UIColor.orange, for: .normal)
        RankButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        RecommendButton.setTitleColor(UIColor.white, for: .normal)
        RecommendButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        FindButton.setTitleColor(UIColor.white, for: .normal)
        FindButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
    }
    
    @IBAction func HomePageSecond(_ sender: Any) {
        
        CenterPVC.setViewControllerFromIndex(index: 1)
        RankButton.setTitleColor(UIColor.white, for: .normal)
        RankButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        RecommendButton.setTitleColor(UIColor.orange, for: .normal)
        RecommendButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        FindButton.setTitleColor(UIColor.white, for: .normal)
        FindButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
    }
    
    
    @IBAction func HomePageThird(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 2)
        RankButton.setTitleColor(UIColor.white, for: .normal)
        RankButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        RecommendButton.setTitleColor(UIColor.white, for: .normal)
        RecommendButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        FindButton.setTitleColor(UIColor.orange, for: .normal)
        FindButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
    }
}

class HomePVCRank: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

class HomePVCRecommend: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

var jsonSongFindObjectArray = [SongFindWithKey]()
var SongFindArray = [SONGFIND]()
var SongFindShowArray = [SONGFIND]()

class HomePVCFind: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var SongFindKeyTextField: UITextField!
    
    @IBOutlet weak var SongFindWithKeyTableView: UITableView!
    
    @IBOutlet weak var AddSuccessNotificationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SongFindWithKeyTableView?.delegate = self
        SongFindWithKeyTableView?.dataSource = self
        
        DispatchQueue.main.async {
            self.AddSuccessNotificationLabel.isHidden = true
            // UIView usage
        }

        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func PostFindString(_ sender: Any) {
        
        SongFindArray.removeAll()
        SongFindShowArray.removeAll()
        
        let parameters:[String:Any] = ["key_str": self.SongFindKeyTextField.text] as! [String:Any]
        
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/song/find") else {return}
        
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
                    
                    jsonSongFindObjectArray = try JSONDecoder().decode([SongFindWithKey].self, from: data)
                    self.SetUpSongFindWithKey()
                    print(SongFindArray)
                }
                catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    func SetUpSongFindWithKey()
    {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for (index, element) in jsonSongFindObjectArray.enumerated()
        {
            let singer = jsonSongFindObjectArray[index].song_artist
            let album = jsonSongFindObjectArray[index].song_album
            //let album = "句號"
            let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
            SongFindArray.append(SONGFIND(Id: jsonSongFindObjectArray[index].song_id, Cover: coverPath, SongName: jsonSongFindObjectArray[index].song_name, Singer: jsonSongFindObjectArray[index].song_artist, Album: jsonSongFindObjectArray[index].song_album))
            
            downloadSongCover(url: jsonSongFindObjectArray[index].song_photo, singer: jsonSongFindObjectArray[index].song_artist, album: jsonSongFindObjectArray[index].song_album)
        }
        SongFindShowArray = SongFindArray
        DispatchQueue.main.async(){            self.SongFindWithKeyTableView.reloadData()
        }
    }
    
    var albumPath = String()
    
    func downloadSongCover(url: URL, singer:String, album:String){
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //print(mainPath)
        let singerPath = mainPath + "/" + singer
        
        let TestCoverPath = mainPath + "/" + singer + "/" + album + "/cover.jpg"
        
        let CoverIsExit = FileManager.default.fileExists(atPath: TestCoverPath)
        
        if CoverIsExit == false
        {
            //var directoryforsinger:ObjCBool = true
            let singerIsExit = FileManager.default.fileExists(atPath: singerPath)
            
            if singerIsExit == false
            {
                do{
                    try FileManager.default.createDirectory(atPath: singerPath, withIntermediateDirectories: true, attributes: nil)
                }catch
                {
                    print("error")
                }
            }
            
            albumPath = singerPath + "/" + album
            let albumIsExit = FileManager.default.fileExists(atPath: albumPath)
            if albumIsExit == false
            {
                do{
                    try FileManager.default.createDirectory(atPath: albumPath, withIntermediateDirectories: true, attributes: nil)
                }
                catch
                {
                    print("error")
                }
            }
            
            let downloadRequest = URLRequest(url: url)
            URLSession.shared.downloadTask(with: downloadRequest) { location, response, error in
                guard  let tempLocation = location, error == nil else { return }
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let targetDirectory = documentDirectory.appendingPathComponent(singer+"/"+album)
                do {
                    let fullURL = try targetDirectory.appendingPathComponent((response?.suggestedFilename!)!)
                    let coverIsExit = FileManager.default.fileExists(atPath: self.albumPath+"/cover.jpg")
                    if coverIsExit == false
                    {
                        print(fullURL)
                        try FileManager.default.moveItem(at: tempLocation, to: fullURL)
                        print("saved at \(fullURL) \n")
                    }
                    
                }catch CocoaError.fileReadNoSuchFileError {
                    print("No such file")
                } catch {
                    // other errors
                    isDownload = 1
                    print("Error downloading file : \(error)")
                }
            }.resume()
        }
        
        
    }
    
    @objc func connected(sender: UIButton)
    {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Heart Click")
        let ClickButtonRow = sender.tag
        
        SongSearchArray.append(SONG(Id:SongFindShowArray[ClickButtonRow].Id, Cover: SongFindShowArray[ClickButtonRow].Cover, Album: SongFindShowArray[ClickButtonRow].Album, SongName: SongFindShowArray[ClickButtonRow].SongName, Singer: SongFindShowArray[ClickButtonRow].Singer, Lyrics: "目前無歌詞", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
        
        SongArray.append(SONG(Id:SongFindShowArray[ClickButtonRow].Id, Cover: SongFindShowArray[ClickButtonRow].Cover, Album: SongFindShowArray[ClickButtonRow].Album, SongName: SongFindShowArray[ClickButtonRow].SongName, Singer: SongFindShowArray[ClickButtonRow].Singer, Lyrics: "目前無歌詞", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
        
        DispatchQueue.main.async {
            self.AddSuccessNotificationLabel.isHidden = false
            // UIView usage
        }
        
        let parameters:[String:Any] = ["UserId": UserId, "SongId": SongFindShowArray[ClickButtonRow].Id] as! [String:Any]
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/addsong") else {return}
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Declare Table View Cell Num
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongFindShowArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SongFindWithKeyTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SongFindTableViewCell
        
        let coverPath = SongFindShowArray[indexPath.row].Cover.path
        
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = SongFindShowArray[indexPath.row].SongName
        cell.SingerCell.text = SongFindShowArray[indexPath.row].Singer
        cell.LikeHeartButtonCell.tag = indexPath.row
        cell.LikeHeartButtonCell.addTarget(self, action:  #selector(connected(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

class SONGFIND {
    let Id: Int
    let Cover: URL
    //let Album: String
    let SongName: String
    let Singer: String
    let Album: String
    //let Category: SongType
    //var SongPath: URL
    //var SongLength: Double
    
    init(Id: Int, Cover: URL, SongName: String, Singer: String, Album: String)
    {
        self.Id = Id
        self.Cover = Cover
        //self.Album = Album
        self.SongName = SongName
        self.Singer = Singer
        self.Album = Album
        //self.Category = Category
        //self.SongPath = SongPath
        //self.SongLength = SongLength
    }
}
