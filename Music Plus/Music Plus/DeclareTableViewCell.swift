//
//  SongsTableViewCell.swift
//  Music Plus
//
//  Created by 劉品萱 on 2019/9/21.
//  Copyright © 2019 劉品萱. All rights reserved.
//

import UIKit

// For KChart Class
class KSongsRankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RankCell: UIImageView!
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    @IBOutlet weak var LikeHeartButtonCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
// For CChart Class
class CSongsRankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RankCell: UIImageView!
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    @IBOutlet weak var LikeHeartButtonCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
// For WChart Class
class WSongsRankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var RankCell: UIImageView!
    @IBOutlet weak var CoverCell: UIImageView!
    @IBOutlet weak var SongNameCell: UILabel!
    @IBOutlet weak var SingerCell: UILabel!
    @IBOutlet weak var LikeHeartButtonCell: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// For ListPVCPersonal Class
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

//For TopicListSongViewController Class & GenreListSongViewController Class
class TopicListSongTableViewCell:UITableViewCell{
    
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

// For HomePVCFind Class
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

// For HomePVCRecord Class
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

// For HomePVCRecommend Class
class PersonalRecommendCell: UITableViewCell{
    
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

class ThemeListCollectionViewCell:UICollectionViewCell {
    @IBOutlet weak var ThemeListButton: UIButton!
    
}
