//
//  ImageCarouselCell.swift
//  testIntUIKIT
//
//  Created by Hassan Aljanahi on 08/10/2023.
//

import UIKit

class ImageCarouselCell: UICollectionViewCell {
    
    
    @IBOutlet var imageView: UIImageView!
    var task: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task?.cancel()
    }
    
    func setup(url: String) {
        
        task = imageView.getImage(url: url)
        task?.resume()
    }
}
