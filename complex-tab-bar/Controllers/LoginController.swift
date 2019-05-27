//
//  LoginController.swift
//  complex-tab-bar
//
//  Created by Marcos Januário on 21.05.19.
//  Copyright © 2019 Marcos Januário. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import RealmSwift

class LoginController: UIViewController {
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var settings: Results<Settings>?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside login:")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            print("is logged in")
            performSegue(withIdentifier: "toTabController", sender: self)
        } else {
            print("is NOT logged in")
        }
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                print("login successful")
                self.saveUserData()
                self.performSegue(withIdentifier: "toTabController", sender: self)
            }
        })
        
    }
    
    func saveUserData() {
        let settings = Settings()
        settings.userEmail = emailTextField.text!
        do {
            try realm.write {
                realm.add(settings)
            }
        } catch {
            print("Error saving context!")
        }
    
    }
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
