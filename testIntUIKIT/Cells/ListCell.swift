//
//  ListCell.swift
//  testIntUIKIT
//
//  Created by Hassan Aljanahi on 08/10/2023.
//

import UIKit

class ListCell: UITableViewCell {
    
    
    @IBOutlet var imageViewL: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var task: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task?.cancel()
    }
    
    func setup(url: String, title: String) {
        
        task = imageViewL.getImage(url: url)
        task?.resume()
        self.titleLabel.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
