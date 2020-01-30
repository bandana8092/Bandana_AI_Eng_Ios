//
//  ViewModel.swift
//  Bandana_AI_Eng_IOS
//
//  Created by Swaminath Kosetty on 30/01/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit
import Foundation

class ViewModel: NSObject {
    
    static let shared : ViewModel = {
        let instance = ViewModel()
        return instance
    }()
    //Mark:- Variable Declaration
    var postModel = [PostModel]()
    var totalPages = 0
    var currentPage = 0
    var pageCount = 0
    
    //Mark:- Api Call
    func getPosts(complitionHandler:@escaping(_ error:NSError?)-> Void){
        APICalling.shared.getDetailsFromServer(url: "\(BASE_URL)\(pageCount)") { (responseData, error) in
            if error == nil{
                //print(responseData!)
                
                if responseData?.object(forKey: "nbPages") != nil{
                    let total = String(describing: responseData!.object(forKey: "nbPages")!)
                    self.totalPages = Int(total) ?? 0
                }
                if responseData?.object(forKey: "page") != nil{
                    let current = String(describing: responseData!.object(forKey: "page")!)
                    self.currentPage = Int(current) ?? 0
                }
                if let arrObj = responseData?.object(forKey: "hits") as? NSArray {
                    
                    for eachObj in arrObj{
                        let modelObj = PostModel(postModel: eachObj as! NSDictionary)
                        self.postModel.append(modelObj)
                    }
                    complitionHandler(nil)
                }else{
                   // print("No Data")
                }
                
            }else{
                //print("error")
                complitionHandler(error)
            }
        }
        
    }
    //Mark:- Switch Status
    func updateSwitchStatus(postModel:[PostModel],indexPath:NSIndexPath,complitionHandler:@escaping(_ error:NSError?)-> Void){
        postModel[indexPath.row].switchStatus = postModel[indexPath.row].switchStatus ? false : true
        complitionHandler(nil)
    }
    //Mark:- Date Extension
    func updateDateFormat(date:String)->String{
        //"2020-01-30T09:46:44.000Z"
        //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let convertedDate = dateFormatter.date(from: date)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm a"
        let requriedDate = dateFormatter1.string(from: convertedDate!)
        return requriedDate
    }
    
    
}
