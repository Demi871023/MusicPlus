//
//  RankViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/10/29.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import Charts

class CChart:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var LineCChartView: LineChartView!
    @IBOutlet weak var CChartTableView: UITableView!
    
    var CSongRankArray = [SongRank]()
    
    let yarisTime:Array<String> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    
    let data = LineChartData()
    
    var basicData:Array<Double> = []
    var Rank1LineData:Array<Double> = [] // Line Chart 中的 數據點
    var Rank2LineData:Array<Double> = []
    var Rank3LineData:Array<Double> = []
    
    var Rank1LineDataSet = LineChartDataSet()
    var Rank2LineDataSet = LineChartDataSet()
    var Rank3LineDataSet = LineChartDataSet()
    
    var basicArray:[ChartDataEntry] = []
    var Rank1LineArray:[ChartDataEntry] = []
    var Rank2LineArray:[ChartDataEntry] = []
    var Rank3LineArray:[ChartDataEntry] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        LineCChartView.noDataText = "You need to provide data for the chart"
        basicData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        Rank1LineData = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
        Rank2LineData = [2, 4, 5, 9, 10, 11, 12, 15, 12, 12, 12 , 11, 10, 10, 10, 13, 15, 16, 18, 18, 18, 20, 22, 25]
        Rank3LineData = [1, 2, 3, 4 ,5, 6, 7, 8, 10, 11, 13, 15, 16, 15, 14, 14, 14, 14, 14, 14, 15, 15, 16, 17]
        SetUpLineCChart(name: yarisTime, basic: basicData, values1: Rank1LineData, values2: Rank2LineData, values3:Rank3LineData)
        //let count = Int(arc4random_uniform(20) + 3)
        //setChartValues(count)
        UpdateRankSongs()
    }
    
    func SetUpLineCChart(name:[String], basic:[Double], values1:[Double], values2:[Double], values3:[Double])
    {
        
        
        //設置整個Chart的面板
        //LineKChartView.frame = CGRect(x:0, y:20, width: self.view.bounds.width-5, height: 250) // 設置整個曲線圖位置與大小
        LineCChartView.leftAxis.axisMinimum = 0
        LineCChartView.leftAxis.labelCount = 10 // y 軸展示 10 個分點
        LineCChartView.xAxis.labelCount = 24
        LineCChartView.legend.enabled = false; // 在圖下顯示圖名
        LineCChartView.doubleTapToZoomEnabled = false; //不允許雙雙擊縮放
        LineCChartView.leftAxis.enabled = false; //不顯示橫條線
        LineCChartView.xAxis.enabled = true; //顯示直條線
        //LineKChartView.xAxis.labelHeight = 50
        LineCChartView.xAxis.labelPosition = .bottom;
        LineCChartView.xAxis.labelTextColor = UIColor(red:255/255, green: 255/255, blue:255/255, alpha: 1)
        
        LineCChartView.rightAxis.enabled = false; //不顯示橫條線
        
        // data 用來放整個Chart中的每一條折線數據
        //let data = LineChartData()
        
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
        
        // Set Up 每一條折線
        // 第一名 綠色
        for i in 0..<name.count{
            let y = values1[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values1[i])
            Rank1LineArray.append(data)
        }
        //第一條折線名稱
        let Rank1LineDataSet =  LineChartDataSet(entries:Rank1LineArray, label: "HWASA - TWIT")
        //linedataset.drawFilledEnabled = true;
        //linedataset.fillAlpha = 0.5;
        Rank1LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)]
        //linedataset.circleHoleRadius = 1
        Rank1LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank1LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank1LineDataSet.drawValuesEnabled = false;
        
        data.addDataSet(Rank1LineDataSet)
        
        // 第二名 藍色
        for i in 0..<name.count{
            let y = values2[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values2[i])
            Rank2LineArray.append(data)
        }
        let Rank2LineDataSet = LineChartDataSet(entries: Rank2LineArray, label: "Whee In - Good Bye")
        Rank2LineDataSet.lineWidth = 3
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
        Rank2LineDataSet.circleRadius = 0
        Rank2LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank2LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank2LineDataSet)
        
        
        // 第三名 粉色
        for i in 0..<name.count{
            let y = values3[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values3[i])
            Rank3LineArray.append(data)
        }
        //第一條折線名稱
        let Rank3LineDataSet = LineChartDataSet(entries:Rank3LineArray, label: "HWASA - TWIT")
        
        Rank3LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        //linedataset.circleHoleRadius = 1
        Rank3LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank3LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank3LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank3LineDataSet)
        
        self.LineCChartView.data = data
        var axisFormatDelgate: IAxisValueFormatter?
        LineCChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yarisTime)
        LineCChartView.xAxis.granularity = 1
    }
    
    private func UpdateRankSongs()
    {
        CSongRankArray.removeAll()
        CSongRankArray.append(SongRank(Rank:"Rank1", Grade:30, Cover:"Yellow Flower", SongName:"Rude Boy", Singer:"MAMAMOO", Category: .Korean))
        CSongRankArray.append(SongRank(Rank: "Rank2", Grade: 20, Cover: "Yellow Flower", SongName: "Starry Night", Singer: "MAMAMOO", Category: .Korean))
        CSongRankArray.append(SongRank(Rank: "Rank3", Grade: 10, Cover: "Yellow Flower", SongName: "Spring Fever", Singer: "MAMAMOO", Category: .Korean))
        CSongRankArray.append(SongRank(Rank: "Rank4", Grade: 5, Cover: "Yellow Flower", SongName: "Be Clam", Singer: "MAMAMOO", Category: .Korean))
        CSongRankArray.append(SongRank(Rank: "Rank5", Grade: 2, Cover: "Yellow Flower", SongName: "Paint me", Singer: "MAMAMOO", Category: .Korean))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CSongRankArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CChartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CSongsRankTableViewCell
        
        cell.RankCell.image = UIImage(named: CSongRankArray[indexPath.row].Rank)
        cell.CoverCell.image = UIImage(named: CSongRankArray[indexPath.row].Cover)
        cell.SongNameCell.text = CSongRankArray[indexPath.row].SongName
        cell .SingerCell.text = CSongRankArray[indexPath.row].Singer
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row + 1)
    }
    
    
}

