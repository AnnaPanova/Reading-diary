//
//  UITextView+Extension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 29.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

extension UITextView {
    //  MARK: Setup toolbar and Done button for textView
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        //  create toolBar with done-button for dismissing keyboard
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,y: 0.0,width: UIScreen.main.bounds.size.width,height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
