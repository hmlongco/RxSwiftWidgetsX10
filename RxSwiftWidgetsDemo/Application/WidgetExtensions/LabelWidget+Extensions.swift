//
//  LabelWidget+Extensions.swift
//  Widgets
//
//  Created by Michael Long on 3/6/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

extension LabelWidget {
    public static func footnote() -> LabelWidget {
        return LabelWidget()
            .text(color: .lightGray)
            .text(font: UIFont.footnote)
            .numberOfLines(0)
    }
}