class KChart:UIViewController, UITableViewDelegate, UITableViewDataSource{
    //@IBOutlet weak var LineKChartView: LineChartView!
    
    @IBOutlet weak var LineKChartView: LineChartView!
    @IBOutlet weak var KChartTableView: UITableView!
    
    var KSongRankArray = [SongRank]()
    
    let yarisTime:Array<String> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    
    
    let data = LineChartData()
    
    var basicData:Array<Double> = []
    var Rank1LineData:Array<Double> = [] // Line Chart 中的 數據點
    var Rank2LineData:Array<Double> = []
    var Rank3LineData:Array<Double> = []
    
    var Rank1LineDataSet = LineChartDataSet()
    var Rank2LineDataSet = LineChartDataSet()
    var Rank3LineDataSet = LineChartDataSet()
    
    var basicArray:[ChartDataEntry] = []
    var Rank1LineArray:[ChartDataEntry] = []
    var Rank2LineArray:[ChartDataEntry] = []
    var Rank3LineArray:[ChartDataEntry] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        LineKChartView.noDataText = "You need to provide data for the chart"
        basicData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        Rank1LineData = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30 , 24, 20, 28, 22, 29, 23, 21, 27, 24, 20, 20, 25]
        Rank2LineData = [2, 4, 5, 9, 10, 11, 12, 15, 12, 12, 12 , 11, 10, 10, 10, 13, 15, 16, 18, 18, 18, 20, 22, 25]
        Rank3LineData = [1, 2, 3, 4 ,5, 6, 7, 8, 10, 11, 13, 15, 16, 15, 14, 14, 14, 14, 14, 14, 15, 15, 16, 17]
        SetUpLineKChart(name: yarisTime, basic: basicData, values1: Rank1LineData, values2: Rank2LineData, values3:Rank3LineData)
        //let count = Int(arc4random_uniform(20) + 3)
        //setChartValues(count)
        UpdateRankSongs()
    }
    
    func SetUpLineKChart(name:[String], basic:[Double], values1:[Double], values2:[Double], values3:[Double])
    {
        
        
        //設置整個Chart的面板
        //LineKChartView.frame = CGRect(x:0, y:20, width: self.view.bounds.width-5, height: 250) // 設置整個曲線圖位置與大小
        LineKChartView.leftAxis.axisMinimum = 0
        LineKChartView.leftAxis.labelCount = 10 // y 軸展示 10 個分點
        LineKChartView.xAxis.labelCount = 24
        LineKChartView.legend.enabled = false; // 在圖下顯示圖名
        LineKChartView.doubleTapToZoomEnabled = false; //不允許雙雙擊縮放
        LineKChartView.leftAxis.enabled = false; //不顯示橫條線
        LineKChartView.xAxis.enabled = true; //顯示直條線
        //LineKChartView.xAxis.labelHeight = 50
        LineKChartView.xAxis.labelPosition = .bottom;
        LineKChartView.xAxis.labelTextColor = UIColor(red:255/255, green: 255/255, blue:255/255, alpha: 1)
        
        LineKChartView.rightAxis.enabled = false; //不顯示橫條線
        
        // data 用來放整個Chart中的每一條折線數據
        //let data = LineChartData()
        
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
        
        // Set Up 每一條折線
        // 第一名 綠色
        for i in 0..<name.count{
            let y = values1[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values1[i])
            Rank1LineArray.append(data)
        }
        //第一條折線名稱
        let Rank1LineDataSet =  LineChartDataSet(entries:Rank1LineArray, label: "HWASA - TWIT")
        //linedataset.drawFilledEnabled = true;
        //linedataset.fillAlpha = 0.5;
        Rank1LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)]
        //linedataset.circleHoleRadius = 1
        Rank1LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank1LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank1LineDataSet.drawValuesEnabled = false;
        
        data.addDataSet(Rank1LineDataSet)
        
        // 第二名 藍色
        for i in 0..<name.count{
            let y = values2[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values2[i])
            Rank2LineArray.append(data)
        }
        let Rank2LineDataSet = LineChartDataSet(entries: Rank2LineArray, label: "Whee In - Good Bye")
        Rank2LineDataSet.lineWidth = 3
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
        Rank2LineDataSet.circleRadius = 0
        Rank2LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank2LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank2LineDataSet)
        
        
        // 第三名 粉色
        for i in 0..<name.count{
            let y = values3[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values3[i])
            Rank3LineArray.append(data)
        }
        //第一條折線名稱
        let Rank3LineDataSet = LineChartDataSet(entries:Rank3LineArray, label: "HWASA - TWIT")
        
        Rank3LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        //linedataset.circleHoleRadius = 1
        Rank3LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank3LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank3LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank3LineDataSet)
        
        self.LineKChartView.data = data
        var axisFormatDelgate: IAxisValueFormatter?
        LineKChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yarisTime)
        LineKChartView.xAxis.granularity = 1
    }
    
    @IBAction func ShowRank1Line(_ sender: UIButton) {
        print("clickYes    1")
        //data.removeDataSet(Rank1LineDataSet)
        //data.removeDataSet(Rank2LineDataSet)
        //data.removeDataSet(Rank3LineDataSet)
        //LineKChartView.data = data
        
        /*for i in 0..<yarisTime.count{
         let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:Rank1LineData[i])
         Rank3LineArray.append(data)
         }*/
        
        data.removeEntry(ChartDataEntry(x: Double(0), y: Rank1LineData[0]), dataSetIndex: 0)
        data.removeDataSet(Rank1LineDataSet)
        
        
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)]
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)]
        LineKChartView.data = data
        
        print("Remove Line 1")
        //data.addDataSet(Rank1LineDataSet)
        //data.addDataSet(Rank2LineDataSet)
        //data.addDataSet(Rank3LineDataSet)
    }
    
    
    
    @IBAction func ShowRank2Line(_ sender: UIButton) {
        data.removeDataSet(Rank1LineDataSet)
        data.removeDataSet(Rank2LineDataSet)
        data.removeDataSet(Rank3LineDataSet)
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 0.4)]
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 1)]
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)]
        print("Remove Line 22")
        data.addDataSet(Rank1LineDataSet)
        data.addDataSet(Rank2LineDataSet)
        data.addDataSet(Rank3LineDataSet)
    }
    
    
    @IBAction func ShowRank3Line(_ sender: UIButton) {
        data.removeDataSet(Rank1LineDataSet)
        data.removeDataSet(Rank2LineDataSet)
        data.removeDataSet(Rank3LineDataSet)
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 0.4)]
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 1)]
        data.addDataSet(Rank1LineDataSet)
        data.addDataSet(Rank2LineDataSet)
        data.addDataSet(Rank3LineDataSet)
    }
    

    private func UpdateRankSongs()
    {
        KSongRankArray.removeAll()
        KSongRankArray.append(SongRank(Rank:"Rank1", Grade:30, Cover:"Red Moon", SongName:"Sleep in the car", Singer:"MAMAMOO", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank2", Grade: 20, Cover: "Red Moon", SongName: "Summer Night's Dream", Singer: "MAMAMOO", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank3", Grade: 10, Cover: "Red Moon", SongName: "Egotistic", Singer: "MAMAMOO", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank4", Grade: 5, Cover: "Red Moon", SongName: "Selfish", Singer: "MAMAMOO", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank5", Grade: 2, Cover: "Red Moon", SongName: "Rainy Season", Singer: "MAMAMOO", Category: .Korean))
        KSongRankArray.append(SongRank(Rank:"Rank6", Grade:30, Cover:"Red Moon", SongName:"Sleep in the car", Singer:"MAMAMOO", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank7", Grade: 0, Cover: "", SongName: "", Singer: "", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank8", Grade: 0, Cover: "", SongName: "", Singer: "", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank9", Grade: 0, Cover: "", SongName: "", Singer: "", Category: .Korean))
        KSongRankArray.append(SongRank(Rank: "Rank10", Grade: 0, Cover: "", SongName: "", Singer: "", Category: .Korean))
        
        print(KSongRankArray[0].Grade)
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
        
        cell.RankCell.image = UIImage(named: KSongRankArray[indexPath.row].Rank)
        cell.CoverCell.image = UIImage(named: KSongRankArray[indexPath.row].Cover)
        cell.SongNameCell.text = KSongRankArray[indexPath.row].SongName
        cell .SingerCell.text = KSongRankArray[indexPath.row].Singer
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


class ＷChart:UIViewController , UITableViewDelegate, UITableViewDataSource{
    //@IBOutlet weak var LineKChartView: LineChartView!
    
    @IBOutlet weak var LineWChartView: LineChartView!
    @IBOutlet weak var WChartTableView: UITableView!
    
    let yarisTime:Array<String> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    
    var WSongRankArray = [SongRank]()
    
    let data = LineChartData()
    
    var basicData:Array<Double> = []
    var Rank1LineData:Array<Double> = [] // Line Chart 中的 數據點
    var Rank2LineData:Array<Double> = []
    var Rank3LineData:Array<Double> = []
    
    var Rank1LineDataSet = LineChartDataSet()
    var Rank2LineDataSet = LineChartDataSet()
    var Rank3LineDataSet = LineChartDataSet()
    
    var basicArray:[ChartDataEntry] = []
    var Rank1LineArray:[ChartDataEntry] = []
    var Rank2LineArray:[ChartDataEntry] = []
    var Rank3LineArray:[ChartDataEntry] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        LineWChartView.noDataText = "You need to provide data for the chart"
        basicData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        Rank1LineData = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30 , 24, 20, 28, 22, 29, 23, 21, 27, 24, 20, 20, 25]
        Rank2LineData = [2, 4, 5, 9, 10, 11, 12, 15, 12, 12, 12 , 11, 10, 10, 10, 13, 15, 16, 18, 18, 18, 20, 22, 25]
        Rank3LineData = [1, 2, 3, 4 ,5, 6, 7, 8, 10, 11, 13, 15, 16, 15, 14, 14, 14, 14, 14, 14, 15, 15, 16, 17]
        SetUpLineKChart(name: yarisTime, basic: basicData, values1: Rank1LineData, values2: Rank2LineData, values3:Rank3LineData)
        //let count = Int(arc4random_uniform(20) + 3)
        //setChartValues(count)
        UpdateRankSongs()
    }
    
    func SetUpLineKChart(name:[String], basic:[Double], values1:[Double], values2:[Double], values3:[Double])
    {
        
        
        //設置整個Chart的面板
        //LineKChartView.frame = CGRect(x:0, y:20, width: self.view.bounds.width-5, height: 250) // 設置整個曲線圖位置與大小
        LineWChartView.leftAxis.axisMinimum = 0
        LineWChartView.leftAxis.labelCount = 10 // y 軸展示 10 個分點
        LineWChartView.xAxis.labelCount = 24
        LineWChartView.legend.enabled = false; // 在圖下顯示圖名
        LineWChartView.doubleTapToZoomEnabled = false; //不允許雙雙擊縮放
        LineWChartView.leftAxis.enabled = false; //不顯示橫條線
        LineWChartView.xAxis.enabled = true; //顯示直條線
        //LineKChartView.xAxis.labelHeight = 50
        LineWChartView.xAxis.labelPosition = .bottom;
        LineWChartView.xAxis.labelTextColor = UIColor(red:255/255, green: 255/255, blue:255/255, alpha: 1)
        
        LineWChartView.rightAxis.enabled = false; //不顯示橫條線
        
        // data 用來放整個Chart中的每一條折線數據
        //let data = LineChartData()
        
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
        
        // Set Up 每一條折線
        // 第一名 綠色
        for i in 0..<name.count{
            let y = values1[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values1[i])
            Rank1LineArray.append(data)
        }
        //第一條折線名稱
        let Rank1LineDataSet =  LineChartDataSet(entries:Rank1LineArray, label: "HWASA - TWIT")
        //linedataset.drawFilledEnabled = true;
        //linedataset.fillAlpha = 0.5;
        Rank1LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)]
        //linedataset.circleHoleRadius = 1
        Rank1LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank1LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 0)]
        Rank1LineDataSet.drawValuesEnabled = false;
        
        data.addDataSet(Rank1LineDataSet)
        
        // 第二名 藍色
        for i in 0..<name.count{
            let y = values2[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values2[i])
            Rank2LineArray.append(data)
        }
        let Rank2LineDataSet = LineChartDataSet(entries: Rank2LineArray, label: "Whee In - Good Bye")
        Rank2LineDataSet.lineWidth = 3
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
        Rank2LineDataSet.circleRadius = 0
        Rank2LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank2LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank2LineDataSet)
        
        
        // 第三名 粉色
        for i in 0..<name.count{
            let y = values3[i]
            if y == 0 {continue}
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:values3[i])
            Rank3LineArray.append(data)
        }
        //第一條折線名稱
        let Rank3LineDataSet = LineChartDataSet(entries:Rank3LineArray, label: "HWASA - TWIT")
        
        Rank3LineDataSet.lineWidth = 3 // 設置折線寬度
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)] // 設置折線顏色：粉色
        //linedataset.circleHoleRadius = 1
        Rank3LineDataSet.circleRadius = 0 // 設置折線上節點圓半徑
        Rank3LineDataSet.circleColors = [UIColor(red:255/155, green: 255/255, blue:255/255, alpha: 1)]
        Rank3LineDataSet.drawValuesEnabled = false;
        data.addDataSet(Rank3LineDataSet)
        
        self.LineWChartView.data = data
        var axisFormatDelgate: IAxisValueFormatter?
        LineWChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yarisTime)
        LineWChartView.xAxis.granularity = 1
    }
    
    
    /*func ShowRank2Line()
     {
     Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 0.4)]
     Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
     Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 1)]
     }*/
    
    
    
    
    
    @IBAction func ShowRank1Line(_ sender: UIButton) {
        print("clickYes    1")
        //data.removeDataSet(Rank1LineDataSet)
        //data.removeDataSet(Rank2LineDataSet)
        //data.removeDataSet(Rank3LineDataSet)
        //LineKChartView.data = data
        
        /*for i in 0..<yarisTime.count{
         let data:ChartDataEntry = ChartDataEntry(x: Double(i), y:Rank1LineData[i])
         Rank3LineArray.append(data)
         }*/
        
        data.removeEntry(ChartDataEntry(x: Double(0), y: Rank1LineData[0]), dataSetIndex: 0)
        data.removeDataSet(Rank1LineDataSet)
        
        
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 1)]
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)]
        LineWChartView.data = data
        
        print("Remove Line 1")
        //data.addDataSet(Rank1LineDataSet)
        //data.addDataSet(Rank2LineDataSet)
        //data.addDataSet(Rank3LineDataSet)
    }
    
    
    
    @IBAction func ShowRank2Line(_ sender: UIButton) {
        data.removeDataSet(Rank1LineDataSet)
        data.removeDataSet(Rank2LineDataSet)
        data.removeDataSet(Rank3LineDataSet)
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 0.4)]
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 1)]
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 0.4)]
        print("Remove Line 22")
        data.addDataSet(Rank1LineDataSet)
        data.addDataSet(Rank2LineDataSet)
        data.addDataSet(Rank3LineDataSet)
    }
    
    
    @IBAction func ShowRank3Line(_ sender: UIButton) {
        data.removeDataSet(Rank1LineDataSet)
        data.removeDataSet(Rank2LineDataSet)
        data.removeDataSet(Rank3LineDataSet)
        Rank1LineDataSet.colors = [UIColor(red:106/255, green: 189/255, blue:102/255, alpha: 0.4)]
        Rank2LineDataSet.colors = [UIColor(red:4/255, green: 173/255, blue:223/255, alpha: 0.4)]
        Rank3LineDataSet.colors = [UIColor(red:255/255, green: 118/255, blue:166/255, alpha: 1)]
        data.addDataSet(Rank1LineDataSet)
        data.addDataSet(Rank2LineDataSet)
        data.addDataSet(Rank3LineDataSet)
    }
    
    private func UpdateRankSongs()
    {
        WSongRankArray.removeAll()
        WSongRankArray.append(SongRank(Rank:"Rank1", Grade:30, Cover:"Purple", SongName:"Yes I am", Singer:"MAMAMOO", Category: .Korean))
        WSongRankArray.append(SongRank(Rank: "Rank2", Grade: 20, Cover: "Purple", SongName: "Finally", Singer: "MAMAMOO", Category: .Korean))
        WSongRankArray.append(SongRank(Rank: "Rank3", Grade: 10, Cover: "Purple", SongName: "Love & Hate", Singer: "MAMAMOO", Category: .Korean))
        WSongRankArray.append(SongRank(Rank: "Rank4", Grade: 5, Cover: "Purple", SongName: "DA DA DA", Singer: "MAMAMOO", Category: .Korean))
        WSongRankArray.append(SongRank(Rank: "Rank5", Grade: 2, Cover: "Purple", SongName: "AGE GAG", Singer: "MAMAMOO", Category: .Korean))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WSongRankArray.count
        //return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WChartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! WSongsRankTableViewCell
        
        cell.RankCell.image = UIImage(named: WSongRankArray[indexPath.row].Rank)
        cell.CoverCell.image = UIImage(named: WSongRankArray[indexPath.row].Cover)
        cell.SongNameCell.text = WSongRankArray[indexPath.row].SongName
        cell .SingerCell.text = WSongRankArray[indexPath.row].Singer
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}


class SongRank{
    let Rank: String
    let Grade: Int
    let Cover: String
    let SongName: String
    let Singer: String
    let Category: SongType
    
    init(Rank:String, Grade: Int, Cover: String, SongName: String, Singer: String, Category:SongType)
    {
        self.Rank = Rank
        self.Grade = Grade
        self.Cover = Cover
        self.SongName = SongName
        self.Singer = Singer
        self.Category = Category
    }
}
