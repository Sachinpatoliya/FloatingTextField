//
//  ViewController.swift
//  FloatingTextField
//
//  Created by Edexa_IOS on 16/03/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var viewText: MaterialTextField!
    @IBOutlet weak var viewTextView: MaterialTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.viewTextView.setUpField(font: UIFont.systemFont(ofSize: 17))
            self.viewText.setUpFields(font: UIFont.systemFont(ofSize: 17), leadingImage: "email", fieldType: .none)
            
////            To get text you can use this
//
//            viewText.getText()
//
////            To set text you can use this once textfield initialize
//
//            viewText.setText(text: "Material design")
//
////            To set error message you can use
//
//            viewText.errorMessage = "Please insert valid Email address"
        }
    }


}

