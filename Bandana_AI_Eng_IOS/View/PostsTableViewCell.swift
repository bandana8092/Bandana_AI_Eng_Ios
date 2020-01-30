//
//  PostsTableViewCell.swift
//  Bandana_AI_Eng_IOS
//
//  Created by Swaminath Kosetty on 30/01/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //Mark:-Cell Update
    func updateCell(postModel:[PostModel],indexPath:IndexPath){
        self.titleLabel.text = postModel[indexPath.row].title
        self.dateLabel.text = ViewModel.shared.updateDateFormat(date: postModel[indexPath.row].createdDate)
        self.switchButton.isOn =  postModel[indexPath.row].switchStatus
        self.contentView.backgroundColor = postModel[indexPath.row].switchStatus ? UIColor.lightGray : UIColor.white
        
    }
}
