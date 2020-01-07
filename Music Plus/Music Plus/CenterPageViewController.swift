//
//  CenterPageViewController.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/9/20.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import Foundation
import UIKit
var MyListSongIdForCheck:Array<Int> = Array()


class CenterPageViewController: UIPageViewController,FetchSelectRow {
    func fetchInt(rowNumber: Int) {
        if isViewLoaded
        {
            print("===")
            print(rowNumber)
            print("===")
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
    }
    
    
    lazy var subViewControllers:[UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListPage") as! ListPage,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as! HomePage,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePVCRecord") as! HomePVCRecord
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        dataSource = self
        delegate = self
        setViewControllerFromIndex(index: 1)
        
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
                    
                    print("=============")
                    for (index,element) in pl.enumerated()
                    {
                        MyListSongIdForCheck.append(Int(pl[index]) ?? 0)
                    }
                    
                    //[1,3,4]
                    print(MyListSongIdForCheck)
                    print("=============")

                }
                catch {
                    print(error)
                }
            }
        }.resume()
        
        
    }
    
    func setViewControllerFromIndex(index:Int)
    {
        self.setViewControllers([subViewControllers[index]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
}


extension CenterPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
        }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if(currentIndex >= subViewControllers.count - 1){
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
}



// 主頁（一登入的預設頁面），包含排名、推薦歌曲、找歌
class HomePVC: UIPageViewController {
    
    lazy var HomesubViewControllers:[UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePVCRank") as! HomePVCRank,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePVCRecommend") as! HomePVCRecommend
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllerFromIndex(index: 0)
        // Do any additional setup after loading the view.
    }
    
    func setViewControllerFromIndex(index:Int)
    {
        self.setViewControllers([HomesubViewControllers[index]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
    
}

extension HomePVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return HomesubViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = HomesubViewControllers.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return HomesubViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = HomesubViewControllers.index(of: viewController) ?? 0
        if(currentIndex >= HomesubViewControllers.count - 1){
            return nil
        }
        return HomesubViewControllers[currentIndex + 1]
    }
}


/*class HomePVCRank: UIViewController{
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

class HomePVCFind: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}*/


// 歌單，包括自行設定的歌單、主題歌單（如：運動、讀書、天氣等）
class ListPVC: UIPageViewController{
    
    lazy var ListsubViewControllers:[UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListPVCPersonal") as! ListPVCPersonal,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListPVCTheme") as! ListPVCTheme
        ]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllerFromIndex(index: 0)
        // Do any additional setup after loading the view.
    }
    
    func setViewControllerFromIndex(index:Int)
    {
        self.setViewControllers([ListsubViewControllers[index]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
}

extension ListPVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return ListsubViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = ListsubViewControllers.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return ListsubViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = ListsubViewControllers.index(of: viewController) ?? 0
        if(currentIndex >= ListsubViewControllers.count - 1){
            return nil
        }
        return ListsubViewControllers[currentIndex + 1]
    }
}

/*class ListPVCPersonal: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
}

class ListPVCTheme: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}*/

