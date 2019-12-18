//
//  SongsTableViewCell.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/9/21.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import UIKit

// For RankViewController
class KSongsRankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RankCell: UIImageView!
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

class CSongsRankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RankCell: UIImageView!
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class WSongsRankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RankCell: UIImageView!
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class SongsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class MyPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var MyPageFuncIconCell: UIImageView!
    
    @IBOutlet weak var MyPageFuncLabelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class TopicListSongTableViewCell:UITableViewCell{
    
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    //@IBOutlet weak var LikeHeartCell: UIImageView!
    @IBOutlet weak var LikeHeartButtonCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class SongFindTableViewCell:UITableViewCell{
    
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    @IBOutlet weak var LikeHeartButtonCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class SongFindRecordCell: UITableViewCell{
    
    @IBOutlet weak var RecordStringCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class ThemeListCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var ThemeListButton: UIButton!
    
}
