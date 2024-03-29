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

var RecommendListLoad: Bool = false
var FindKey:String = ""

// HomePage 旗下子頁面跳轉使用
class HomePage: UIViewController{
    @IBOutlet weak var RankButton: UIButton!
    @IBOutlet weak var RecommendButton: UIButton!
    @IBOutlet weak var FindButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RankButton.setTitleColor(UIColor.orange, for: .normal)
        RankButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
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

// 排行榜
class HomePVCRank: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// 個人推薦
class HomePVCRecommend: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var LoadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SongRecommendTitleLabel: UILabel!
    @IBOutlet weak var SongRecommendTableView: UITableView!
    
    @IBOutlet weak var AddSuccessNotificationLabel: UILabel!
    var SongRecommendArray:Array<Int> = Array()
    var jsonObjectRecommendArray = [SongInfo]()
    var MySongRecommendArray = [SONG]()
    
    // 在開啟頁面時，傳送登入時取得的 UserId 給後端來取得個人推薦的 20 首 SongId
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingActivityIndicator.startAnimating()
        SongRecommendTitleLabel.text = UserNickName
        if(RecommendListLoad == false)
        {
            DispatchQueue.main.async {
                self.SongRecommendTableView.isHidden = true
                self.AddSuccessNotificationLabel.isHidden = true
            }
            
            SongRecommendTableView?.delegate = self
            SongRecommendTableView?.dataSource = self
            
            let parameters:[String:Any] = ["UserId": UserId] as! [String:Any]
            
            guard let url = URL(string: "http://140.136.149.239:3000/musicplus/recommend/personal") else {return}
            
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
                        
                        let json2 = try JSONDecoder().decode(MyRecommend.self, from: data)
                        print(json2)
                        self.SongRecommendArray.removeAll()
                        for (index, element) in json2.Recommend_list.enumerated()
                        {
                            self.SongRecommendArray.append(Int(json2.Recommend_list[index]) ?? 0)
                        }
                        print(self.SongRecommendArray)
                        RecommendListLoad = true
                    }
                    catch{
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline:deadline)
        {
            completion()
        }
    }
    
    // 取得的SongId存成陣列後在傳給後端，取得這些歌曲的資訊並設置完成
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(RecommendListLoad == false)
        {
            run(after: 1)
            {
                self.MySongRecommendArray.removeAll()
                let LoadMusicParameters:[String:Any] = ["Idlist": self.SongRecommendArray]  as! [String:Any]
                
                guard let LoadMusicUrl = URL(string: "http://140.136.149.239:3000/musicplus/song/info") else {return}
                
                var LoadMusicRequest = URLRequest(url: LoadMusicUrl)
                LoadMusicRequest.httpMethod = "POST"
                LoadMusicRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                guard let LoadMusicHttpBody = try? JSONSerialization.data(withJSONObject: LoadMusicParameters, options: []) else {return}
                
                LoadMusicRequest.httpBody = LoadMusicHttpBody
                
                let LoadMusicSession = URLSession.shared
                LoadMusicSession.dataTask(with:  LoadMusicRequest) {
                    (LoadMusicData, LoadMusicResponse, LoadMusicError) in
                    if let LoadMusicResponse = LoadMusicResponse {
                        print(LoadMusicResponse)
                    }
                    
                    if let LoadMusicData = LoadMusicData {
                        do {
                            let LoadMusicJson = try JSONSerialization.jsonObject(with: LoadMusicData, options: [])
                            
                            print(LoadMusicJson)
                            self.jsonObjectRecommendArray = try JSONDecoder().decode([SongInfo].self, from: LoadMusicData)
                            print("====================")
                            print(self.jsonObjectRecommendArray)
                            print("====================")
                            
                            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            
                            for (index, element) in self.jsonObjectRecommendArray.enumerated()
                            {
                                let singer = self.jsonObjectRecommendArray[index].song_artist
                                let album = self.jsonObjectRecommendArray[index].song_album
                                
                                let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
                                
                                if self.jsonObjectRecommendArray[index].song_lyrics == nil
                                {
                                    self.jsonObjectRecommendArray[index].song_lyrics = "目前無歌詞"
                                }
                                self.MySongRecommendArray.append(SONG(Id: self.jsonObjectRecommendArray[index].song_id, Cover: coverPath, Album: self.jsonObjectRecommendArray[index].song_album, SongName: self.jsonObjectRecommendArray[index].song_name, Singer: self.jsonObjectRecommendArray[index].song_artist, Lyrics: self.jsonObjectRecommendArray[index].song_lyrics ?? "", Category: .Korean, SongPath: coverPath, SongLength: 0))
                                
                                print(self.MySongRecommendArray[index].SongName)
                                print(self.MySongRecommendArray[index].Id)
                            }
                            print(self.MySongRecommendArray.count)
                        }
                        catch {
                            print(error)
                        }
                    }
                }.resume()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(RecommendListLoad == false)
        {
            run(after: 2)
            {
                self.SongRecommendTableView.reloadData()
                DispatchQueue.main.async {
                    self.LoadingActivityIndicator.stopAnimating()
                    self.LoadingActivityIndicator.isHidden = true
                    self.SongRecommendTableView.isHidden = false
                }
            }
        }
    }
    
    @objc func connected(sender: UIButton)
    {
        var isExistInMyList:Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Heart Click")
        let ClickButtonRow = sender.tag
        print(MySongRecommendArray[ClickButtonRow].SongName)
        print(MySongRecommendArray[ClickButtonRow].Id)
        print(MySongRecommendArray[ClickButtonRow].Singer)
        
        for (index,element) in SongSearchArray.enumerated()
        {
            if SongSearchArray[index].Id == MySongRecommendArray[ClickButtonRow].Id
            {
                isExistInMyList = true
            }
        }
        
        if isExistInMyList == false
        {
            SongSearchArray.append(SONG(Id:MySongRecommendArray[ClickButtonRow].Id, Cover: MySongRecommendArray[ClickButtonRow].Cover, Album: MySongRecommendArray[ClickButtonRow].Album, SongName: MySongRecommendArray[ClickButtonRow].SongName, Singer: MySongRecommendArray[ClickButtonRow].Singer, Lyrics: MySongRecommendArray[ClickButtonRow].Lyrics, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
            SongArray.append(SONG(Id:MySongRecommendArray[ClickButtonRow].Id, Cover: MySongRecommendArray[ClickButtonRow].Cover, Album: MySongRecommendArray[ClickButtonRow].Album, SongName: MySongRecommendArray[ClickButtonRow].SongName, Singer: MySongRecommendArray[ClickButtonRow].Singer, Lyrics: MySongRecommendArray[ClickButtonRow].Lyrics, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
            DispatchQueue.main.async {
                self.AddSuccessNotificationLabel.isHidden = false
                // UIView usage
            }
            
            let parameters:[String:Any] = ["UserId": UserId, "SongId": SongArray[SongArray.count - 1].Id] as! [String:Any]
            
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
        else
        {
            print(" 主題歌單 此歌曲已經新增至個人歌單中")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MySongRecommendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SongRecommendTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! PersonalRecommendCell
        
        let coverPath = MySongRecommendArray[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = MySongRecommendArray[indexPath.row].SongName
        cell.SingerCell.text = MySongRecommendArray[indexPath.row].Singer
        cell.LikeHeartButtonCell.tag = indexPath.row
        cell.LikeHeartButtonCell.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

var jsonSongFindObjectArray = [SongFindWithKey]()
var SongFindArray = [SONGFIND]()
var SongFindShowArray = [SONGFIND]()


// 搜尋歌曲頁面
class HomePVCFind: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let tmp:String = "搜尋："
    var KeyString:String = ""
    
    var KeyStringTmp:String = String()
    
    @IBOutlet weak var FindKeyLabel: UILabel!
    
    @IBOutlet weak var SongFindKeyTextField: UITextField!
    @IBOutlet weak var SongFindWithKeyTableView: UITableView!
    @IBOutlet weak var AddSuccessNotificationLabel: UILabel!
    
    @IBOutlet weak var SongFindRecordTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        SongFindWithKeyTableView?.delegate = self
        SongFindWithKeyTableView?.dataSource = self
        KeyStringTmp = tmp + KeyString
        FindKeyLabel.text = KeyStringTmp
        DispatchQueue.main.async {
            self.AddSuccessNotificationLabel.isHidden = true
        }
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
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = documentDirectory?.appendingPathComponent("SearchRecord.txt") else { return  }
        
        // 將搜尋的字加上換行寫入SearchRecord.txt檔案中
        guard let tmp = SongFindKeyTextField.text else { return }
        let text = tmp + "\n"
        let record = text ?? ""
        
        do{
            let fileUpdater = try FileHandle(forUpdating: fileURL)
            // 移至檔案最後加入新的搜尋關鍵字
            fileUpdater.seekToEndOfFile()
            fileUpdater.write(record.data(using: .utf8)!)
            fileUpdater.closeFile()
        
            print("Write Successful")
        }
        catch
        {
            print("Write Error")
        }
    }
    
    // 暫停使用，此功能移植到 HomePVCRecord
    func SetUpSongFindWithKey()
    {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for (index, element) in jsonSongFindObjectArray.enumerated()
        {
            let singer = jsonSongFindObjectArray[index].song_artist
            let album = jsonSongFindObjectArray[index].song_album
            let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
            
            if jsonSongFindObjectArray[index].song_lyrics == nil
            {
                jsonSongFindObjectArray[index].song_lyrics = "目前無歌詞"
            }
            
            SongFindArray.append(SONGFIND(Id: jsonSongFindObjectArray[index].song_id, Cover: coverPath, Lyric: jsonSongFindObjectArray[index].song_lyrics ?? "", SongName: jsonSongFindObjectArray[index].song_name, Singer: jsonSongFindObjectArray[index].song_artist, Album: jsonSongFindObjectArray[index].song_album))
            
            downloadSongCover(url: jsonSongFindObjectArray[index].song_photo, singer: jsonSongFindObjectArray[index].song_artist, album: jsonSongFindObjectArray[index].song_album)
        }
        SongFindShowArray = SongFindArray
        DispatchQueue.main.async(){            self.SongFindWithKeyTableView.reloadData()
        }
    }
    
    var albumPath = String()
    
    func downloadSongCover(url: URL, singer:String, album:String){
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let singerPath = mainPath + "/" + singer
        
        let TestCoverPath = mainPath + "/" + singer + "/" + album + "/cover.jpg"
        
        let CoverIsExit = FileManager.default.fileExists(atPath: TestCoverPath)
        
        if CoverIsExit == false
        {
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
    
    // 點擊愛心的觸發事件
    @objc func connected(sender: UIButton)
    {
        var isExistInMyList:Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Heart Click")
        let ClickButtonRow = sender.tag
        print(SongFindShowArray[ClickButtonRow].Id)
            print(SongFindShowArray[ClickButtonRow].SongName)
        print(SongSearchArray.enumerated())
        for (index,element) in SongSearchArray.enumerated()
        {
            if SongSearchArray[index].Id == SongFindShowArray[ClickButtonRow].Id
            {
                    isExistInMyList = true
            }
        }
       
        if isExistInMyList == false
        {
        SongSearchArray.append(SONG(Id:SongFindShowArray[ClickButtonRow].Id, Cover: SongFindShowArray[ClickButtonRow].Cover, Album: SongFindShowArray[ClickButtonRow].Album, SongName: SongFindShowArray[ClickButtonRow].SongName, Singer: SongFindShowArray[ClickButtonRow].Singer, Lyrics: SongFindShowArray[ClickButtonRow].Lyric, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
        SongArray.append(SONG(Id:SongFindShowArray[ClickButtonRow].Id, Cover: SongFindShowArray[ClickButtonRow].Cover, Album: SongFindShowArray[ClickButtonRow].Album, SongName: SongFindShowArray[ClickButtonRow].SongName, Singer: SongFindShowArray[ClickButtonRow].Singer, Lyrics: SongFindShowArray[ClickButtonRow].Lyric, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
            DispatchQueue.main.async {
                self.AddSuccessNotificationLabel.isHidden = false
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
        else
        {
            print("此歌曲已經新增至個人歌單中")
        }
        
        
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


// 搜尋紀錄字串所存陣列
var RecordStringArray:Array<String> = Array()

// 搜尋紀錄頁面
class HomePVCRecord: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    // 判斷搜尋的 Key String 是來在點選 Table View 還是使用者輸入的 Text Field
    var PostFromTextField:Bool = false
    var SelectRow:Int = 0
    
    @IBOutlet weak var SongFindRecordTableView: UITableView!
    @IBOutlet weak var SongFindKeyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = documentDirectory?.appendingPathComponent("SearchRecord.txt") else { return  }
        
        // 將搜尋的字加上換行寫入SearchRecord.txt檔案中
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            print(text2)
            RecordStringArray = text2.components(separatedBy: "\n")
            RecordStringArray.remove(at: RecordStringArray.count - 1)
            print(RecordStringArray)
            
        }
        catch{
            print("Read error")
        }
        
        SongFindRecordTableView?.delegate = self
        SongFindRecordTableView?.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecordStringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SongFindRecordTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SongFindRecordCell
        cell.RecordStringCell.text = RecordStringArray[(RecordStringArray.count - indexPath.row - 1)]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PostFromTextField = false
        SelectRow = indexPath.row
        SongFindArray.removeAll()
        SongFindShowArray.removeAll()
        
        let parameters:[String:Any] = ["key_str": RecordStringArray[(RecordStringArray.count - indexPath.row - 1)]] as! [String:Any]
        
        
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
    
    var CheckTextInSearchRecordFile:Bool = false
    var SameKeyInSearchRecordFileRow:Int = 0
    
    @IBAction func PostKeyStringToDB(_ sender: Any) {
        PostFromTextField = true
        
        SongFindArray.removeAll()
        SongFindShowArray.removeAll()
        
        let parameters:[String:Any] = ["key_str": self.SongFindKeyTextField.text] as! [String:Any]
        
        FindKey = self.SongFindKeyTextField.text!
        print("Test FindKey", FindKey)
        
        
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
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = documentDirectory?.appendingPathComponent("SearchRecord.txt") else { return  }
        
        // 將搜尋的字加上換行寫入SearchRecord.txt檔案中
        guard let tmp = SongFindKeyTextField.text else { return }
        let text = tmp + "\n"
        let record = text ?? ""
        
        do{
            let fileUpdater = try FileHandle(forUpdating: fileURL)
            // 移至檔案最後加入新的搜尋關鍵字
            //fileUpdater.seek(toFileOffset: 0)
            //fileUpdater.seekToEndOfFile()
            
            for (index, element) in RecordStringArray.enumerated()
            {
                if RecordStringArray[index] == SongFindKeyTextField.text
                {
                    CheckTextInSearchRecordFile = true
                    SameKeyInSearchRecordFileRow = index
                }
            }
            
            // 若沒有搜尋過之前找過的，就寫入檔案並重載入Table
            if CheckTextInSearchRecordFile == false
            {
                fileUpdater.seekToEndOfFile()
                fileUpdater.write(record.data(using: .utf8)!)
                RecordStringArray.append(tmp)
                SongFindRecordTableView.reloadData()
                SongFindKeyTextField.text = ""
            }
            
            fileUpdater.closeFile()
            print("Write Successful")
        }
        catch
        {
            print("Write Error")
        }
    }
    
    // 設置利用搜尋的 Key 所得到的所有歌曲資訊
    func SetUpSongFindWithKey()
    {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for (index, element) in jsonSongFindObjectArray.enumerated()
        {
            let singer = jsonSongFindObjectArray[index].song_artist
            let album = jsonSongFindObjectArray[index].song_album
            let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
            
            if jsonSongFindObjectArray[index].song_lyrics == nil
            {
                jsonSongFindObjectArray[index].song_lyrics = "目前無歌詞"
            }
            
            SongFindArray.append(SONGFIND(Id: jsonSongFindObjectArray[index].song_id, Cover: coverPath, Lyric: jsonSongFindObjectArray[index].song_lyrics ?? "", SongName: jsonSongFindObjectArray[index].song_name, Singer: jsonSongFindObjectArray[index].song_artist, Album: jsonSongFindObjectArray[index].song_album))
            
            downloadSongCover(url: jsonSongFindObjectArray[index].song_photo, singer: jsonSongFindObjectArray[index].song_artist, album: jsonSongFindObjectArray[index].song_album)
        }
        SongFindShowArray = SongFindArray
        print(SongFindShowArray)
        print(SongFindShowArray.count)
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "FindSongWithKeySegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HomePVCFind
        // 搜尋關鍵字來自點擊 Table View Row
        if PostFromTextField == false
        {
            vc.KeyString = RecordStringArray[(RecordStringArray.count - SelectRow - 1)]
            FindKey = RecordStringArray[(RecordStringArray.count - SelectRow - 1)]
        }
        // 搜尋關鍵字來自使用者自行輸入的 TextField
        if PostFromTextField == true
        {
            print(SongFindKeyTextField.text)
            vc.KeyString = FindKey

            print("FindKey"+FindKey)
        }
    }
    
    var albumPath = String()
    
    func downloadSongCover(url: URL, singer:String, album:String){
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let singerPath = mainPath + "/" + singer
        
        let TestCoverPath = mainPath + "/" + singer + "/" + album + "/cover.jpg"
        
        let CoverIsExit = FileManager.default.fileExists(atPath: TestCoverPath)
        
        if CoverIsExit == false
        {
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
}

class SONGFIND {
    let Id: Int
    let Cover: URL
    let Lyric: String
    let SongName: String
    let Singer: String
    let Album: String
    
    init(Id: Int, Cover: URL, Lyric: String, SongName: String, Singer: String, Album: String)
    {
        self.Id = Id
        self.Cover = Cover
        self.Lyric = Lyric
        self.SongName = SongName
        self.Singer = Singer
        self.Album = Album
    }
}
