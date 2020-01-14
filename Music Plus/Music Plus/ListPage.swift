//
//  ListPage.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/10/3.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var isDownload = 0
var SongHaveNumber:Int = 0

struct SongDownload: Decodable{
    let song_address: URL
}

var audioPlayer = AVAudioPlayer()
var SongArray = [SONG]()
var SongSearchArray = [SONG]()
//var audioPlayer2 = AVAudioPlayer()
var jsonObjectArray = [SongInfo]()
var jsonTopicObjectArray = [TopicInfo]()
var jsonListObjectArray = [ListContent]()

var selectSongNumber: Int = 0
var MyListSongId:Array<Int> = Array()


protocol FetchSelectRow {
    func fetchInt(rowNumber:Int)
}

protocol SelectedCollectionItemDelegate {
    func selectedCollectionItem(index:Int)
}

// ListPage 旗下有 ListPVCPersonal、ListPVCTheme
class ListPage: UIViewController{
    
    @IBOutlet weak var PersonalListButton: UIButton!
    @IBOutlet weak var ThemeListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersonalListButton.setTitleColor(UIColor.orange, for: .normal)
        PersonalListButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
    }
    
    var CenterPVC: ListPVC!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "ListPVCSegue")
        {
            if(segue.destination.isKind(of: ListPVC.self))
            {
                CenterPVC = segue.destination as? ListPVC
            }
        }
    }
    
    @IBAction func ListPageFirst(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 0)
        PersonalListButton.setTitleColor(UIColor.orange, for: .normal)
        PersonalListButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        ThemeListButton.setTitleColor(UIColor.white, for: .normal)
        ThemeListButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
    }
    
    @IBAction func ListPageSecond(_ sender: Any) {
        CenterPVC.setViewControllerFromIndex(index: 1)
        PersonalListButton.setTitleColor(UIColor.white, for: .normal)
        PersonalListButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        ThemeListButton.setTitleColor(UIColor.orange, for: .normal)
        ThemeListButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
    }
}

