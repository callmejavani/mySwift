//
//  ViewController.swift
//  myVKApp1192
//
//  Created by Юрий Султанов on 01.04.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func buttonPressed(_ sender: Any) { }
    @IBAction func unwindSegue(for unwindSegue: UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    private func checkUserInfo() -> Bool {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            username == "",
            password == ""
        else {
            presentError()
            return false
        }
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        checkUserInfo()
    }
    
    private func presentError(with message: String = "Неправильный логин или пароль") {
        let alertController = UIAlertController(title: "Ошибка",
                                                message: message,
                                                preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok",
                                     style: .default) { _ in
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
        }
        alertController.addAction(okButton)
        present(alertController,
                animated: true)
    }
    
    
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
    // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    //Когда клавиатура исчезает 
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
}



