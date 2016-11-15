//
//  CreateDiary.swift
//  BmobTest
//
//  Created by TDC on 16/9/13.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class CreateDiaryVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var content_tv: UITextView!
    @IBOutlet weak var picture_img: UIImageView!
    @IBOutlet weak var book_btn: UIButton!
    @IBOutlet weak var important_sw: UISwitch!
    
    var saveButtonItem: UIBarButtonItem!
    var doneButtonItem: UIBarButtonItem!
    var imagePicker: UIImagePickerController?
    var saveAlert: UIAlertController! = nil
    var chooseAlert: UIAlertController! = nil
    var bookPicker: UIPickerView?
    
    @IBAction func chooseBookAction(sender: AnyObject) {
        let chooseBookAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        bookPicker = UIPickerView()
        bookPicker!.dataSource = self
        bookPicker!.delegate = self
        chooseBookAlert.view.addSubview(bookPicker!)
        let confirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) in
            self.selectedBook = self.diaryBooks[self.tempSelectedRow]
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        chooseBookAlert.addAction(confirm)
        chooseBookAlert.addAction(cancel)
        presentViewController(chooseBookAlert, animated: true, completion: nil)
    }
    
    var diaryBooks = [DiaryBook]()
    var tempSelectedRow = 0
    var selectedBook: DiaryBook! = nil {
        didSet {
            if selectedBook == nil {
                book_btn.titleLabel?.text = "请选择日记本..."
            } else {
                book_btn.titleLabel?.text = selectedBook?.subject
            }
        }
    }
    var picData: NSData?
    var thumbPicData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "写日记"
        saveButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: #selector(showSaveAlret))
        doneButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(hideKeyBoard))
        navigationItem.rightBarButtonItems = [saveButtonItem]
        
        // 注册键盘弹出通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(moveUpView(_:)), name: UIKeyboardWillShowNotification, object: nil)
        // 注册键盘消失通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(moveDownView), name: UIKeyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(choosePic))
        picture_img.addGestureRecognizer(tap)
        picture_img.userInteractionEnabled = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let user = BmobUser.currentUser()
        if user != nil {
            DiaryBook.queryBooksByUserId(user.objectId) { (books, error) in
                if error == nil {
                    self.diaryBooks.appendContentsOf(books)
                    self.bookPicker?.reloadAllComponents()
                    self.bookPicker?.selectRow(0, inComponent: 0, animated: false)
                } else {
                    let toast = ToastView(text: "网络错误")
                    self.view.addSubview(toast)
                }
            }
        } else {
            let toast = ToastView(text: "未登录")
            self.view.addSubview(toast)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveUpView(notify: NSNotification){
        let keyboardHeight = getKeyboardHeight(notify)
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, Utils.width, Utils.height - keyboardHeight + picture_img.bounds.height + 16)
        navigationItem.rightBarButtonItems = [doneButtonItem]
    }
    
    func moveDownView(){
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, Utils.width, Utils.height)
        navigationItem.rightBarButtonItems = [saveButtonItem]
    }
    
    func getKeyboardHeight(notify: NSNotification) -> CGFloat{
        let userInfo = notify.userInfo! as NSDictionary
        let value = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
        let rect = value?.CGRectValue()
        return (rect?.size.height)!
    }

    func hideKeyBoard() {
        content_tv.resignFirstResponder()
    }
    
    func saveDiary(){
        let loading = LoadingView(type: LoadingView.ViewType.dot)
        view.addSubview(loading)
        Diary.createDiary(picData, thumbPicture: thumbPicData, isImportant: important_sw.on, content: content_tv.text, book: selectedBook!) { (isSuccessful, error) in
            loading.dismiss()
            if isSuccessful && error == nil {
                self.resetView()
                let toast = ToastView(text: "保存成功")
                self.view.addSubview(toast)
            } else {
                let toast = ToastView(text: "网络错误")
                self.view.addSubview(toast)
            }
        }
    }
    
    func choosePic(){
        if chooseAlert == nil{
            chooseAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let takePicture = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (action) in
                self.initImagePicker(0)
            }
            let openAlbum = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default) { (action) in
                self.initImagePicker(1)
            }
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            // 运行时属性
            cancel.setValue(UIColor.redColor(), forKey: "titleTextColor")
            chooseAlert.addAction(takePicture)
            chooseAlert.addAction(openAlbum)
            chooseAlert.addAction(cancel)
        }
        presentViewController(chooseAlert, animated: true, completion: nil)
    }
    
    func initImagePicker(type: Int){
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        switch type {
        case 0:
            imagePicker?.sourceType = UIImagePickerControllerSourceType.Camera
            break
        case 1:
            imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            break
        default:
            break
        }
        presentViewController(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picture_img.image = image
        let tImage = Utils.compressImageLowMaxWidth(image)
        picData = UIImageJPEGRepresentation(tImage, 1.0)
        let thumbImage = Utils.compressImageTolow(image)
        thumbPicData = UIImageJPEGRepresentation(thumbImage, 1.0)
        imagePicker?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showSaveAlret(){
        if BmobUser.currentUser() == nil {
            let unLogin = ToastView(text: "未登录")
            view.addSubview(unLogin)
            return
        }
        if content_tv.text == nil || content_tv.text == "" {
            let noContent = ToastView(text: "日记内容为空")
            view.addSubview(noContent)
            return
        }
        if selectedBook == nil {
            let unSelected = ToastView(text: "未选择日记本")
            view.addSubview(unSelected)
            return
        }
        if saveAlert == nil {
            saveAlert = UIAlertController(title: "是否保存到《\(selectedBook.subject!)》", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            let confirm = UIAlertAction(title: "保存", style: UIAlertActionStyle.Default, handler: { (action) in
                self.saveDiary()
            })
            saveAlert.addAction(cancel)
            saveAlert.addAction(confirm)
        }
        presentViewController(saveAlert, animated: true, completion: nil)
    }
    
    func resetView(){
        content_tv.text = ""
        picture_img.image = UIImage(named: "book")
        important_sw.on = false
        selectedBook = nil
        picData = nil
        thumbPicData = nil
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return diaryBooks.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return diaryBooks[row].subject
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempSelectedRow = row
    }

}