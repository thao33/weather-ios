//
//  ExtensionUIImageView.swift
//  Weather-ios
//
//  Created by Thao Truong on 3/28/20.
//  Copyright © 2020 Thao Truong. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFrom(url: String) {
        let imageUrl = URL(string: url)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageUrl!)
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
    }
}
