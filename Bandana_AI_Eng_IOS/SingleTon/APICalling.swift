//
//  APICalling.swift
//  Bandana_AI_Eng_IOS
//
//  Created by Swaminath Kosetty on 30/01/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit
import Foundation

class APICalling: NSObject {
    
    static let shared : APICalling = {
        let instance = APICalling()
        return instance
    }()
    
    //Mark:- ApiCalling(Get)
    func getDetailsFromServer(url:String,complitionHandler:@escaping(_ response:NSDictionary?,_ error:NSError?)-> Void){
        let finalUrl = URL(string: url)
        let request = URLRequest(url: finalUrl!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (Data, urlResponse, error) in
            if Data == nil{
               // print("No Data Available")
            }else{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: Data!, options: .mutableContainers)
                    //print(jsonResult)
                    complitionHandler(jsonResult as? NSDictionary,nil)
                    
                }catch{
                    //print("Error")
                    complitionHandler(nil,error as NSError)
                }
                
            }
        }
        task.resume()
        
    }
    
}
