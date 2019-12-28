//
//  TopicListViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/12/4.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


var TopicListSong = [SONG]()
var jsonTopicListObjectArray = [SongInfo]()
var TopicListSongArray = [SONG]()
var ListSetUpBySongId:Array<Int> = Array()
var LikeListArray = [SONG]()
var TopicListCoverImageName:Array<String> = ["ListIdOneCover","ListIdTwoCover","ListIdThreeCover","ListIdFourCover","ListIdFiveCover","ListIdSixCover","ListIdSevenCover","ListIdEightCover","ListIdNineCover", "ListIdTenCover", "ListIdElevenCover", "ListIdTwelveCover"]

var TopicListBackgroundImageName:Array<String> = ["ListIdOneBackground","ListIdTwoBackground","ListIdThreeBackground","ListIdFourBackground","ListIdFiveBackground","ListIdSixBackground","ListIdSevenBackground","ListIdEightBackground","ListIdNineBackground", "ListIdTenBackground", "ListIdElevenBackground", "ListIdTwelveBackground"]


class TopicListViewController: UIViewController{
    var ListArray = [List]()
    
    var timer: Timer?
    
    
    
    @IBOutlet weak var ListOneImage: UIImageView!
    @IBOutlet weak var ListNameOneLabel: UILabel!
    
    @IBOutlet weak var ListTwoImage: UIImageView!
    @IBOutlet weak var ListNameTwoLabel: UILabel!
    
    @IBOutlet weak var TopicNameTitleLabel: UILabel!
    
    var TopicId:Int = 0
    var PostListId:Int = 0
    var PostListName:String = ""
    var TopicName:String = "運動"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TopicNameTitleLabel.text = TopicName
        GetListByTopicId()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        // 讓 navigationController 的背景變成透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func GetListByTopicId()
    {
        
        let parameters:[String:Any] = ["TopicId": TopicId] as! [String:Any]
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/list/topic") else {return}
        
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
                    jsonTopicObjectArray = try JSONDecoder().decode([TopicInfo].self, from: data)
                    print(jsonTopicObjectArray[0].list_id)
                    print(jsonTopicObjectArray[1].list_id)
                    
                }
                catch{
                    print(error)
                }
            }
            self.SetUpList()
        }.resume()
    }
    
    func SetUpList()
    {
        
        for (index, element) in jsonTopicObjectArray.enumerated()
        {
            
            let list_id = jsonTopicObjectArray[index].list_id
            let list_name = jsonTopicObjectArray[index].list_name
            
            ListArray.append(List(TopicId: TopicId, TopicName: "", ListId: list_id, ListName: list_name))
        }
        SetUpListView()
    }
    func SetUpListView()
    {
        DispatchQueue.main.async(){
            self.ListOneImage.image = UIImage(named: TopicListCoverImageName[self.ListArray[0].ListId - 1])
            self.ListTwoImage.image = UIImage(named: TopicListCoverImageName[self.ListArray[1].ListId - 1])
            self.ListNameOneLabel.text = self.ListArray[0].ListName
            self.ListNameTwoLabel.text = self.ListArray[1].ListName
        }
    }
    
    
    @IBAction func PostListIdOne(_ sender: Any) {
        PostListId = ListArray[0].ListId
        PostListName = ListArray[0].ListName
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoTopicListSongSegue", sender: self)
        }
    }
    
    //IntoTopicListSongSegue
    
    @IBAction func PostListIdTwo(_ sender: Any) {
        PostListId = ListArray[1].ListId
        PostListName = ListArray[1].ListName
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoTopicListSongSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TopicListSongViewController
        vc.ListId = PostListId
        vc.ListName = PostListName
        //let vc = segue.destination as! FifthPageViewController
    }
    @IBAction func didUnwindFromListPage(_ sender: UIStoryboardSegue)
    {
        guard let NowListeningSongIndex = sender.source as? TopicListSongViewController else{ return }
        //let  = NowListeningSongIndex.songindex
        //print(selectSongNumber)
        
    }
    
}

class TopicListSongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var LoadingActivityIndicator: UIActivityIndicatorView!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var LoadingView: UIView!
    
    @IBOutlet weak var AddSuccessNotificationLabel: UILabel!
    @IBOutlet weak var TopicListSongTableView: UITableView!
    
    
    @IBOutlet weak var TopicListImage: UIImageView!
    @IBOutlet weak var TopicListNameLabel: UILabel!
    
    var ListId:Int = 0
    var ListName:String = ""
    var SongCount:Int = Int()
    
    /*override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     GetListSongByListId()
     }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        // 讓 navigationController 的背景變成透明
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        SongCount = 0
        
        TopicListNameLabel.text = ListName
        
        var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        //BackgroundImage.addSubview(blurEffectView)
        TopicListImage.image = UIImage(named: TopicListBackgroundImageName[ListId-1])
        TopicListImage.addSubview(blurEffectView)
        
        DispatchQueue.main.async {
            self.AddSuccessNotificationLabel.isHidden = true
            self.TopicListSongTableView.isHidden = true
            // UIView usage
        }
        
        /*activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        LoadingView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()*/
        LoadingActivityIndicator.startAnimating()
        
        GetListSongByListId()
        self.TopicListSongTableView?.delegate = self
        self.TopicListSongTableView?.dataSource = self
    }
    
    func GetListSongByListId()
    {
        print(ListId)
        let parameters:[String:Any] = ["ListId": ListId] as! [String:Any]
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/list/list") else {return}
        
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
                    jsonListObjectArray = try JSONDecoder().decode([ListContent].self, from: data)
                }
                catch{
                    print(error)
                }
            }
            // Json parse 完後將得到的多個 song_id post 給 server 得到 SongInfo
            
            print(jsonListObjectArray)
            ListSetUpBySongId.removeAll()
            for (index, element) in jsonListObjectArray.enumerated()
            {
                ListSetUpBySongId.append(jsonListObjectArray[index].song_id)
            }
            print(ListSetUpBySongId)
            print("start set up topic list song")
            self.SetUpTopicListSong()
            }.resume()
    }
    
    func SetUpTopicListSong()
    {
        
        let parameters:[String:Any] = ["Idlist": ListSetUpBySongId]  as! [String:Any]
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/song/info") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with:  request) {
            (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    jsonTopicListObjectArray = try JSONDecoder().decode([SongInfo].self, from: data)
                    print(jsonTopicListObjectArray)
                    
                    // 以一個array的方式呈現
                    self.SetUpSongs()
                }
                catch {
                    print(error)
                }
            }
            }.resume()
        //}
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline:deadline)
        {
            completion()
        }
    }
    
    func SetUpSongs()
    {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        TopicListSongArray.removeAll()
        TopicListSong.removeAll()
        var time = 0
        for (index, element) in jsonTopicListObjectArray.enumerated() {
            
            let singer = jsonTopicListObjectArray[index].song_artist
            let album = jsonTopicListObjectArray[index].song_album
            
            let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
            
            if jsonTopicListObjectArray[index].song_lyrics == nil
            {
                //print(jsonObjectArray[index].song_id)
                //print(jsonObjectArray[index].song_name)
                jsonTopicListObjectArray[index].song_lyrics = "目前無歌詞"
            }
            
            run(after: time)
            {
            TopicListSong.append(SONG(Id:jsonTopicListObjectArray[index].song_id, Cover: coverPath, Album: jsonTopicListObjectArray[index].song_album, SongName: jsonTopicListObjectArray[index].song_name, Singer: jsonTopicListObjectArray[index].song_artist, Lyrics: jsonTopicListObjectArray[index].song_lyrics ?? "", Category: .Korean, SongPath: coverPath, SongLength: 0))
            //print(jsonTopicListObjectArray[index].song_photo)
            
                self.downloadSongCover(url: jsonTopicListObjectArray[index].song_photo, singer: jsonTopicListObjectArray[index].song_artist, album: jsonTopicListObjectArray[index].song_album)
            }
            time = time + 1
            //self.TopicListSongTableView.reloadData()
        }
        TopicListSong = TopicListSongArray
        //TopicListSongTableView.reloadData()

    }
    var albumPath = String()
    
    func downloadSongCover(url: URL, singer:String, album:String){
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(mainPath)
        let singerPath = mainPath + "/" + singer
        
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
                isDownload = 1
                print("Error downloading file : \(error)")
            }
            DispatchQueue.main.async{
                self.TopicListSongTableView.reloadData()
            }
            self.SongCount = self.SongCount + 1
            print(self.SongCount)
            
            if self.SongCount == 12
            {
                DispatchQueue.main.async{
                    self.TopicListSongTableView.isHidden = false
                    self.LoadingActivityIndicator.stopAnimating()
                }
            }
        }.resume()
    }
    
    @objc func connected(sender: UIButton)
    {
        var isExistInMyList:Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Heart Click")
        let ClickButtonRow = sender.tag
        
        for (index,element) in SongSearchArray.enumerated()
        {
            if SongSearchArray[index].Id == TopicListSong[ClickButtonRow].Id
            {
                isExistInMyList = true
            }
        }
        
        if isExistInMyList == false
        {
            SongSearchArray.append(SONG(Id:TopicListSong[ClickButtonRow].Id, Cover: TopicListSong[ClickButtonRow].Cover, Album: TopicListSong[ClickButtonRow].Album, SongName: TopicListSong[ClickButtonRow].SongName, Singer: TopicListSong[ClickButtonRow].Singer, Lyrics: TopicListSong[ClickButtonRow].Lyrics, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
            SongArray.append(SONG(Id:TopicListSong[ClickButtonRow].Id, Cover: TopicListSong[ClickButtonRow].Cover, Album: TopicListSong[ClickButtonRow].Album, SongName: TopicListSong[ClickButtonRow].SongName, Singer: TopicListSong[ClickButtonRow].Singer, Lyrics: TopicListSong[ClickButtonRow].Lyrics, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
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
    
    // Declare Table View Cell Num
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TopicListSong.count
    }
    // Set Table View DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TopicListSongTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TopicListSongTableViewCell
        
        let coverPath = TopicListSong[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = TopicListSong[indexPath.row].SongName
        cell.SingerCell.text = TopicListSong[indexPath.row].Singer
        cell.LikeHeartButtonCell.tag = indexPath.row
        cell.LikeHeartButtonCell.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    // Set Table View Cell high
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}


class GenreListSongViewController: ViewController, UITableViewDelegate, UITableViewDataSource
{
    var GenreId:Int = 0
    var GenreName:String = ""
    
    @IBOutlet weak var AddSuccessNotificationLabel: UILabel!
    var GenreListSongIdArray:Array<Int> = Array()
    var jsonObjectGenreListArray = [SongInfo]()
    var GenreListSongArray = [SONG]()
    
    
    
    @IBOutlet weak var GenreListSongTableView: UITableView!
    
    
    
    
    @IBOutlet weak var GenreNameLabel: UILabel!
    
    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline:deadline)
        {
            completion()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            GenreNameLabel.text = GenreName
        DispatchQueue.main.async {
            self.GenreListSongTableView.isHidden = true
            self.AddSuccessNotificationLabel.isHidden = true
        }
       
            GenreListSongTableView?.delegate = self
            GenreListSongTableView?.dataSource = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        // 讓 navigationController 的背景變成透明
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    
        self.navigationController?.navigationBar.shadowImage = UIImage()
    
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let parameters:[String:Any] = ["GenreId": GenreId] as! [String:Any]
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/list/genre") else {return}
        
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
                    let json2 = try JSONDecoder().decode(GenreList.self, from: data)
                    print(json2)
                   print(json2.SondList.count)
                    
                    for (index, element) in json2.SondList.enumerated()
                    {
                        self.GenreListSongIdArray.append(Int(json2.SondList[index]) ?? 0)
                    }
                    print(self.GenreListSongIdArray)
                }
                catch{
                    print(error)
                }
            }
            
        }.resume()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        run(after: 1)
        {
            let LoadMusicParameters:[String:Any] = ["Idlist": self.GenreListSongIdArray]  as! [String:Any]
            
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
                        self.jsonObjectGenreListArray = try JSONDecoder().decode([SongInfo].self, from: LoadMusicData)
                        print("====================")
                        print(self.jsonObjectGenreListArray)
                        print("====================")
                        
                        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        
                        for (index, element) in self.jsonObjectGenreListArray.enumerated()
                        {
                            let singer = self.jsonObjectGenreListArray[index].song_artist
                            let album = self.jsonObjectGenreListArray[index].song_album
                            
                            let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
                            
                            if self.jsonObjectGenreListArray[index].song_lyrics == nil
                            {
                                self.jsonObjectGenreListArray[index].song_lyrics = "目前無歌詞"
                            }
                            self.GenreListSongArray.append(SONG(Id: self.jsonObjectGenreListArray[index].song_id, Cover: coverPath, Album: self.jsonObjectGenreListArray[index].song_album, SongName: self.jsonObjectGenreListArray[index].song_name, Singer: self.jsonObjectGenreListArray[index].song_artist, Lyrics: self.jsonObjectGenreListArray[index].song_lyrics ?? "", Category: .Korean, SongPath: coverPath, SongLength: 0))
                            //downloadSongCover(url: jsonObjectArray[index].song_photo, singer: jsonObjectArray[index].song_artist, album: jsonObjectArray[index].song_album)
                        }
                        print(self.GenreListSongArray.count)
                    }
                    catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(RecommendListLoad == false)
        {
            run(after: 4)
            {
                self.GenreListSongTableView.reloadData()
                DispatchQueue.main.async {
                    self.GenreListSongTableView.isHidden = false
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
        
        for (index,element) in SongSearchArray.enumerated()
        {
            if SongSearchArray[index].Id == GenreListSongArray[ClickButtonRow].Id
            {
                isExistInMyList = true
            }
        }
        
        if isExistInMyList == false
        {
            SongSearchArray.append(SONG(Id:GenreListSongArray[ClickButtonRow].Id, Cover: GenreListSongArray[ClickButtonRow].Cover, Album: GenreListSongArray[ClickButtonRow].Album, SongName: GenreListSongArray[ClickButtonRow].SongName, Singer: GenreListSongArray[ClickButtonRow].Singer, Lyrics: GenreListSongArray[ClickButtonRow].Lyrics, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
            SongArray.append(SONG(Id:GenreListSongArray[ClickButtonRow].Id, Cover: GenreListSongArray[ClickButtonRow].Cover, Album: GenreListSongArray[ClickButtonRow].Album, SongName: GenreListSongArray[ClickButtonRow].SongName, Singer: GenreListSongArray[ClickButtonRow].Singer, Lyrics: GenreListSongArray[ClickButtonRow].Lyrics, Category: .Korean, SongPath: documentDirectory, SongLength: 23))
            
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
        return GenreListSongArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell = GenreListSongTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TopicListSongTableViewCell
        
        let coverPath = GenreListSongArray[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = GenreListSongArray[indexPath.row].SongName
        cell.SingerCell.text = GenreListSongArray[indexPath.row].Singer*/
        
        let cell = GenreListSongTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TopicListSongTableViewCell
        
        let coverPath = GenreListSongArray[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = GenreListSongArray[indexPath.row].SongName
        cell.SingerCell.text = GenreListSongArray[indexPath.row].Singer
        cell.LikeHeartButtonCell.tag = indexPath.row
        cell.LikeHeartButtonCell.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


class List {
    let TopicId:Int
    let TopicName:String
    let ListId: Int
    let ListName: String
    
    init(TopicId: Int, TopicName:String, ListId: Int, ListName: String)
    {
        self.TopicId = TopicId
        self.TopicName = TopicName
        self.ListId = ListId
        self.ListName = ListName
    }
}

