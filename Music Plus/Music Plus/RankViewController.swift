//
//  RankViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/10/29.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import Charts

var SongData = [SongInfomation]()
var SongChooseTop3Array = [SongChooseTop3]()
var jsongObjectRankData = [Top3type]()

// 排行榜折線圖時間軸
let tmpYaris:Array<String> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]

// Top 3 Struct
struct Top3type: Decodable{
    let song_name: String
    let rank: [Int]
}

// Top 50 Struct
struct SongInfomation: Decodable{
    let rank_id: Int
    let song_id: Int
    let song_name: String
    let song_artist: String?
    let song_album: String?
    let song_photo: URL?
    var song_lyrics: String?
}

// 華語排行榜
class CChart:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var Line1SongNameLabel: UILabel!
    @IBOutlet weak var Line2SongNameLabel: UILabel!
    @IBOutlet weak var Line3SongNameLabel: UILabel!
    @IBOutlet weak var Line4SongNameLabel: UILabel!
    @IBOutlet weak var Line5SongNameLabel: UILabel!
    @IBOutlet weak var Line6SongNameLabel: UILabel!
    
    var CSongNameChartLabelArray:Array<UILabel> = Array()
    var CSongRankChartSongName:Array<String> = Array()

    @IBOutlet weak var SongNotInDBLabel: UILabel!
    @IBOutlet weak var LineCChartView: LineChartView!
    @IBOutlet weak var CChartTableView: UITableView!
    
    var CSongRankArray = [SongRank]()
    
    var yarisTime:Array<String> = Array()
    
    let data = LineChartData()
    
    var basicData:Array<Double> = []
    var RankLineData = [[Double]](repeating: [Double](repeating: 0, count: 24), count: 10) // Line Chart 中的 數據點
    
    var Rank1LineDataSet = LineChartDataSet()
    var Rank2LineDataSet = LineChartDataSet()
    var Rank3LineDataSet = LineChartDataSet()
    var Rank4LineDataSet = LineChartDataSet()
    var Rank5LineDataSet = LineChartDataSet()
    var Rank6LineDataSet = LineChartDataSet()
    var Rank7LineDataSet = LineChartDataSet()
    var Rank8LineDataSet = LineChartDataSet()
    var Rank9LineDataSet = LineChartDataSet()
    var Rank10LineDataSet = LineChartDataSet()
    
    var basicArray:[ChartDataEntry] = []
    var Rank1LineArray:[ChartDataEntry] = []
    var Rank2LineArray:[ChartDataEntry] = []
    var Rank3LineArray:[ChartDataEntry] = []
    var Rank4LineArray:[ChartDataEntry] = []
    var Rank5LineArray:[ChartDataEntry] = []
    var Rank6LineArray:[ChartDataEntry] = []
    var Rank7LineArray:[ChartDataEntry] = []
    var Rank8LineArray:[ChartDataEntry] = []
    var Rank9LineArray:[ChartDataEntry] = []
    var Rank10LineArray:[ChartDataEntry] = []
    
    var RankData:[Top3type] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async(){
            self.SongNotInDBLabel.isHidden = true
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        // 讓 navigationController 的背景變成透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let now:Date = Date()
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH"
        let dataString:String = dateFormat.string(from: now)
        
        for (index, element) in tmpYaris.enumerated()
        {
            var nowtime:Int = Int(dataString) ?? 0
            var targetTime:Int = Int(tmpYaris[index]) ?? 0
            var setTime = (nowtime + targetTime) % 24 + 1
            if setTime == 24
            {
                setTime = 0
            }
            yarisTime.append(String(setTime))
        }
        
        SongChooseTop3Array.removeAll()
        jsongObjectRankData.removeAll()
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/rank/ctop") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with:  request) {
            (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                    jsongObjectRankData = try JSONDecoder().decode([Top3type].self, from:data)
                    print(jsongObjectRankData)
                    
                    for (index, element) in jsongObjectRankData.enumerated()
                    {
                        var GradeTotal = 0
                        var RankNowInt = 0
                        for (i, element) in jsongObjectRankData[index].rank.enumerated()
                        {
                            if i == 23
                            {
                                if jsongObjectRankData[index].rank[i] == 3
                                {
                                    RankNowInt = 1
                                }
                                else if jsongObjectRankData[index].rank[i] == 2
                                {
                                    RankNowInt = 2
                                }
                                else if jsongObjectRankData[index].rank[i] == 1
                                {
                                    RankNowInt = 3
                                }
                                else if jsongObjectRankData[index].rank[i] == -1
                                {
                                    RankNowInt = -1
                                }
                            }
                            if jsongObjectRankData[index].rank[i] == -1
                            {
                                continue
                            }
                            GradeTotal = GradeTotal + jsongObjectRankData[index].rank[i]
                        }
                        print(jsongObjectRankData[index].song_name)
                        print(GradeTotal)
                        print("Rank", RankNowInt)
                        
                        // LineId 紀錄此筆是jsongObjectRankData的第幾筆
                        SongChooseTop3Array.append(SongChooseTop3(LineId: index, SongName: jsongObjectRankData[index].song_name, Grade: GradeTotal, RankNow: RankNowInt))
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }.resume()
        
        GetTop50()
        
        LineCChartView.noDataText = "You need to provide data for the chart"
        basicData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        LineCChartView.noDataText = "You need to provide data for the chart"
        
        basicData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[0] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[2] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[3] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[4] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[5] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[6] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[7] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    }
    
    func GetTop50()
    {
        CSongRankArray.removeAll()
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/rank/crank") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with:  request) {
            (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let SongData = try JSONDecoder().decode([SongInfomation].self, from:data)
                    
                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    for (index, element) in SongData.enumerated()
                    {
                        let singer = SongData[index].song_artist ?? ""
                        let album = SongData[index].song_album ?? ""
                        
                        let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
                        self.CSongRankArray.append(SongRank(Rank: String(SongData[index].rank_id), Id:SongData[index].song_id, Cover: coverPath, SongName: SongData[index].song_name, Singer: SongData[index].song_artist ?? "", Album: SongData[index].song_album ?? "", Lyrics: SongData[index].song_lyrics ?? "" ,Category: .Korean))
                    }
                    
                    DispatchQueue.main.async(){
                        self.CChartTableView.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline:deadline)
        {
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        run(after: 1)
        {
            for (index, element) in jsongObjectRankData.enumerated()
            {
            self.CSongRankChartSongName.append(jsongObjectRankData[index].song_name)
                for(i, element) in jsongObjectRankData[index].rank.enumerated()
                {
                    self.RankLineData[index][i] = Double(jsongObjectRankData[index].rank[i])
                }
            }
            
            self.CSongNameChartLabelArray = [self.Line1SongNameLabel, self.Line2SongNameLabel, self.Line3SongNameLabel,self.Line4SongNameLabel, self.Line5SongNameLabel, self.Line6SongNameLabel]
            
            
            for (index, element) in self.CSongRankChartSongName.enumerated()
            {
                self.CSongNameChartLabelArray[index].text = "▩ " + self.CSongRankChartSongName[index]
            }
            self.SetUpLineKChart(name: self.yarisTime, basic: self.basicData, values1: self.RankLineData[0], values2: self.RankLineData[1], values3: self.RankLineData[2], values4: self.RankLineData[3], values5: self.RankLineData[4], values6: self.RankLineData[5], values7: self.RankLineData[6], values8: self.RankLineData[7], values9: self.RankLineData[8], values10: self.RankLineData[9])
        }
    }
    
    
    func SetUpLineKChart(name:[String], basic:[Double], values1:[Double], values2:[Double], values3:[Double], values4:[Double], values5:[Double], values6:[Double], values7:[Double], values8:[Double], values9:[Double], values10:[Double])
    {
        //設置整個Chart的面板
        LineCChartView.leftAxis.axisMinimum = 0
        LineCChartView.leftAxis.labelCount = 10 // y 軸展示 10 個分點
        LineCChartView.xAxis.labelCount = 24
        LineCChartView.legend.enabled = false; // 在圖下顯示圖名
        LineCChartView.doubleTapToZoomEnabled = false; //不允許雙雙擊縮放
        LineCChartView.leftAxis.enabled = false; //不顯示橫條線
        LineCChartView.xAxis.enabled = true; //顯示直條線
        LineCChartView.xAxis.labelPosition = .bottom;
        LineCChartView.xAxis.labelTextColor = UIColor(red:255/255, green: 255/255, blue:255/255, alpha: 1)
        LineCChartView.rightAxis.enabled = false; //不顯示橫條線
        
        
        // 每一條折線各自放置
        
        // 利用透明的性質，Set Up Chart上的24個分點
        for i in 0..<name.count{
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:basic[i])
            basicArray.append(data)
        }
        let basicdataset:LineChartDataSet = LineChartDataSet(entries: basicArray, label: "")
        basicdataset.colors = [UIColor.clear]
        basicdataset.drawCirclesEnabled = false
        basicdataset.drawValuesEnabled = false
        data.addDataSet(basicdataset)
        
        // Set Up 第一名折線的資料
        for i in 0..<name.count{
            let y = values1[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values1[i])
            Rank1LineArray.append(data)
        }
        // Set Up 第一名折線的樣式
        let Rank1LineDataSet =  LineChartDataSet(entries:Rank1LineArray, label: "")
        Rank1LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)] // 綠色
        Rank1LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank1LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank1LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank1LineDataSet)
        
        // Set Up 第二名折線的資料
        for i in 0..<name.count{
            let y = values2[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values2[i])
            Rank2LineArray.append(data)
        }
        // Set Up 第二名折線的樣式
        let Rank2LineDataSet = LineChartDataSet(entries: Rank2LineArray, label: "")
        Rank2LineDataSet.lineWidth = 3
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 1)] // 藍色
        Rank2LineDataSet.circleRadius = 0
        Rank2LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank2LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank2LineDataSet)
        
        
        // Set Up 第三名折線的資料
        for i in 0..<name.count{
            let y = values3[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values3[i])
            Rank3LineArray.append(data)
        }
        // Set Up 第三名折線的樣式
        let Rank3LineDataSet = LineChartDataSet(entries:Rank3LineArray, label: "")
        Rank3LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 1)] // 設置折線顏色：粉色
        Rank3LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank3LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank3LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank3LineDataSet)
        
        // Set Up 第四名折線的資料
        for i in 0..<name.count{
            let y = values4[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values4[i])
            Rank4LineArray.append(data)
        }
        // Set Up 第四名折線的樣式
        let Rank4LineDataSet = LineChartDataSet(entries:Rank4LineArray, label: "아마두")
        Rank4LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank4LineDataSet.colors = [UIColor(red:246/255, green: 237/255, blue:49/255, alpha: 1)] // 螢色
        Rank4LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank4LineDataSet.circleColors = [UIColor(red:118/155, green: 81/255, blue:46/255, alpha: 0)]
        Rank4LineDataSet.drawValuesEnabled = false;
        Rank4LineDataSet.mode = .horizontalBezier
        data.addDataSet(Rank4LineDataSet)
        
        // Set Up 第五名折線的資料
        for i in 0..<name.count{
            let y = values5[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values5[i])
            Rank5LineArray.append(data)
        }
        // Set Up 第五名折線的樣式
        let Rank5LineDataSet = LineChartDataSet(entries:Rank5LineArray, label: "")
        Rank5LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank5LineDataSet.colors = [UIColor(red:156/255, green: 255/255, blue:220/255, alpha: 1)] // 藍綠色
        Rank5LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank5LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank5LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank5LineDataSet)
        
        // Set Up 第六名折線的資料
        for i in 0..<name.count{
            let y = values6[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values6[i])
            Rank6LineArray.append(data)
        }
        // Set Up 第六名折線的樣式
        let Rank6LineDataSet = LineChartDataSet(entries:Rank6LineArray, label: "")
        
        Rank6LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank6LineDataSet.colors = [UIColor(red:156/255, green: 101/255, blue:255/255, alpha: 1)] // 紫色
        Rank6LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank6LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank6LineDataSet.drawValuesEnabled = false;
        Rank6LineDataSet.mode = .horizontalBezier
        data.addDataSet(Rank6LineDataSet)
        
        // 將六條曲線加至圖表上
        self.LineCChartView.data = data
        var axisFormatDelgate: IAxisValueFormatter?
        LineCChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yarisTime)
        LineCChartView.xAxis.granularity = 1
    }
    
    // 點擊愛心時會抓 RowIndex ，並至個人歌單
    @objc func connected(sender: UIButton)
    {
        var isExistInMyList:Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Heart Click")
        let ClickButtonRow = sender.tag
        print(CSongRankArray[ClickButtonRow].Id)
        print(CSongRankArray[ClickButtonRow].SongName)
        print(CSongRankArray.enumerated())
        
        if CSongRankArray[ClickButtonRow].Id == -1
        {
            SongNotInDBLabel.text = "資料庫中無此歌曲"
            DispatchQueue.main.async(){
                self.SongNotInDBLabel.isHidden = false
            }
            print("資料庫中無此首歌曲")
        }
            
        else
        {
            for (index,element) in SongSearchArray.enumerated()
            {
                if SongSearchArray[index].Id == CSongRankArray[ClickButtonRow].Id
                {
                    isExistInMyList = true
                }
            }
            
            if isExistInMyList == false
            {
                SongSearchArray.append(SONG(Id:CSongRankArray[ClickButtonRow].Id, Cover: CSongRankArray[ClickButtonRow].Cover, Album: CSongRankArray[ClickButtonRow].Album, SongName: CSongRankArray[ClickButtonRow].SongName, Singer: CSongRankArray[ClickButtonRow].Singer, Lyrics: CSongRankArray[ClickButtonRow].Lyrics ?? "", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
                SongArray.append(SONG(Id:CSongRankArray[ClickButtonRow].Id, Cover: CSongRankArray[ClickButtonRow].Cover, Album: CSongRankArray[ClickButtonRow].Album, SongName: CSongRankArray[ClickButtonRow].SongName, Singer: CSongRankArray[ClickButtonRow].Singer, Lyrics: CSongRankArray[ClickButtonRow].Lyrics ?? "", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
                
                SongNotInDBLabel.text = "成功加入此歌曲"
                DispatchQueue.main.async(){
                    self.SongNotInDBLabel.isHidden = false
                }
                
                let parameters:[String:Any] = ["UserId": UserId, "SongId": CSongRankArray[ClickButtonRow].Id] as! [String:Any]
                
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
                SongNotInDBLabel.text = "此歌曲已經存在於個人歌單中"
                DispatchQueue.main.async(){
                    self.SongNotInDBLabel.isHidden = false
                }
                print("此歌曲已經新增至個人歌單中")
            }
        }
    }
    
    // Table 設置 numberOfSection
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Table 設置 tableView numberOfRowsInSection -> Table 的列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CSongRankArray.count
    }
    // Table 設置 tableView cellForRowAt -> Table 每一列的 cell 上的資訊
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CChartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CSongsRankTableViewCell
        
        cell.RankCell.image = UIImage(named: "Rank" +  CSongRankArray[indexPath.row].Rank)
        
        let coverPath = CSongRankArray[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = CSongRankArray[indexPath.row].SongName
        cell .SingerCell.text = CSongRankArray[indexPath.row].Singer
        
        cell.LikeHeartButtonCell.tag = indexPath.row
        cell.LikeHeartButtonCell.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        return cell
    }
    // Table 設置 tableView heightForRowAt -> Table 的列高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// 韓語排行榜
class KChart:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var Line1SongNameLabel: UILabel!
    @IBOutlet weak var Line2SongNameLabel: UILabel!
    @IBOutlet weak var Line3SongNameLabel: UILabel!
    @IBOutlet weak var Line4SongNameLabel: UILabel!
    @IBOutlet weak var Line5SongNameLabel: UILabel!
    @IBOutlet weak var Line6SongNameLabel: UILabel!
    
    @IBOutlet weak var LineKChartView: LineChartView!
    @IBOutlet weak var KChartTableView: UITableView!
    
    @IBOutlet weak var SongNotInDBLabel: UILabel!
    
    var KSongRankArray = [SongRank]()
    
    var KSongNameChartLabelArray:Array<UILabel> = Array()
    var KSongRankChartSongName:Array<String> = Array()
    
    var yarisTime:Array<String> = Array()
    let data = LineChartData()
    
    var basicData:Array<Double> = []
    var RankLineData = [[Double]](repeating: [Double](repeating: 0, count: 24), count: 10)
    
    var Rank1LineDataSet = LineChartDataSet()
    var Rank2LineDataSet = LineChartDataSet()
    var Rank3LineDataSet = LineChartDataSet()
    var Rank4LineDataSet = LineChartDataSet()
    var Rank5LineDataSet = LineChartDataSet()
    var Rank6LineDataSet = LineChartDataSet()
    var Rank7LineDataSet = LineChartDataSet()
    var Rank8LineDataSet = LineChartDataSet()
    var Rank9LineDataSet = LineChartDataSet()
    var Rank10LineDataSet = LineChartDataSet()
    
    var basicArray:[ChartDataEntry] = []
    var Rank1LineArray:[ChartDataEntry] = []
    var Rank2LineArray:[ChartDataEntry] = []
    var Rank3LineArray:[ChartDataEntry] = []
    var Rank4LineArray:[ChartDataEntry] = []
    var Rank5LineArray:[ChartDataEntry] = []
    var Rank6LineArray:[ChartDataEntry] = []
    var Rank7LineArray:[ChartDataEntry] = []
    var Rank8LineArray:[ChartDataEntry] = []
    var Rank9LineArray:[ChartDataEntry] = []
    var Rank10LineArray:[ChartDataEntry] = []
    
    var RankData:[Top3type] = []
    
    func GetTop50()
    {
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/rank/krank") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with:  request) {
            (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let SongData = try JSONDecoder().decode([SongInfomation].self, from:data)
                    
                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    for (index, element) in SongData.enumerated()
                    {
                        let singer = SongData[index].song_artist ?? ""
                        let album = SongData[index].song_album ?? ""
                        
                        let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
                        self.KSongRankArray.append(SongRank(Rank: String(SongData[index].rank_id), Id: SongData[index].song_id,Cover: coverPath, SongName: SongData[index].song_name, Singer: SongData[index].song_artist ?? "", Album: SongData[index].song_album ?? "", Lyrics: SongData[index].song_lyrics ?? "" , Category: .Korean))
                    }
                    
                    DispatchQueue.main.async(){
                        self.KChartTableView.reloadData()
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }.resume()
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
        }.resume()
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline:deadline)
        {
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        run(after: 1)
        {
            for (index, element) in jsongObjectRankData.enumerated()
            {
            self.KSongRankChartSongName.append(jsongObjectRankData[index].song_name)
                for(i, element) in jsongObjectRankData[index].rank.enumerated()
                {
                    self.RankLineData[index][i] = Double(jsongObjectRankData[index].rank[i])
                }
            }
            
            self.KSongNameChartLabelArray = [self.Line1SongNameLabel, self.Line2SongNameLabel, self.Line3SongNameLabel,self.Line4SongNameLabel, self.Line5SongNameLabel, self.Line6SongNameLabel]
            
            
            for (index, element) in self.KSongRankChartSongName.enumerated()
            {
                self.KSongNameChartLabelArray[index].text = "▩ " + self.KSongRankChartSongName[index]
            }
            self.SetUpLineKChart(name: self.yarisTime, basic: self.basicData, values1: self.RankLineData[0], values2: self.RankLineData[1], values3: self.RankLineData[2], values4: self.RankLineData[3], values5: self.RankLineData[4], values6: self.RankLineData[5], values7: self.RankLineData[6], values8: self.RankLineData[7], values9: self.RankLineData[8], values10: self.RankLineData[9])
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async(){
            self.SongNotInDBLabel.isHidden = true
        }
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        // 讓 navigationController 的背景變成透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        KChartTableView?.delegate = self
        KChartTableView?.dataSource = self

        let now:Date = Date()
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH"
        let dataString:String = dateFormat.string(from: now)
        
        for (index, element) in tmpYaris.enumerated()
        {
            var nowtime:Int = Int(dataString) ?? 0
            var targetTime:Int = Int(tmpYaris[index]) ?? 0
            var setTime = (nowtime + targetTime) % 24 + 1
            if setTime == 24
            {
                setTime = 0
            }
            yarisTime.append(String(setTime))
        }
        
        SongChooseTop3Array.removeAll()
        jsongObjectRankData.removeAll()
        
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/rank/ktop") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with:  request) {
            (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    jsongObjectRankData = try JSONDecoder().decode([Top3type].self, from:data)
                    print(jsongObjectRankData)
                    
                    for (index, element) in jsongObjectRankData.enumerated()
                    {
                        var GradeTotal = 0
                        var RankNowInt = 0
                        for (i, element) in jsongObjectRankData[index].rank.enumerated()
                        {
                            if i == 23
                            {
                                if jsongObjectRankData[index].rank[i] == 3
                                {
                                    RankNowInt = 1
                                }
                                else if jsongObjectRankData[index].rank[i] == 2
                                {
                                    RankNowInt = 2
                                }
                                else if jsongObjectRankData[index].rank[i] == 1
                                {
                                    RankNowInt = 3
                                }
                                else if jsongObjectRankData[index].rank[i] == -1
                                {
                                    RankNowInt = -1
                                }
                            }
                            if jsongObjectRankData[index].rank[i] == -1
                            {
                                continue
                            }
                            GradeTotal = GradeTotal + jsongObjectRankData[index].rank[i]
                        }
                        print(jsongObjectRankData[index].song_name)
                        print(GradeTotal)
                        print("Rank", RankNowInt)
                        
                        SongChooseTop3Array.append(SongChooseTop3(LineId: index+1, SongName: jsongObjectRankData[index].song_name, Grade: GradeTotal, RankNow: RankNowInt))
                    }
                    
                    
                }
                catch {
                    print(error)
                }
            }
        }.resume()
        
        GetTop50()
        
        LineKChartView.noDataText = "You need to provide data for the chart"
        
        basicData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[0] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[2] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[3] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[4] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[5] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[6] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[7] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    }
    
    func SetUpLineKChart(name:[String], basic:[Double], values1:[Double], values2:[Double], values3:[Double], values4:[Double], values5:[Double], values6:[Double], values7:[Double], values8:[Double], values9:[Double], values10:[Double])
    {
        // 設置整個Chart的面板
        LineKChartView.leftAxis.axisMinimum = 0
        LineKChartView.leftAxis.labelCount = 10 // y 軸展示 10 個分點
        LineKChartView.xAxis.labelCount = 24
        LineKChartView.legend.enabled = false; // 在圖下顯示圖名
        LineKChartView.doubleTapToZoomEnabled = false; //不允許雙雙擊縮放
        LineKChartView.leftAxis.enabled = false; //不顯示橫條線
        LineKChartView.xAxis.enabled = true; //顯示直條線
        LineKChartView.xAxis.labelPosition = .bottom;
        LineKChartView.xAxis.labelTextColor = UIColor(red:255/255, green: 255/255, blue:255/255, alpha: 1)
        LineKChartView.rightAxis.enabled = false; //不顯示橫條線
        
        // 利用透明的性質，Set Up Chart上的24個分點
        for i in 0..<name.count{
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:basic[i])
            basicArray.append(data)
        }
        let basicdataset:LineChartDataSet = LineChartDataSet(entries: basicArray, label: "")
        basicdataset.colors = [UIColor.clear]
        basicdataset.drawCirclesEnabled = false
        basicdataset.drawValuesEnabled = false
        data.addDataSet(basicdataset)
        
        // Set Up 第一名折線的資料
        for i in 0..<name.count{
            let y = values1[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values1[i])
            Rank1LineArray.append(data)
        }
        // Set Up 第一名折線的樣式
        let Rank1LineDataSet = LineChartDataSet(entries: Rank1LineArray, label: "")
        Rank1LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)]
        Rank1LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank1LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank1LineDataSet.drawValuesEnabled = false;
        Rank1LineDataSet.mode = .horizontalBezier
        data.addDataSet(Rank1LineDataSet)
        
        // Set Up 第二名折線的資料
        for i in 0..<name.count{
            let y = values2[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values2[i])
            Rank2LineArray.append(data)
        }
        // Set Up 第二名折線的樣式
        let Rank2LineDataSet = LineChartDataSet.init(entries: Rank2LineArray, label: "")
        Rank2LineDataSet.lineWidth = 3
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 1)]
        Rank2LineDataSet.circleRadius = 0
        Rank2LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank2LineDataSet.drawValuesEnabled = false;
        Rank2LineDataSet.mode = .horizontalBezier
        data.addDataSet(Rank2LineDataSet)
        
        // Set Up 第三名折線的資料
        for i in 0..<name.count{
            let y = values3[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values3[i])
            Rank3LineArray.append(data)
        }
        // Set Up 第三名折線的樣式
        let Rank3LineDataSet = LineChartDataSet(entries:Rank3LineArray, label: "")
        Rank3LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 1)] // 設置折線顏色：粉色
        Rank3LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank3LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank3LineDataSet.drawValuesEnabled = false;
        Rank3LineDataSet.mode = .horizontalBezier
        data.addDataSet(Rank3LineDataSet)
        
        // Set Up 第四名折線的資料
        for i in 0..<name.count{
            let y = values4[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values4[i])
            Rank4LineArray.append(data)
        }
        // Set Up 第四名折線的樣式
        let Rank4LineDataSet = LineChartDataSet(entries:Rank4LineArray, label: "")
        Rank4LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank4LineDataSet.colors = [UIColor(red:246/255, green: 237/255, blue:49/255, alpha: 1)] // 設置折線顏色：螢色
        //linedataset.circleHoleRadius = 1
        Rank4LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank4LineDataSet.circleColors = [UIColor(red:118/155, green: 81/255, blue:46/255, alpha: 0)]
        Rank4LineDataSet.drawValuesEnabled = false;
        Rank4LineDataSet.mode = .horizontalBezier
        data.addDataSet(Rank4LineDataSet)
        
        // Set Up 第五名折線的資料
        for i in 0..<name.count{
            let y = values5[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values5[i])
            Rank5LineArray.append(data)
        }
        // Set Up 第五名折線的樣式
        let Rank5LineDataSet = LineChartDataSet(entries:Rank5LineArray, label: "")
        Rank5LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank5LineDataSet.colors = [UIColor(red:156/255, green: 255/255, blue:220/255, alpha: 1)] // 設置折線顏色：藍綠色
        Rank5LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank5LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank5LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank5LineDataSet)
        
        // Set Up 第六名折線的資料
        for i in 0..<name.count{
            let y = values6[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values6[i])
            Rank6LineArray.append(data)
        }
        // Set Up 第六名折線的樣式
        let Rank6LineDataSet = LineChartDataSet(entries:Rank6LineArray, label: "")
        Rank6LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank6LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        Rank6LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank6LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank6LineDataSet.drawValuesEnabled = false;
        Rank6LineDataSet.mode = .horizontalBezier
        data.addDataSet(Rank6LineDataSet)
        
        // Set Up 第七名折線的資料
        for i in 0..<name.count{
            let y = values7[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values7[i])
            Rank7LineArray.append(data)
        }
        // Set Up 第七名折線的樣式
        let Rank7LineDataSet = LineChartDataSet(entries:Rank7LineArray, label: "")
        Rank7LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank7LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        Rank7LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank7LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank7LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank7LineDataSet)
        
        // Set Up 第八名折線的資料
        for i in 0..<name.count{
            let y = values8[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values8[i])
            Rank8LineArray.append(data)
        }
        // Set Up 第八名折線的樣式
        let Rank8LineDataSet = LineChartDataSet(entries:Rank8LineArray, label: "")
        Rank8LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank8LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        Rank8LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank8LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank8LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank8LineDataSet)
        
        // Set Up 第九名折線的資料
        for i in 0..<name.count{
            let y = values9[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values9[i])
            Rank9LineArray.append(data)
        }
        // Set Up 第九名折線的樣式
        let Rank9LineDataSet = LineChartDataSet(entries:Rank9LineArray, label: "")
        Rank9LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank9LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        //linedataset.circleHoleRadius = 1
        Rank9LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank9LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank9LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank9LineDataSet)
        
        // Set Up 第十名折線的資料
        for i in 0..<name.count{
            let y = values10[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values10[i])
            Rank10LineArray.append(data)
        }
        // Set Up 第十名折線的樣式
        let Rank10LineDataSet = LineChartDataSet(entries:Rank10LineArray, label: "")
        Rank10LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank10LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        Rank10LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank10LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank10LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank10LineDataSet)
        
        self.LineKChartView.data = data
        var axisFormatDelgate: IAxisValueFormatter?
        LineKChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yarisTime)
        LineKChartView.xAxis.granularity = 1
        LineKChartView.notifyDataSetChanged()

    }
    
    @objc func connected(sender: UIButton)
    {
        var isExistInMyList:Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Heart Click")
        let ClickButtonRow = sender.tag
        print(KSongRankArray[ClickButtonRow].Id)
        print(KSongRankArray[ClickButtonRow].SongName)
        print(KSongRankArray.enumerated())
        
        
        if KSongRankArray[ClickButtonRow].Id == -1
        {
            SongNotInDBLabel.text = "資料庫中無此歌曲"
            DispatchQueue.main.async(){
                //print(self.KSongRankArray.count)
                self.SongNotInDBLabel.isHidden = false
            }
            print("資料庫中無此首歌曲")
        }
            
        else
        {
            for (index,element) in SongSearchArray.enumerated()
            {
                if SongSearchArray[index].Id == KSongRankArray[ClickButtonRow].Id
                {
                    isExistInMyList = true
                }
            }
            
            if isExistInMyList == false
            {
                SongSearchArray.append(SONG(Id:KSongRankArray[ClickButtonRow].Id, Cover: KSongRankArray[ClickButtonRow].Cover, Album: KSongRankArray[ClickButtonRow].Album, SongName: KSongRankArray[ClickButtonRow].SongName, Singer: KSongRankArray[ClickButtonRow].Singer, Lyrics: KSongRankArray[ClickButtonRow].Lyrics ?? "", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
                SongArray.append(SONG(Id:KSongRankArray[ClickButtonRow].Id, Cover: KSongRankArray[ClickButtonRow].Cover, Album: KSongRankArray[ClickButtonRow].Album, SongName: KSongRankArray[ClickButtonRow].SongName, Singer: KSongRankArray[ClickButtonRow].Singer, Lyrics: KSongRankArray[ClickButtonRow].Lyrics ?? "", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
                
                SongNotInDBLabel.text = "成功加入此歌曲"
                DispatchQueue.main.async(){
                    //print(self.KSongRankArray.count)
                    self.SongNotInDBLabel.isHidden = false
                }
                /*DispatchQueue.main.async {
                 self.AddSuccessNotificationLabel.isHidden = false
                 // UIView usage
                 }*/
                
                let parameters:[String:Any] = ["UserId": UserId, "SongId": KSongRankArray[ClickButtonRow].Id] as! [String:Any]
                
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
                SongNotInDBLabel.text = "此歌曲已經存在於個人歌單中"
                DispatchQueue.main.async(){
                    //print(self.KSongRankArray.count)
                    self.SongNotInDBLabel.isHidden = false
                }
                print("此歌曲已經新增至個人歌單中")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KSongRankArray.count
        //return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = KChartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! KSongsRankTableViewCell
        
        cell.RankCell.image = UIImage(named: "Rank" + KSongRankArray[indexPath.row].Rank)
        
        let coverPath = KSongRankArray[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = KSongRankArray[indexPath.row].SongName
        cell.SingerCell.text = KSongRankArray[indexPath.row].Singer
        cell.LikeHeartButtonCell.tag = indexPath.row
        cell.LikeHeartButtonCell.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


class ＷChart:UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var Line1SongNameLabel: UILabel!
    @IBOutlet weak var Line2SongNameLabel: UILabel!
    @IBOutlet weak var Line3SongNameLabel: UILabel!
    @IBOutlet weak var Line4SongNameLabel: UILabel!
    @IBOutlet weak var Line5SongNameLabel: UILabel!
    @IBOutlet weak var Line6SongNameLabel: UILabel!
    
    
    
    @IBOutlet weak var SongNotInDBLabel: UILabel!
    
    
    var WSongNameChartLabelArray:Array<UILabel> = Array()
    var WSongRankChartSongName:Array<String> = Array()

    @IBOutlet weak var LineWChartView: LineChartView!
    @IBOutlet weak var WChartTableView: UITableView!
    
    var yarisTime:Array<String> = Array()
    
    var WSongRankArray = [SongRank]()
    
    let data = LineChartData()
    
    var basicData:Array<Double> = []
    var RankLineData = [[Double]](repeating: [Double](repeating: 0, count: 24), count: 10)
    
    var Rank1LineDataSet = LineChartDataSet()
    var Rank2LineDataSet = LineChartDataSet()
    var Rank3LineDataSet = LineChartDataSet()
    var Rank4LineDataSet = LineChartDataSet()
    var Rank5LineDataSet = LineChartDataSet()
    var Rank6LineDataSet = LineChartDataSet()
    var Rank7LineDataSet = LineChartDataSet()
    var Rank8LineDataSet = LineChartDataSet()
    var Rank9LineDataSet = LineChartDataSet()
    var Rank10LineDataSet = LineChartDataSet()
    
    
    var basicArray:[ChartDataEntry] = []
    var Rank1LineArray:[ChartDataEntry] = []
    var Rank2LineArray:[ChartDataEntry] = []
    var Rank3LineArray:[ChartDataEntry] = []
    var Rank4LineArray:[ChartDataEntry] = []
    var Rank5LineArray:[ChartDataEntry] = []
    var Rank6LineArray:[ChartDataEntry] = []
    var Rank7LineArray:[ChartDataEntry] = []
    var Rank8LineArray:[ChartDataEntry] = []
    var Rank9LineArray:[ChartDataEntry] = []
    var Rank10LineArray:[ChartDataEntry] = []
    
    var RankData:[Top3type] = []

    
    func GetTop50()
    {
        WSongRankArray.removeAll()
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/rank/wrank") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with:  request) {
            (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    var SongData = try JSONDecoder().decode([SongInfomation].self, from:data)
                    print(SongData)
                    
                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    for (index, element) in SongData.enumerated()
                    {
                        let singer = SongData[index].song_artist ?? ""
                        let album = SongData[index].song_album ?? ""
                        
                        let coverPath = documentDirectory.appendingPathComponent(singer + "/" + album + "/cover.jpg")
                        
                        if SongData[index].song_lyrics == nil
                        {
                            SongData[index].song_lyrics = "目前無歌詞"
                        }
                        self.WSongRankArray.append(SongRank(Rank: String(SongData[index].rank_id), Id: SongData[index].song_id, Cover: coverPath, SongName: SongData[index].song_name, Singer: SongData[index].song_artist ?? "", Album: SongData[index].song_album ?? "", Lyrics: SongData[index].song_lyrics ?? "", Category: .Korean))
                        
                        
                        //downloadSongCover(url:SongData[index].song_photo, singer: jsonObjectArray[index].song_artist, album: jsonObjectArray[index].song_album)
                    }
                    
                    DispatchQueue.main.async(){
                        //print(self.KSongRankArray.count)
                        self.WChartTableView.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline:deadline)
        {
            completion()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        run(after: 1)
        {
            
            for (index, element) in jsongObjectRankData.enumerated()
            {
                self.WSongRankChartSongName.append(jsongObjectRankData[index].song_name)
                for(i, element) in jsongObjectRankData[index].rank.enumerated()
                {
                    self.RankLineData[index][i] = Double(jsongObjectRankData[index].rank[i])
                }
            }
            
            self.WSongNameChartLabelArray = [self.Line1SongNameLabel, self.Line2SongNameLabel, self.Line3SongNameLabel,self.Line4SongNameLabel, self.Line5SongNameLabel, self.Line6SongNameLabel]
            
            
            for (index, element) in self.WSongRankChartSongName.enumerated()
            {
                self.WSongNameChartLabelArray[index].text = "▩ " + self.WSongRankChartSongName[index]
            }
            
            self.SetUpLineKChart(name: self.yarisTime, basic: self.basicData, values1: self.RankLineData[0], values2: self.RankLineData[1], values3: self.RankLineData[2], values4: self.RankLineData[3], values5: self.RankLineData[4], values6: self.RankLineData[5], values7: self.RankLineData[6], values8: self.RankLineData[7], values9: self.RankLineData[8], values10: self.RankLineData[9])
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async(){
            self.SongNotInDBLabel.isHidden = true
        }
        
        // 設置導覽列
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        // 讓 navigationController 的背景變成透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let now:Date = Date()
        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateFormat = "HH"
        let dataString:String = dateFormat.string(from: now)
        
        for (index, element) in tmpYaris.enumerated()
        {
            var nowtime:Int = Int(dataString) ?? 0
            var targetTime:Int = Int(tmpYaris[index]) ?? 0
            var setTime = (nowtime + targetTime) % 24 + 1
            if setTime == 24
            {
                setTime = 0
            }
            yarisTime.append(String(setTime))
        }
        SongChooseTop3Array.removeAll()
        jsongObjectRankData.removeAll()
        guard let url = URL(string: "http://140.136.149.239:3000/musicplus/rank/wtop") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                    jsongObjectRankData = try JSONDecoder().decode([Top3type].self, from:data)
                    print(jsongObjectRankData)
                    
                    for (index, element) in jsongObjectRankData.enumerated()
                    {
                        var GradeTotal = 0
                        var RankNowInt = 0
                        for (i, element) in jsongObjectRankData[index].rank.enumerated()
                        {
                            if i == 23
                            {
                                if jsongObjectRankData[index].rank[i] == 3
                                {
                                    RankNowInt = 1
                                }
                                else if jsongObjectRankData[index].rank[i] == 2
                                {
                                    RankNowInt = 2
                                }
                                else if jsongObjectRankData[index].rank[i] == 1
                                {
                                    RankNowInt = 3
                                }
                                else if jsongObjectRankData[index].rank[i] == -1
                                {
                                    RankNowInt = -1
                                }
                            }
                            if jsongObjectRankData[index].rank[i] == -1
                            {
                                continue
                            }
                            GradeTotal = GradeTotal + jsongObjectRankData[index].rank[i]
                        }
                        print(jsongObjectRankData[index].song_name)
                        print(GradeTotal)
                        print("Rank", RankNowInt)
                        
                        SongChooseTop3Array.append(SongChooseTop3(LineId: index+1, SongName: jsongObjectRankData[index].song_name, Grade: GradeTotal, RankNow: RankNowInt))
                    }
                }
                catch {
                    print(error)
                }
            }
        }.resume()
        
        LineWChartView.noDataText = "You need to provide data for the chart"
        
        basicData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[0] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[2] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[3] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[4] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[5] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[6] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[7] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        RankLineData[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        GetTop50()
    }
    
    func SetUpLineKChart(name:[String], basic:[Double], values1:[Double], values2:[Double], values3:[Double], values4:[Double], values5:[Double], values6:[Double], values7:[Double], values8:[Double], values9:[Double], values10:[Double])
    {
        
        // 設置整個Chart的面板
        LineWChartView.leftAxis.axisMinimum = 0
        LineWChartView.leftAxis.labelCount = 10 // y 軸展示 10 個分點
        LineWChartView.xAxis.labelCount = 24
        LineWChartView.legend.enabled = false; // 在圖下顯示圖名
        LineWChartView.doubleTapToZoomEnabled = false; //不允許雙雙擊縮放
        LineWChartView.leftAxis.enabled = false; //不顯示橫條線
        LineWChartView.xAxis.enabled = true; //顯示直條線
        LineWChartView.xAxis.labelPosition = .bottom;
        LineWChartView.xAxis.labelTextColor = UIColor(red:255/255, green: 255/255, blue:255/255, alpha: 1)
        
        LineWChartView.rightAxis.enabled = false; //不顯示橫條線
        
        // 利用透明的性質，Set Up Chart上的24個分點
        for i in 0..<name.count{
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:basic[i])
            basicArray.append(data)
        }
        let basicdataset:LineChartDataSet = LineChartDataSet(entries: basicArray, label: "")
        basicdataset.colors = [UIColor.clear]
        basicdataset.drawCirclesEnabled = false
        basicdataset.drawValuesEnabled = false
        data.addDataSet(basicdataset)
        
        // Set Up 第一名折線的資料
        for i in 0..<name.count{
            let y = values1[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values1[i])
            Rank1LineArray.append(data)
        }
        // Set Up 第一名折線的樣式
        let Rank1LineDataSet =  LineChartDataSet(entries:Rank1LineArray, label: "HWASA - TWIT")
        Rank1LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)]
        Rank1LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank1LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank1LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank1LineDataSet)
        
        // Set Up 第二名折線的資料
        for i in 0..<name.count{
            let y = values2[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values2[i])
            Rank2LineArray.append(data)
        }
        // Set Up 第二名折線的資料
        let Rank2LineDataSet = LineChartDataSet(entries: Rank2LineArray, label: "Whee In - Good Bye")
        Rank2LineDataSet.lineWidth = 3
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 1)]
        Rank2LineDataSet.circleRadius = 0
        Rank2LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank2LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank2LineDataSet)
        
        // Set Up 第三名折線的資料
        for i in 0..<name.count{
            let y = values3[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values3[i])
            Rank3LineArray.append(data)
        }
        // Set Up 第三名折線的資料
        let Rank3LineDataSet = LineChartDataSet(entries:Rank3LineArray, label: "")
        Rank3LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 1)] // 設置折線顏色：粉色
        //linedataset.circleHoleRadius = 1
        Rank3LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank3LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank3LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank3LineDataSet)
        
        // Set Up 第四名折線的資料
        for i in 0..<name.count{
            let y = values4[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values4[i])
            Rank4LineArray.append(data)
        }
        // Set Up 第四名折線的資料
        let Rank4LineDataSet = LineChartDataSet(entries:Rank4LineArray, label: "")
        Rank4LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank4LineDataSet.colors = [UIColor(red:246/255, green: 237/255, blue:49/255, alpha: 1)] // 設置折線顏色：螢色
        Rank4LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank4LineDataSet.circleColors = [UIColor(red:118/155, green: 81/255, blue:46/255, alpha: 0)]
        Rank4LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank4LineDataSet)
        
        // Set Up 第五名折線的資料
        for i in 0..<name.count{
            let y = values5[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values5[i])
            Rank5LineArray.append(data)
        }
        // Set Up 第五名折線的資料
        let Rank5LineDataSet = LineChartDataSet(entries:Rank5LineArray, label: "")
        Rank5LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank5LineDataSet.colors = [UIColor(red:156/255, green: 255/255, blue:220/255, alpha: 1)] // 設置折線顏色：藍綠色
        Rank5LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank5LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank5LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank5LineDataSet)
        
        // Set Up 第六名折線的資料
        for i in 0..<name.count{
            let y = values6[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values6[i])
            Rank6LineArray.append(data)
        }
        // Set Up 第六名折線的資料
        let Rank6LineDataSet = LineChartDataSet(entries:Rank6LineArray, label: "")
        Rank6LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank6LineDataSet.colors = [UIColor(red:255/255, green: 178/255, blue:147/255, alpha: 1)] // 設置折線顏色：紫色
        Rank6LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank6LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank6LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank6LineDataSet)
        
        self.LineWChartView.data = data
        var axisFormatDelgate: IAxisValueFormatter?
        LineWChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yarisTime)
        LineWChartView.xAxis.granularity = 1
    }
    
    @objc func connected(sender: UIButton)
    {
        var isExistInMyList:Bool = false
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Heart Click")
        let ClickButtonRow = sender.tag
        print(WSongRankArray[ClickButtonRow].Id)
        print(WSongRankArray[ClickButtonRow].SongName)
        print(WSongRankArray.enumerated())
        
        
        if WSongRankArray[ClickButtonRow].Id == -1
        {
            SongNotInDBLabel.text = "資料庫中無此歌曲"
            DispatchQueue.main.async(){
                self.SongNotInDBLabel.isHidden = false
            }
            print("資料庫中無此首歌曲")
        }
        
        else
        {
            for (index,element) in SongSearchArray.enumerated()
            {
                if SongSearchArray[index].Id == WSongRankArray[ClickButtonRow].Id
                {
                    isExistInMyList = true
                }
            }
            
            if isExistInMyList == false
            {
                SongSearchArray.append(SONG(Id:WSongRankArray[ClickButtonRow].Id, Cover: WSongRankArray[ClickButtonRow].Cover, Album: WSongRankArray[ClickButtonRow].Album, SongName: WSongRankArray[ClickButtonRow].SongName, Singer: WSongRankArray[ClickButtonRow].Singer, Lyrics: WSongRankArray[ClickButtonRow].Lyrics ?? "", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
                
                SongArray.append(SONG(Id:WSongRankArray[ClickButtonRow].Id, Cover: WSongRankArray[ClickButtonRow].Cover, Album: WSongRankArray[ClickButtonRow].Album, SongName: WSongRankArray[ClickButtonRow].SongName, Singer: WSongRankArray[ClickButtonRow].Singer, Lyrics: WSongRankArray[ClickButtonRow].Lyrics ?? "", Category: .Korean, SongPath: documentDirectory, SongLength: 23))
                
                SongNotInDBLabel.text = "成功加入此歌曲"
                DispatchQueue.main.async(){
                    self.SongNotInDBLabel.isHidden = false
                }
                
                let parameters:[String:Any] = ["UserId": UserId, "SongId": WSongRankArray[ClickButtonRow].Id] as! [String:Any]
                
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
                SongNotInDBLabel.text = "此歌曲已經存在於個人歌單中"
                DispatchQueue.main.async(){
                    //print(self.KSongRankArray.count)
                    self.SongNotInDBLabel.isHidden = false
                }
                print("此歌曲已經新增至個人歌單中")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WSongRankArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WChartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! WSongsRankTableViewCell
        
        cell.RankCell.image = UIImage(named: "Rank" + WSongRankArray[indexPath.row].Rank)
        let coverPath = WSongRankArray[indexPath.row].Cover.path
        cell.CoverCell.image = UIImage(contentsOfFile: coverPath)
        cell.SongNameCell.text = WSongRankArray[indexPath.row].SongName
        cell .SingerCell.text = WSongRankArray[indexPath.row].Singer
        
        cell.LikeHeartButtonCell.tag = indexPath.row
        cell.LikeHeartButtonCell.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


class SongRank{
    let Rank: String
    let Id: Int
    let Cover: URL
    let SongName: String
    let Singer: String
    let Album: String
    var Lyrics: String?
    let Category: SongType
    
    init(Rank:String, Id:Int, Cover: URL, SongName: String, Singer: String, Album: String, Lyrics: String, Category:SongType)
    {
        self.Rank = Rank
        self.Id = Id
        self.Cover = Cover
        self.SongName = SongName
        self.Singer = Singer
        self.Album = Album
        self.Lyrics = Lyrics
        self.Category = Category
    }
}

class SongChooseTop3{
    let LineId : Int
    let SongName: String
    let Grade: Int
    let RankNow: Int
    init(LineId: Int, SongName: String, Grade: Int, RankNow: Int)
    {
        self.LineId = LineId
        self.SongName = SongName
        self.Grade = Grade
        self.RankNow = RankNow
    }
}