// 個人歌單頁面
class ListPVCPersonal: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    var refresher: UIRefreshControl!
    
    @IBOutlet weak var MusicListSearchBar: UISearchBar!
    @IBOutlet weak var MusicListTableView: UITableView!
    @IBOutlet weak var NowPlayingUIView: UIView!
    @IBOutlet weak var NowPlayingCoverImage: UIImageView!
    @IBOutlet weak var NowPlayingSongNameText: UILabel!
    @IBOutlet weak var NowPlayingSingerText: UILabel!
    @IBOutlet weak var NowPlayingPlayButton: UIButton!
    @IBOutlet weak var NowPlayingUpButton: UIButton!
    @IBOutlet weak var NowPlayingNextButton: UIButton!
    
    
    @IBOutlet weak var EditMusicListTableViewButton: UIButton!
    
    var delegate: FetchSelectRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetMyMusicListByUserId()
        
        MusicListTableView?.estimatedRowHeight = 0
        MusicListTableView?.delegate = self
        MusicListTableView?.dataSource = self
        SetUpSongSearch()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Reload List")
        refresher.addTarget(self, action: #selector(ListPVCPersonal.RefreshList), for: UIControl.Event.valueChanged)
        MusicListTableView.addSubview(refresher)
        NowPlayingPlayButton.isSelected = true

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func RefreshList()
    {
        let tmp = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        SongHaveNumber = SongArray.count
        refresher.endRefreshing()
        MusicListTableView.reloadData()
    }
    
    @IBAction func didUnwindFromNowListeningPage(_ sender: UIStoryboardSegue)
    {
        guard let NowListeningSongIndex = sender.source as? FifthPageViewController else{ return }
        selectSongNumber = NowListeningSongIndex.songindex
        print(selectSongNumber)
        
        NowPlayingSongNameText.text = SongSearchArray[selectSongNumber].SongName
        NowPlayingSingerText.text = SongSearchArray[selectSongNumber].Singer
        NowPlayingCoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
        
    }
    
    func GetMyMusicListByUserId()
    {
        
        let parameters:[String:Any] = ["UserId": UserId]  as! [String:Any]
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/getlist") else {return}
        
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
                    
                    let json2 = try JSONDecoder().decode(MyList.self, from: data)
                    let pl = json2.personal_list
                    
                    for (index,element) in pl.enumerated()
                    {
                        MyListSongId.append(Int(pl[index]) ?? 0)
                    }
                    
                    //[1,3,4]
                    print(MyListSongId)
                }
                catch {
                    print(error)
                }
            }
            self.LoadMusic()
        }.resume()
    }
    
    func LoadMusic()
    {
        if MyListSongId.count != 0
        {
            
        }
        let LoadMusicParameters:[String:Any] = ["Idlist": MyListSongId]  as! [String:Any]
        
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
                    jsonObjectArray = try JSONDecoder().decode([SongInfo].self, from: LoadMusicData)
                    print("====================")
                    print(jsonObjectArray)
                    print("====================")
                    
                    self.SetUpSongs()
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    // Set up Songs Information
    private func SetUpSongs()
    {
        SongArray.removeAll()
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for (index, element) in jsonObjectArray.enumerated() {
            
            let singer = jsonObjectArray[index].song_artist
            let album = jsonObjectArray[index].song_album
            
            let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
            
            if jsonObjectArray[index].song_lyrics == nil
            {
                jsonObjectArray[index].song_lyrics = "目前無歌詞"
            }
            
            SongArray.append(SONG(Id: jsonObjectArray[index].song_id, Cover: coverPath, Album: jsonObjectArray[index].song_album, SongName: jsonObjectArray[index].song_name, Singer: jsonObjectArray[index].song_artist, Lyrics: jsonObjectArray[index].song_lyrics ?? "", Category: .Korean, SongPath: coverPath, SongLength: 0))
            print(jsonObjectArray[index].song_photo)
            print("\n")
            
            downloadSongCover(url: jsonObjectArray[index].song_photo, singer: jsonObjectArray[index].song_artist, album: jsonObjectArray[index].song_album)
    
        }
        SongSearchArray = SongArray
        SongHaveNumber = SongArray.count
        print(SongHaveNumber)
        DispatchQueue.main.async{
            self.MusicListTableView.reloadData()
        }
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
                // other errors
                isDownload = 1
                print("Error downloading file : \(error)")
            }
        }.resume()
    }
    
    private func SetUpSongSearch()
    {
        MusicListSearchBar?.delegate = self
    }

    @IBAction func ButtomMusicPlayTapped(sender:UIButton)
    {
        if(sender.isSelected)
        {
            sender.isSelected = false
            print("Music pause")
            audioPlayer.pause()
        }
        else
        {
            sender.isSelected = true
            print("Music play")
            audioPlayer.play()
        }
    }
    
    
    @IBAction func NextSong(_ sender: Any) {
        
        if(selectSongNumber + 1 == SongHaveNumber)
        {
            print("已經是最後一首！")
        }
        else
        {
            NowPlayingPlayButton.isSelected = true
            selectSongNumber = selectSongNumber + 1
            
            let singer = SongSearchArray[selectSongNumber].Singer
            let album = SongSearchArray[selectSongNumber].Album
            let song = SongSearchArray[selectSongNumber].SongName
            
            NowPlayingSongNameText.text = song
            NowPlayingSingerText.text = singer
            NowPlayingCoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
            
            let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                audioPlayer.play()
            }
            catch{
                
            }
        }
        
        
    }
    
    @IBAction func PreSong(_ sender: Any) {
        
        if(selectSongNumber - 1 < 0)
        {
            print("已經沒有前面一首！！！")
        }
        else
        {
            NowPlayingPlayButton.isSelected = true
            
            selectSongNumber = selectSongNumber - 1
            
            let singer = SongSearchArray[selectSongNumber].Singer
            let album = SongSearchArray[selectSongNumber].Album
            let song = SongSearchArray[selectSongNumber].SongName
            
            NowPlayingSongNameText.text = song
            NowPlayingSingerText.text = singer
            NowPlayingCoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
            
            let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                audioPlayer.play()
            }
            catch{
                
            }
        }
        
    }
    
    // MusicListTableView
    @IBAction func EditMusicListTableView(_ sender: Any) {
        MusicListTableView.isEditing = !MusicListTableView.isEditing
        
        switch MusicListTableView.isEditing{
        case true:
            EditMusicListTableViewButton.setTitle("done", for:.normal)
        case false:
            EditMusicListTableViewButton.setTitle("edit", for: .normal)
            
        }
    }
    
    @IBAction func ShowNowPlayingView(_sender : Any){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "PlayMusicFromPVCPersonalSegue", sender: self)
        }
    }
    
    // Table View Data Information
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     
     // Declare Table View Cell Num
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongSearchArray.count
    }
     // Set Table View DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MusicListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SongsTableViewCell
     
        let coverPath = SongSearchArray[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = SongSearchArray[indexPath.row].SongName
        cell.SingerCell.text = SongSearchArray[indexPath.row].Singer
     
        return cell
    }
    
    func PostUserIdCountFrequenct()
    {
        
        print("Yes")
        let parameters:[String:Any] = ["Userid": UserId] as! [String:Any]
        
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/fre") else {return}
        
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
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            let parameters:[String:Any] = ["UserId": UserId, "SongId": SongSearchArray[indexPath.row].Id] as! [String:Any]
            
            SongSearchArray.remove(at: indexPath.row)
            print(indexPath.row)
            
            guard let url = URL(string: "http://140.136.149.239:3000/musicplus/user/deletesong") else {return}
            
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
            
            MusicListTableView.reloadData()
        }
    }
     
    // Set Table View Cell high
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do
        {
            let parameters:[String:Any] = ["SongId": SongSearchArray[indexPath.row].Id, "UserId": UserId] as! [String:Any]
            
            print(SongSearchArray[indexPath.row].Id)
            guard let url = URL(string: "http://140.136.149.239:3000/musicplus/play") else {return}
            
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
                        
                        let json2 = try JSONDecoder().decode(SongDownload.self, from: data)
                        DispatchQueue.main.async(){
                            selectSongNumber = indexPath.row
                            print(selectSongNumber)
                        }
                        self.downloadFile(url: json2.song_address, song: SongSearchArray[indexPath.row].SongName, singer: SongSearchArray[indexPath.row].Singer, album: SongSearchArray[indexPath.row].Album, row: indexPath.row)
                    }
                    catch{
                        print(error)
                    }
                }
                
                let MusicPlayingStoryBorad = self.storyboard?.instantiateViewController(withIdentifier:"CenterPageViewController") as! CenterPageViewController
                self.delegate = MusicPlayingStoryBorad
                self.delegate?.fetchInt(rowNumber: selectSongNumber ?? 0)
            }.resume()
        }
        catch
        {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FifthPageViewController
        vc.songindex = selectSongNumber
        SongRemain = Int(audioPlayer.duration)
    }

    var songname = String()
    var session = AVAudioSession()
    
    func downloadFile(url: URL, song: String, singer: String, album: String, row:Int) {
        let CheckmainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let ChecksongIsExit = FileManager.default.fileExists(atPath: CheckmainPath+"/"+singer+"/"+album+"/"+song+".mp3")
        
        if ChecksongIsExit == false
        {
            let downloadRequest = URLRequest(url: url)
            URLSession.shared.downloadTask(with: downloadRequest) { location, response, error in
                // To do check resoponse before saving
                let checkValidation = FileManager.default
                guard  let tempLocation = location, error == nil else { return }
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let targetDirectory = documentDirectory.appendingPathComponent(singer+"/"+album)
                let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                
                do {
                    let songIsExit = FileManager.default.fileExists(atPath: mainPath+"/"+singer+"/"+album+"/"+song+".mp3")
                    let fullURL = try targetDirectory.appendingPathComponent((response?.suggestedFilename!)!)
                    if songIsExit == false
                    {
                        print("Download....")
                        SongSearchArray[row].SongPath = fullURL
                        try FileManager.default.moveItem(at: tempLocation, to: fullURL)
                        print("saved at \(fullURL) ")
                        self.songname = fullURL.lastPathComponent
                    }
                    else
                    {
                        print("Haved download!")
                    }
                    
                    let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
                    print(songPath)
                    do{
                        audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                        DispatchQueue.main.async(){ self.NowPlayingPlayButton.isSelected = true
                        }
                        audioPlayer.play()
                        //self.PostUserIdCountFrequenct()
                        DispatchQueue.main.async(){
                            self.NowPlayingCoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
                            self.NowPlayingSongNameText.text = SongSearchArray[selectSongNumber].SongName
                            
                            self.NowPlayingSingerText.text = SongSearchArray[selectSongNumber].Singer
                            
                            self.NowPlayingUIView.isHidden = false
                        }
                        SongSearchArray[row].SongLength = audioPlayer.duration
                    }
                    catch{
                        
                    }
                    
                } catch CocoaError.fileReadNoSuchFileError {
                    print("No such file")
                } catch {
                    // other errors
                    isDownload = 1
                    print("Error downloading file : \(error)")
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "PlayMusicFromPVCPersonalSegue", sender: self)
                }
            }.resume()
        }
        else
        {
            let mainDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let songPath = mainDirector.appendingPathComponent(singer+"/"+album+"/"+song+".mp3")
            print(songPath)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: songPath)
                DispatchQueue.main.async(){ self.NowPlayingPlayButton.isSelected = true
                }
                
                audioPlayer.play()
                DispatchQueue.main.async(){
                    self.NowPlayingCoverImage.image = UIImage(contentsOfFile: SongSearchArray[selectSongNumber].Cover.path)
                    self.NowPlayingSongNameText.text = SongSearchArray[selectSongNumber].SongName
                    
                    self.NowPlayingSingerText.text = SongSearchArray[selectSongNumber].Singer
                    
                    self.NowPlayingUIView.isHidden = false
                }
                SongSearchArray[row].SongLength = audioPlayer.duration
            }
            catch{
                
            }
        }
        
    }
    
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { SongSearchArray = SongArray; MusicListTableView.reloadData();  return }
     
        SongSearchArray =  SongArray.filter({song -> Bool in
        switch searchBar.selectedScopeButtonIndex{
            case 0:
                if searchText.isEmpty {return true}
                return song.SongName.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty {return song.Category == .Chinese}
                return song.SongName.lowercased().contains(searchText.lowercased()) && song.Category == .Chinese
            case 2:
                if searchText.isEmpty {return song.Category == .Korean}
                return song.SongName.lowercased().contains(searchText.lowercased()) && song.Category == .Korean
            case 3:
                if searchText.isEmpty {return song.Category == .Japanese}
                return song.SongName.lowercased().contains(searchText.lowercased()) && song.Category == .Japanese
            case 4:
                if searchText.isEmpty {return song.Category == .Western}
                return song.SongName.lowercased().contains(searchText.lowercased()) && song.Category == .Western
            default:
                return false
        }
     
    })
     
    MusicListTableView.reloadData()
    }
     
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope{
            case 0:
                SongSearchArray = SongArray
            case 1:
                SongSearchArray = SongArray.filter({song -> Bool in
                    song.Category == SongType.Chinese
                })
            case 2:
                SongSearchArray = SongArray.filter({song -> Bool in
                    song.Category == SongType.Korean
                })
            case 3:
                SongSearchArray = SongArray.filter({song -> Bool in
                    song.Category == SongType.Japanese
                })
            case 4:
                SongSearchArray = SongArray.filter({song -> Bool in
                    song.Category == SongType.Western
                })
            default:
                break
        }
        MusicListTableView.reloadData()
     }
}

