# FloatingTextField

I here by created the floating TextField and TextView.

To setup material TextField and TextView you need to import the class MaterialTextField for textField and MaterialTextView for TextView.

First of all let's check the TextField properties which you need to setup.

You can set the properties which is shown in the image as per your requirement.

![Screenshot 2022-04-23 at 9 22 01 AM](https://user-images.githubusercontent.com/20517881/164874180-573776dc-2270-4e94-96b7-d301ea971a83.png)

Once you create the outlets of the added fields you need to initialize it with this method inside the DispatchQue

*func setUpFields(font: UIFont, leadingImage: String = "", trailingImage: String = "", trailingSelectedImage: String = "", keyboardtype: UIKeyboardType = .default, fieldType: FieldType, cornerradius: CGFloat = 0)*

In above mtethod you can pass which font, leading image name, trailing image name, trailingSelected image name if you want any action on the image, keyboard type, field type it's for password or normal field and corner radius.

NOTE: if you are setting up leading and trailing image then you must need to set the color otherwise it will show clear colored images.

To get text you can use this

*viewText.getText()*

To set text you can use this once textfield initialize

*viewText.setText(text: "Material design")*

To set error message you can use

*viewText.errorMessage = "Please insert valid Email address"*

At the end it will looks like this


You can do same thing for the TextView.

![Simulator Screen Shot - iPhone 12 Pro Max - 2022-04-23 at 09 43 49](https://user-images.githubusercontent.com/20517881/164874847-7dc0e9bb-a0a7-4401-a393-21bb02f4a90d.png)

Feel free to do changes or to update code structure.
