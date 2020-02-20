//
//  DialpadCell.swift
//  phone
//
//  Created by rutinfc on 2020/02/20.
//  Copyright © 2020 rutinfc. All rights reserved.
//

import UIKit

class DialpadNumberCell: UICollectionViewCell {
    
    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var koreaText: UILabel!
    @IBOutlet weak var engText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 1
        
        self.number.layer.borderColor = UIColor.green.cgColor
        self.number.layer.borderWidth = 1
    }
    
    func setNumber(key:String) {
        self.number.text = key
    }
}
