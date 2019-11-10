//
//  Images.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import UIKit


class Images {
    func refreshImage() -> UIImage? { return UIImage(named: "btn_refresh_black_normal") }
}


class DefaultLightImages: Images {

}

class DefaultDarkImages: Images {
    override func refreshImage() -> UIImage? { return UIImage(named: "btn_refresh_white_normal") }
}
