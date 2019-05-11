//
//  ImageWidget+Extensions.swift
//  Widgets
//
//  Created by Michael Long on 3/6/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftWidgets

extension ImageWidget {
    public static func round(size: CGFloat) -> ImageWidget {
        return ImageWidget()
            .height(size)
            .width(size)
            .with { (image, _) in
                image.contentMode = .scaleAspectFill
            }
    }
}
