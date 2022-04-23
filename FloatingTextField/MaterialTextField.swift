//
//  MaterialTextField.swift
//  textfield
//
//  Created by Edexa_IOS on 15/03/22.
//

import UIKit

class MaterialTextField: UIView, UITextFieldDelegate {
    
    enum FieldType{
        case Password
        case none
    }
    
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
    private var trailingImageTintColor: UIColor = .black
    private var leadingImageTingColor: UIColor = .black
    private var fieldType: FieldType = .none
    
    private var label: UILabel!
    private var labelErrorMsj: UILabel!
    var txtField: UITextField!
    private var viewField: UIView!
    private var originalFrame: CGRect!
    private var tmpFrame: CGRect!
    private var leadingImage: String!
    private var trailingImage: String!
    private var trailingSelectedImage: String!
    private var trailingButton: UIButton!
    private var leadingButton: UIButton!
    private var keyboardtype: UIKeyboardType = .default
    var cornerradius: CGFloat = 10
    private var textLimitValue: String = "0"
    
    public var errorMessage: String? {
        didSet {
            setErroMessageLabelHeight(isBlank: false)
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

    @IBInspectable var placeHolderMessage: String? {
        get {
           return placeholder
        }
        set {
            placeholder = newValue!
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
    
    @IBInspectable var trailingImageColor: UIColor? {
        get {
           return trailingImageTintColor
        }
        set {
            trailingImageTintColor = newValue!
        }
    }

    @IBInspectable var leadingImageColor: UIColor? {
        get {
           return leadingImageTingColor
        }
        set {
            leadingImageTingColor = newValue!
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
    
    func setUpFields(font: UIFont, leadingImage: String = "", trailingImage: String = "", trailingSelectedImage: String = "", keyboardtype: UIKeyboardType = .default, fieldType: FieldType, cornerradius: CGFloat = 0){
        usedFont = font
        self.cornerradius = cornerradius
        self.leadingImage = leadingImage
        self.trailingSelectedImage = trailingSelectedImage
        self.trailingImage = trailingImage
        self.keyboardtype = keyboardtype
        self.fieldType = fieldType
        setUpLabel()
        setUpBackView()
        self.addSubview(viewField)
        self.addSubview(label)
        
        setTextField()
        self.addSubview(txtField)
        setTrailingImage()
        setLeadingImage()
        setErroMessageLbl()
        self.addSubview(labelErrorMsj)
    }
    
    private func setTextField(){// Add Textfield
        var width = self.frame.width - 20
        if trailingImage != "" {
            width = width - 50
        }
        
        if leadingImage != "" {
            width = width - 50
        }
        txtField = UITextField(frame: CGRect (x: leadingImage != "" ? 50 : 10, y: 0, width: width, height: self.frame.height))
        txtField.delegate = self
        txtField.textColor = textFieldColor
        txtField.font = usedFont
        txtField.backgroundColor = .clear
        txtField.keyboardType = keyboardtype
        txtField.isSecureTextEntry = fieldType == .Password ? true : false
    }
    
    private func setErroMessageLbl(){// Add Error Message
        labelErrorMsj = UILabel(frame: CGRect (x: 0, y: viewField.frame.height, width: self.bounds.width, height: 0))
        labelErrorMsj.textAlignment = .left
        labelErrorMsj.textColor = errorMessageColor
        labelErrorMsj.font = UIFont (name: usedFont.fontName, size: floatingFontSize)
        labelErrorMsj.sizeToFit()
        labelErrorMsj.numberOfLines = 0
        labelErrorMsj.font = usedFont
    }
    
    private func setTrailingImage(){
        if trailingImage == ""{ return }
        trailingButton = UIButton(frame: CGRect(x: self.frame.width - 50, y: (self.frame.height - 50)/2, width: 50, height: 50))
        trailingButton.setImage(UIImage (named: trailingImage)?.setImageTintColor(with: trailingImageTintColor), for: .normal)
        trailingButton.addTarget(self, action: #selector(trailingImageTapped), for: .touchUpInside)
        trailingButton.backgroundColor = .clear
        trailingButton.tintColor = trailingImageTintColor
        trailingButton.tag = 0
        self.addSubview(trailingButton)
    }
    
    @objc private func setLeadingImage(){
        if leadingImage == ""{ return }
        leadingButton = UIButton(frame: CGRect(x: 0, y: (self.frame.height - 50)/2, width: 50, height: 50))
        leadingButton.setImage(UIImage (named: leadingImage)?.setImageTintColor(with: leadingImageTingColor), for: .normal)
        leadingButton.backgroundColor = .clear
        leadingButton.tintColor = leadingImageTingColor
        leadingButton.tag = 0
        self.addSubview(leadingButton)
    }
    
    @objc private func trailingImageTapped(){
        if self.fieldType == .Password{
            if trailingButton.tag == 0{
                trailingButton.tag = 1
                trailingButton.setImage(UIImage (named: trailingSelectedImage)?.setImageTintColor(with: trailingImageTintColor), for: .normal)
                txtField.isSecureTextEntry = false
            }else{
                trailingButton.tag = 0
                trailingButton.setImage(UIImage (named: trailingImage)?.setImageTintColor(with: trailingImageTintColor), for: .normal)
                txtField.isSecureTextEntry = true
            }
        }
    }
    
    func setText(text: String){
        txtField.text = text
        if txtField.text == "" {
            setFloatingPlaceholderWhileDismissing()
        }else{
            setFloatingPlaceholder(isChangePlaceHolder: true, isFromSetText: true)
        }
    }
    
    func getText() -> String{
        return txtField.text ?? ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setFloatingPlaceholder(isChangePlaceHolder: true, isFromSetText: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setFloatingPlaceholderWhileDismissing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = Int(textLimit ?? "0") ?? 0
        if txtField == txtField && maxLength > 0{
           let currentString: NSString = txtField.text! as NSString
           let newString: NSString =
               currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length >= maxLength{
                errorMessage = "\(maxLength)/\(maxLength)"
            }else{
                errorMessage = ""
            }
           return newString.length <= maxLength
        }else{
            errorMessage = ""
        }
        return true
    }
    
    private func setFloatingPlaceholder(isChangePlaceHolder: Bool, isFromSetText: Bool){//Handling floating label while start editing
        if self.txtField.text == "" && isFromSetText{ return }
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
    
    private func setFloatingPlaceholderWhileDismissing(){//handling floating label while dismiss
        if txtField.text == "" {
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
            self.drawRectangle(view: self.viewField, label: self.label, isCut: self.txtField.text == "" ? false : true)
        }
    }
    
    private func setErroMessageLabelHeight(isBlank: Bool){//Set error message label height and their parent view height based error message
        self.labelErrorMsj.text = isBlank ? "" : errorMessage
        labelErrorMsj.sizeToFit()
        self.labelErrorMsj.frame = CGRect (x: 0, y: viewField.frame.height, width: self.bounds.width, height: (isBlank || errorMessage == "") ? 0 : labelErrorMsj.frame.height + 10)
        self.updateConstraint(attribute: NSLayoutConstraint.Attribute.height, constant: self.viewField.frame.height + (labelErrorMsj.frame.height))
    }
    
    private func setUpLabel(){//Add floating label
        originalFrame = CGRect (x: leadingImage != "" ? 50 : 10, y: self.bounds.height / 2, width: self.bounds.width - 20, height: self.bounds.height - 20)
        label = UILabel(frame: originalFrame)
        label.textAlignment = .left
        label.text = " \(placeHolderMessage ?? "") "
        label.textColor = floatingColor
        label.font = usedFont
        label.sizeToFit()
    }
    
    private func setUpBackView(){//Set a view for the outline
        viewField = UIView(frame: CGRect (x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        self.viewField.backgroundColor = self.viewField.backgroundColor == .clear ? self.viewField.superview?.backgroundColor : .white
        viewField.layer.cornerRadius = cornerradius
        drawRectangle(view: viewField, label: label, isCut: false)
        viewField.backgroundColor = .clear
        
        originalFrame = CGRect (x: leadingImage != "" ? 50 : 10, y: viewField.center.y - (label.frame.size.height / 2), width: self.bounds.width - 20, height: self.label.frame.height)
        label.frame = originalFrame
        label.center.y = viewField.center.y
    }

    private func drawRectangle(view: UIView, label: UILabel, isCut: Bool) {// Draw outline
        
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


extension UIView {

    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.layoutIfNeeded()
        }
    }
}


extension UIImage {
    func setImageTintColor(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
