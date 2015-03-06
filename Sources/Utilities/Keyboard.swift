//
//  Keyboard.swift
//  Ello
//
//  Created by Colin Gray on 2/26/2015.
//  Copyright (c) 2015 Ello. All rights reserved.
//

private let sharedKeyboard = Keyboard()

class Keyboard {
    struct Notifications {
        static let KeyboardWillShow = "com.Ello.Keyboard.KeyboardWillShow"
        static let KeyboardDidShow = "com.Ello.Keyboard.KeyboardDidShow"
        static let KeyboardWillHide = "com.Ello.Keyboard.KeyboardWillHide"
        static let KeyboardDidHide = "com.Ello.Keyboard.KeyboardDidHide"
    }

    class func shared() -> Keyboard {
        return sharedKeyboard
    }

    var visible : Bool
    var height : CGFloat
    var curve : UIViewAnimationCurve
    var options : UIViewAnimationOptions
    var duration : Double

    init() {
        visible = false
        height = 0
        curve = .Linear
        options = .CurveLinear
        duration = 0

        let center : NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("willShow:"), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: Selector("didShow:"), name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: Selector("willHide:"), name: UIKeyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: Selector("didHide:"), name: UIKeyboardDidHideNotification, object: nil)
    }

    deinit {
        let center : NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
        center.removeObserver(self)
        center.removeObserver(self)
        center.removeObserver(self)
    }

    @objc
    func willShow(notification : NSNotification) {
        visible = true
        setFromNotification(notification)
        height = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size.height

        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.KeyboardWillShow, object: nil)
    }

    @objc
    func didShow(notification : NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.KeyboardDidShow, object: nil)
    }

    @objc
    func willHide(notification : NSNotification) {
        visible = false
        setFromNotification(notification)
        height = 0

        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.KeyboardWillHide, object: nil)
    }

    @objc
    func didHide(notification : NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.KeyboardDidHide, object: nil)
    }

    private func setFromNotification(notification : NSNotification) {
        if let durationValue = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            duration = durationValue.doubleValue
        }
        else {
            duration = 0
        }
        if let rawCurveValue = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber) {
            let rawCurve = rawCurveValue.integerValue
            curve = UIViewAnimationCurve(rawValue: rawCurve) ?? .EaseOut
            let curveInt = UInt(rawCurve << 16)
            options = UIViewAnimationOptions(rawValue: curveInt)
        }
        else {
            curve == .EaseOut
            options = .CurveEaseOut
        }
    }

}