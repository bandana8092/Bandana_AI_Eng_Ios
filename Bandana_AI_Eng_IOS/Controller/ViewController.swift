//
//  ViewController.swift
//  Bandana_AI_Eng_IOS
//
//  Created by Swaminath Kosetty on 30/01/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Mark:- Variable Declaration
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Selected Row: 0"
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        postsTableView.addSubview(refreshControl)
        self.spinner.isHidden = true
        self.postsTableView.isHidden = true
        GlobalMethodClass.shared.showActivityIndicator(view: self.view, targetVC: self)
        if GlobalMethodClass.shared.isConnectedToNetwork() == true {
            ViewModel.shared.getPosts { (error) in
                if error == nil{
                    DispatchQueue.main.async {
                        GlobalMethodClass.shared.hideActivityIndicator(view: self.view)
                        self.postsTableView.isHidden = false
                        self.postsTableView.reloadData()
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    //Mark:- Refresh Action
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        ViewModel.shared.pageCount = 0
        self.postsTableView.isHidden = true
        ViewModel.shared.postModel.removeAll()
        self.navigationItem.title = "Selected Row: 0"
        fetchMoreData()
        refreshControl.endRefreshing()
        self.postsTableView.reloadData()
        
    }
    //Mark:- FetchMoreData
    func fetchMoreData(){
        if GlobalMethodClass.shared.isConnectedToNetwork() == true {
            ViewModel.shared.getPosts { (error) in
                if error == nil{
                    DispatchQueue.main.async {
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.postsTableView.isHidden = false
                        self.postsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //Mark:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.shared.postModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostsTableViewCell
        cell.updateCell(postModel: ViewModel.shared.postModel ,indexPath: indexPath)
        cell.selectionStyle = .none
        
        return  cell
    }
    //Mark:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ViewModel.shared.updateSwitchStatus(postModel: ViewModel.shared.postModel, indexPath:indexPath as NSIndexPath) { (error) in
            if error == nil{
                
                let filteredArr = ViewModel.shared.postModel.filter{$0.switchStatus == true}
                if filteredArr.count > 0{
                    self.navigationItem.title = "Selected Row: \(filteredArr.count)"
                }else{
                    self.navigationItem.title = "Selected Row: 0"
                }
                self.postsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if   indexPath.row == ViewModel.shared.postModel.count - 1 {
            spinner.isHidden = false
            spinner.startAnimating()
            if ViewModel.shared.totalPages > ViewModel.shared.currentPage {
                ViewModel.shared.pageCount += 1
                fetchMoreData()
            }else{
                spinner.isHidden = true
                spinner.stopAnimating()
            }
        }
    }
    
}