// 主題歌單頁面
class ListPVCTheme: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var ThemeCollectionView: UICollectionView!
    
    var delegate: SelectedCollectionItemDelegate?
    var PostTopicId:Int = 0
    var PostTopicName:String = ""
    var PostGenreId:Int = 0
    var PostGenreName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func PostTopicIdOne(_ sender: Any) {
        PostTopicId = 1
        PostTopicName = "運動"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoThemeListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostTopicIdTwo(_ sender: Any) {
        PostTopicId = 2
        PostTopicName = "放鬆"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoThemeListSegue", sender: self)
        }
    }
    
    @IBAction func PostTopicIdThree(_ sender: Any) {
        PostTopicId = 3
        PostTopicName = "季節"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoThemeListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostTopicIdFour(_ sender: Any) {
        PostTopicId = 4
        PostTopicName = "讀書"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoThemeListSegue", sender: self)
        }
    }
    
    @IBAction func PostTopicIdFive(_ sender: Any) {
      
        PostTopicId = 5
        PostTopicName = "感情"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoThemeListSegue", sender: self)
        }
    }
    

    @IBAction func PostTopicIdSix(_ sender: Any) {
        PostTopicId = 6
        PostTopicName = "時光機"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoThemeListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdOne(_ sender: Any)
    {
        PostGenreId = 1
        PostGenreName = "Blue"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdTwo(_ sender: Any) {
        PostGenreId = 2
        PostGenreName = "Rap / Hip-hop"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdThree(_ sender: Any) {
        PostGenreId = 3
        PostGenreName = "Ballad"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdFour(_ sender: Any) {
        PostGenreId = 4
        PostGenreName = "Dance"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdFive(_ sender: Any) {
        PostGenreId = 5
        PostGenreName = "Pop"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdSix(_ sender: Any) {
        PostGenreId = 6
        PostGenreName = "Eletronic"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    @IBAction func PostGenreIdSeven(_ sender: Any) {
        PostGenreId = 7
        PostGenreName = "Country"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdEight(_ sender: Any) {
        PostGenreId = 8
        PostGenreName = "Indie"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdNine(_ sender: Any) {
        PostGenreId = 9
        PostGenreName = "R&B"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    
    @IBAction func PostGenreIdTen(_ sender: Any) {
        PostGenreId = 10
        PostGenreName = "Rock"
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "IntoGenreListSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IntoThemeListSegue"
        {
            let vc = segue.destination as! TopicListViewController
            vc.TopicId = PostTopicId
            vc.TopicName = PostTopicName
        }
        if segue.identifier == "IntoGenreListSegue"
        {
            let vc = segue.destination as! GenreListSongViewController
            vc.GenreId = PostGenreId
            vc.GenreName = PostGenreName
            print("This is Genre Page")
        }
    }
    
    @IBAction func didUnwindFromTopicPage(_ sender: UIStoryboardSegue)
    {
        guard let NowListeningSongIndex = sender.source as? TopicListViewController else{ return }
    }
    
    var ThemeNameArray:[UIImage] = [UIImage(named: "SportThemeIcon")!, UIImage(named: "RelaxThemeIcon")!, UIImage(named: "AutumnThemeIcon")!, UIImage(named: "FeelingThemeIcon")!, UIImage(named: "StudyThemeIcon")!, UIImage(named: "TimeMachineIcon")!]
    
    func GetListByTopicId()
    {
        let parameters:[String:Any] = ["TopicId": 1] as! [String:Any]
        
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
                    print(jsonTopicObjectArray)
                    print(jsonTopicObjectArray[0].list_id)
                    print(jsonTopicObjectArray[0].list_name)
                }
                catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ThemeNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ThemeListCollectionViewCell
        cell.ThemeListButton.setImage(ThemeNameArray[indexPath.row], for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize{
        let padding: CGFloat = 5
        let collectionViewSize = ThemeCollectionView.frame.size.width - padding
        return CGSize(width: 100, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell:UICollectionViewCell = ThemeCollectionView.cellForItem(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 200/256, green: 105/256, blue: 125/256, alpha: 1)
        
        let itemNum = 1
        print(ThemeCollectionView.indexPath)
        let temp = indexPath.row
        print(temp)
    }
}

class SONGTEST {
    let Id: Int
    let Cover: URL
    let Album: String
    let SongName: String
    let Singer: String
    let Lyrics: String
    let Category: SongType
    var SongPath: URL
    var SongLength: Double
    var ExistFlag: Bool
    
    init(Id:Int, Cover: URL, Album:String, SongName: String, Singer: String, Lyrics: String, Category: SongType, SongPath: URL, SongLength: Double, ExistFlag: Bool)
    {
        self.Id = Id
        self.Cover = Cover
        self.Album = Album
        self.SongName = SongName
        self.Singer = Singer
        self.Lyrics = Lyrics
        self.Category = Category
        self.SongPath = SongPath
        self.SongLength = SongLength
        self.ExistFlag = ExistFlag
    }
}


class SONG {
    let Id: Int
    let Cover: URL
    let Album: String
    let SongName: String
    let Singer: String
    let Lyrics: String
    let Category: SongType
    var SongPath: URL
    var SongLength: Double
 
    init(Id:Int, Cover: URL, Album:String, SongName: String, Singer: String, Lyrics: String, Category: SongType, SongPath: URL, SongLength: Double)
    {
        self.Id = Id
        self.Cover = Cover
        self.Album = Album
        self.SongName = SongName
        self.Singer = Singer
        self.Lyrics = Lyrics
        self.Category = Category
        self.SongPath = SongPath
        self.SongLength = SongLength
    }
}

enum SongType: String {
    case Chinese = "Chinese"  // 華語
    case Korean = "Korean"   // 韓語
    case Japanese = "Japanese" // 日語
    case Western = "Western"  // 西洋
}
