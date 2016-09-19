//
//  CreateBookVC.swift
//  BmobTest
//
//  Created by TDC on 16/9/6.
//  Copyright © 2016年 TDC. All rights reserved.
//

import UIKit

class CreateBookVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var subject_tf: UITextField!
    @IBOutlet weak var descript_tv: UITextView!
    @IBOutlet weak var unlockTime_tf: UITextField!
    @IBOutlet weak var bookPic_img: UIImageView!
    @IBOutlet weak var isOpen_sw: UISwitch!
    
    var diaryBook: DiaryBook?
    var updateBlock: UpdateList?
    
    var datePicker: UIDatePicker?
    var imagePicker: UIImagePickerController?
    
    var date: NSDate? {
        didSet {
            unlockTime_tf.text = Utils.dateFormat(date!, format: "yyyy-MM-dd")
        }
    }
    var imgData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "创建"
        let saveButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(saveDiaryBook))
        if diaryBook != nil {
            let deleteButtonItem  = UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(deleteDiaryBook))
            deleteButtonItem.tintColor = UIColor.redColor()
            navigationItem.rightBarButtonItems = [saveButtonItem, deleteButtonItem]
        } else {
            navigationItem.rightBarButtonItems = [saveButtonItem]
        }
        
        descript_tv.layer.borderColor = UIColor.lightGrayColor().CGColor
        descript_tv.layer.borderWidth = 0.6
        descript_tv.layer.cornerRadius = 5.0
        
        datePicker = UIDatePicker()
        datePicker?.locale = NSLocale.currentLocale()
        datePicker?.datePickerMode = UIDatePickerMode.Date
        datePicker?.addTarget(self, action: #selector(getDate), forControlEvents: UIControlEvents.ValueChanged)
        unlockTime_tf.inputView = datePicker
        
        let dateToolBar = UIToolbar(frame: CGRectMake(0, 0, Utils.width, 40))
        dateToolBar.backgroundColor = UIColor.lightGrayColor()
        let doneItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(hideKeyBoard))
        let fixible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        dateToolBar.items = [fixible, doneItem]
        subject_tf.inputAccessoryView = dateToolBar
        descript_tv.inputAccessoryView = dateToolBar
        unlockTime_tf.inputAccessoryView = dateToolBar
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooesPic))
        bookPic_img.addGestureRecognizer(tap)
        bookPic_img.userInteractionEnabled = true
        date = NSDate()
        
        if diaryBook != nil {
            initData()
        }
    }
    
    func initData(){
        navigationItem.title = diaryBook?.subject
        subject_tf.text = diaryBook?.subject
        descript_tv.text = diaryBook?.descript
        date = diaryBook?.unlockTime
        isOpen_sw.on = (diaryBook?.isOpen)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDate(){
        date = datePicker?.date
    }
    
    func saveDiaryBook() {
        if subject_tf.text?.characters.count == 0 {
            let toast = ToastView(text: "主题不能为空")
            view.addSubview(toast)
            return
        }
        if unlockTime_tf.text?.characters.count == 0 {
            let toast = ToastView(text: "请选择过期时间")
            view.addSubview(toast)
            return
        }
        let loading = LoadingView(type: LoadingView.ViewType.dot)
        view.addSubview(loading)
        if diaryBook == nil {
            DiaryBook.createNewBook(imgData, unlockTime: date!, subject: subject_tf.text!, isOpen: isOpen_sw.on, descript: descript_tv.text) {(isSuccessful, error) -> () in
                loading.dismiss()
                if isSuccessful && error == nil {
                    if self.updateBlock != nil {
                        self.updateBlock!()
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    let toast = ToastView(text: error.description)
                    self.view.addSubview(toast)
                }
            }
        } else {
            if subject_tf.text! != diaryBook?.subject {
                diaryBook?.setObject(subject_tf.text!, forKey: "subject")
            }
            if descript_tv.text! != diaryBook?.descript {
                diaryBook?.setObject(descript_tv.text!, forKey: "descript")
            }
            if date != diaryBook?.unlockTime {
                diaryBook?.setObject(date!, forKey: "unlockTime")
            }
            if isOpen_sw.on != diaryBook?.isOpen {
                diaryBook?.setObject(isOpen_sw.on, forKey: "isOpen")
            }
            diaryBook?.updateInBackgroundWithResultBlock({ (isSuccessful, error) -> () in
                if isSuccessful && error == nil {
                    loading.dismiss()
                    if self.updateBlock != nil {
                        self.updateBlock!()
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    let toast = ToastView(text: error.description)
                    self.view.addSubview(toast)
                }
            })
        }
//        let loading = LoadingView(type: LoadingView.ViewType.dot)
//        view.addSubview(loading)
//        // 延时操作
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
//            loading.dismiss()
//        }
        
    }
    
    func deleteDiaryBook(){
        if diaryBook != nil {
            diaryBook?.deleteInBackgroundWithBlock({ (isSuccessful, error) -> Void in
                if isSuccessful && error == nil {
                    if self.updateBlock != nil {
                        self.updateBlock!()
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    let toast = ToastView(text: "删除失败")
                    self.view.addSubview(toast)
                }
            })
        }
    }
    
    func hideKeyBoard() {
        subject_tf.resignFirstResponder()
        descript_tv.resignFirstResponder()
        unlockTime_tf.resignFirstResponder()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideKeyBoard()
    }
    
    func chooesPic(){
        let sheetAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takePicture = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.initImagePicker(0)
        }
        let openAlbum = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.initImagePicker(1)
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        // 运行时属性
        cancel.setValue(UIColor.redColor(), forKey: "titleTextColor")
        sheetAlert.addAction(takePicture)
        sheetAlert.addAction(openAlbum)
        sheetAlert.addAction(cancel)
        presentViewController(sheetAlert, animated: true, completion: nil)
    }
    
    func initImagePicker(type: Int){
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        bookPic_img.image = image
        // 也可以保存到沙盒中来获取实际路径用于上传
        //let fileManager = NSFileManager.defaultManager()
        //let rootPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //filePath = "\(rootPath)/pickedImage.jpg"
        imgData = UIImageJPEGRepresentation(image!, 1.0)
        //fileManager.createFileAtPath(filePath!, contents: imageData, attributes: nil)
        imagePicker?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}