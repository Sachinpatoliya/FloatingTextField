//
//  MaterialTextView.swift
//  textfield
//
//  Created by Edexa_IOS on 15/03/22.
//

import Foundation
import UIKit

class MaterialTextView: UIView, UITextViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add custom code here
        // We don't need to call our fun here cause this for programmatic created UIView object
        
//        setUpField()
    }
    // Story Board Initialization
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
        // Add custom code here
        
    }
    
    private var borderOutlineColor: UIColor = .black
    private var floatingLabelColor: UIColor = .black
    private var textFieldColor: UIColor = .black
    private var usedFont: UIFont = UIFont.systemFont(ofSize: 17)
    private var errorMessageColor: UIColor = .red
    private var placeholder: String = ""
    private var floatingFontSize: CGFloat = 12
    private var textLimitValue: String = "0"
    
    private var label: UILabel!
    private var labelErrorMsj: UILabel!
    private var txtView: UITextView!
    private var viewField: UIView!
    private var originalFrame: CGRect!
    private var tmpFrame: CGRect!
    var cornerradius: CGFloat = 10
    
    public var errorMessage: String? {
        didSet {
            setErroMessageLabelHeight(isBlank: false)
        }
    }

    @IBInspectable var placeHolderMessage: String? {
        get {
           return placeholder
        }
        set {
            placeholder = newValue!
        }
    }

    @IBInspectable var textLimit: String? {
        get {
           return textLimitValue
        }
        set {
            textLimitValue = newValue!
        }
    }

    @IBInspectable var outlineColor: UIColor? {
        get {
           return borderOutlineColor
        }
        set {
            borderOutlineColor = newValue!
        }
    }
    
    @IBInspectable var floatingColor: UIColor? {
        get {
           return floatingLabelColor
        }
        set {
            floatingLabelColor = newValue!
        }
    }
    
    @IBInspectable var errorColor: UIColor? {
        get {
           return errorMessageColor
        }
        set {
            errorMessageColor = newValue!
        }
    }


    @IBInspectable var TextColor: UIColor? {
        get {
           return textFieldColor
        }
        set {
            textFieldColor = newValue!
        }
    }
    
    func setUpField(font: UIFont, cornerradius: CGFloat = 0){
        self.cornerradius = cornerradius
        usedFont = font
        setUpLabel()
        setUpBackView()
        setTextField()
        setErroMessageLbl()
        self.addSubview(viewField)
        self.addSubview(label)
        self.addSubview(txtView)
        self.addSubview(labelErrorMsj)
    }
    
    private func setTextField(){
        txtView = UITextView(frame: CGRect (x: 10, y: 10, width: self.bounds.width - 20, height: self.bounds.height))
        txtView.backgroundColor = .clear
        txtView.delegate = self
        txtView.textColor = textFieldColor
        txtView.font = usedFont
    }
    
    private func setErroMessageLbl(){
        labelErrorMsj = UILabel(frame: CGRect (x: 0, y: viewField.frame.height, width: self.bounds.width, height: 0))
        labelErrorMsj.textAlignment = .left
        labelErrorMsj.textColor = errorMessageColor
        labelErrorMsj.font = UIFont (name: usedFont.fontName, size: floatingFontSize)
        labelErrorMsj.sizeToFit()
        labelErrorMsj.numberOfLines = 0
        labelErrorMsj.font = usedFont
    }
        
    func setText(text: String){
        txtView.text = text
        if txtView.text == "" {
            setFloatingPlaceholderWhileDismissing()
        }else{
            setFloatingPlaceholder(isChangePlaceHolder: true, isFromSetText: true)
        }
    }
    
    func getText() -> String{
        return txtView.text ?? ""
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        setFloatingPlaceholder(isChangePlaceHolder: true, isFromSetText: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setFloatingPlaceholderWhileDismissing()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = Int(textLimit ?? "0") ?? 0
        if textView == txtView && maxLength > 0{
           let currentString: NSString = textView.text! as NSString
           let newString: NSString =
               currentString.replacingCharacters(in: range, with: text) as NSString
            if newString.length >= maxLength{
                errorMessage = "\(maxLength)/\(maxLength)"
            }else{
                errorMessage = ""
            }
           return newString.length <= maxLength
       }
        return true
    }
        
    private func setFloatingPlaceholder(isChangePlaceHolder: Bool, isFromSetText: Bool){//Handling floating label while start editing
        if self.txtView.text == "" && isFromSetText{ return }
        self.setErroMessageLabelHeight(isBlank: true)
        label.text = " \(placeHolderMessage ?? "") "
        self.label.font = isChangePlaceHolder ? UIFont (name: usedFont.fontName, size: floatingFontSize) : usedFont
        self.label.sizeToFit()
        tmpFrame = CGRect(x: 10, y: -(label.frame.height/2), width: label.frame.width, height: label.frame.height)
        for item in viewField.layer.sublayers ?? []{
            if ((item as? CAShapeLayer) != nil) {
                item.removeFromSuperlayer()
            }
        }
        drawRectangle(view: viewField, label: label, isCut: isChangePlaceHolder)
        UIView.animate(withDuration: 0.3) {
            self.label.frame = self.tmpFrame
            self.label.sizeToFit()
        }
    }

    private func setFloatingPlaceholderWhileDismissing(){
        if txtView.text == "" {
            label.font = usedFont
        }else{
            self.label.font = UIFont (name: usedFont.fontName, size: floatingFontSize)
            return
        }
        self.label.sizeToFit()
        for item in viewField.layer.sublayers ?? []{
            if ((item as? CAShapeLayer) != nil) {
                item.removeFromSuperlayer()
            }
        }

        UIView.animate(withDuration: 0.1) {
            self.label.frame = self.originalFrame
            self.label.sizeToFit()
            self.drawRectangle(view: self.viewField, label: self.label, isCut: self.txtView.text == "" ? false : true)
        }
    }

    private func setErroMessageLabelHeight(isBlank: Bool){
        self.labelErrorMsj.text = isBlank ? "" : errorMessage
        labelErrorMsj.sizeToFit()
        self.labelErrorMsj.frame = CGRect (x: 0, y: viewField.frame.height, width: self.bounds.width, height: (isBlank || errorMessage == "") ? 0 : labelErrorMsj.frame.height + 10)
        self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: self.viewField.frame.height + (labelErrorMsj.frame.height))
    }
    
    
    private func setUpLabel(){
        originalFrame = CGRect (x: 10, y: 15, width: self.bounds.width - 20, height: self.bounds.height - 20)
        label = UILabel(frame: originalFrame)
        label.textAlignment = .center
        label.text = " \(placeHolderMessage ?? "") "
        label.textColor = floatingColor
        label.font = usedFont
        label.sizeToFit()
        
    }
    
    private func setUpBackView(){
        viewField = UIView(frame: CGRect (x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        self.viewField.backgroundColor = self.viewField.backgroundColor == .clear ? self.viewField.superview?.backgroundColor : .white
        viewField.layer.cornerRadius = self.cornerradius
        drawRectangle(view: viewField, label: label, isCut: false)
        viewField.backgroundColor = .clear
        
        originalFrame = CGRect (x: 10, y: 15, width: self.bounds.width - 20, height: self.bounds.height)
        label.frame = originalFrame
//        label.center.y = viewField.center.y
        label.sizeToFit()

    }

    private func drawRectangle(view: UIView, label: UILabel, isCut: Bool) {
        
        let frameHeight = view.frame.height
        let frameCorner = view.layer.cornerRadius
        let frameWidth = view.frame.width
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: frameCorner, y: 0))
        path.addCurve(to: CGPoint (x: 0, y: frameCorner), controlPoint1: CGPoint (x: 0, y: 0), controlPoint2: CGPoint (x: 0, y: frameCorner))
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = outlineColor!.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: frameCorner))
        path1.addLine(to: CGPoint(x: 0, y: frameHeight - frameCorner))
        path1.addCurve(to: CGPoint (x: frameCorner, y: frameHeight), controlPoint1: CGPoint (x: 0, y: frameHeight), controlPoint2: CGPoint (x: frameCorner, y: frameHeight))
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = outlineColor!.cgColor
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.lineWidth = 1
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: frameCorner, y: frameHeight))
        path2.addLine(to: CGPoint(x: frameWidth - frameCorner, y: frameHeight))
        path2.addCurve(to: CGPoint (x: frameWidth, y: frameHeight - frameCorner), controlPoint1: CGPoint (x: frameWidth, y: frameHeight), controlPoint2: CGPoint (x: frameWidth, y: frameHeight - frameCorner))
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path2.cgPath
        shapeLayer2.strokeColor = outlineColor!.cgColor
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineWidth = 1
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: frameWidth, y: frameHeight - frameCorner))
        path3.addLine(to: CGPoint(x: frameWidth, y: frameCorner))
        path3.addCurve(to: CGPoint (x: frameWidth - frameCorner, y: 0), controlPoint1: CGPoint (x: frameWidth, y: frameCorner), controlPoint2: CGPoint (x: view.frame.width, y: 0))
        
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = path3.cgPath
        shapeLayer3.strokeColor = outlineColor!.cgColor
        shapeLayer3.fillColor = UIColor.clear.cgColor
        shapeLayer3.lineWidth = 1
        
        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x: frameWidth - frameCorner, y: 0))
        path4.addLine(to: CGPoint(x: isCut ? label.frame.width + 12 : 10, y: 0))
        let shapeLayer4 = CAShapeLayer()
        shapeLayer4.path = path4.cgPath
        shapeLayer4.strokeColor = outlineColor!.cgColor
        shapeLayer4.fillColor = UIColor.clear.cgColor
        shapeLayer4.lineWidth = 1

        view.layer.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer3)
        view.layer.addSublayer(shapeLayer4)
    }
}

//
//extension UIView {
//
//    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
//        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
//            constraint.constant = constant
//            self.layoutIfNeeded()
//        }
//    }
//}
