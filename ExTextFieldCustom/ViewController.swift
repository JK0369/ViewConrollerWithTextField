//
//  ViewController.swift
//  ExTextFieldCustom
//
//  Created by 김종권 on 2023/11/02.
//

import UIKit

class ViewController: UIViewController {
    private let textField = {
        let field = UITextField()
        field.textColor = .black
        field.placeholder = "문구"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func handleEditingChanged(textField: UITextField) {
        guard let text = textField.text else { return }
        let count = text.count
        
        if 5 < count {
            textField.text = text.substring(with: 0..<count-1)
        }
        editingChanged()
    }
}

extension ViewController {
    func editingChanged() {
        // removeTarget없이 sendAction을 부르면 무한루프 재귀 발생
        textField.removeTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        textField.sendActions(for: .editingChanged)
        textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }
}

extension String {
    func substring(with range: Range<Int>) -> String {
        let startIndex = index(startIndex, offsetBy: range.lowerBound)
        let endIndex = index(startIndex, offsetBy: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
