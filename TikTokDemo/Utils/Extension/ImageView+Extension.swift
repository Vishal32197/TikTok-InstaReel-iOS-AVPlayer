//
//  ImageView+Extension.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let imageData = try? Data(contentsOf: url),
                  let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
