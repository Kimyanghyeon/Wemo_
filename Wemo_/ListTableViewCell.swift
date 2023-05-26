//
//  ListTableViewCell.swift
//  Wemo_
//
//  Created by 김양현 on 2023/05/07.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
 
    @IBOutlet var img_itemImage: UIImageView!
    
    @IBOutlet var btn_name: UIButton!
    
    @IBOutlet var label_shape: UILabel!
    
    @IBOutlet var label_color: UILabel! 
    
    @IBOutlet var label_formulation: UILabel!
    
    @IBOutlet var label_dividingLine: UILabel!
    
    @IBOutlet var label_print: UILabel!
    
    @IBOutlet var label_etcOtcName: UILabel!
    
    @IBOutlet var label_entpName: UILabel!
    
    @IBOutlet var label_className: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btn_name.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn_name.titleLabel?.textAlignment = .center
        btn_name.titleLabel?.lineBreakMode = .byWordWrapping
        
    }//end  of awakeFromNib

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }//end of setSelected
    
   

}//end of class
