//
//  Widget.Swift
//  Widgets
//
//  Created by Michael Long on 2/26/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

// Widget Core

public protocol Widget: WidgetIdentifying, WidgetPropertyProviding {

    var children: [Widget] { get }

    var view: UIView? { get }

    func getProperty(_ key: String) -> WidgetProperty?
    func setProperty(_ property: WidgetProperty)

    func build(_ context: WidgetContext) -> UIView?
    func viewAddedToSuperview()

}
