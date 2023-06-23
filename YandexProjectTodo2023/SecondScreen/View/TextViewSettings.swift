import Foundation
import UIKit

// MARK: TextView settings, keyboard handler

extension SecondScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Enable "save"&"delete" button when textView isNotEmpty
    // MARK: Set background text

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        tableView.allowsSelection = false
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
        
        if textView.text.isEmpty == false && textView.text != defaultPhraseForTextView {
            buttonSave.isEnabled = true
            buttonDelete.isEnabled = true
        }
        
        self.view.addGestureRecognizer(tapGestureEndEditing)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tableView.allowsSelection = true
        buttonSave.isEnabled = true
        buttonDelete.isEnabled = true
        
        if textView.text.isEmpty {
            textView.text = defaultPhraseForTextView
            textView.textColor = UIColor.lightGray
            buttonSave.isEnabled = false
            buttonDelete.isEnabled = false
        }
        toDo.text = textView.text
        self.view.removeGestureRecognizer(tapGestureEndEditing)
    }
    
    // keyboard handler
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textRange = textView.selectedTextRange else {
            return
        }
        
        let textPosition = textView.caretRect(for: textRange.start)
        let overflow = textPosition.origin.y + textPosition.size.height - (textView.contentSize.height - textView.contentInset.bottom - textView.contentInset.top)
        
        if overflow > 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.tableView.contentOffset.y += overflow + 7
            }, completion: nil)
        }
        if textView.text.isEmpty == false && textView.text != defaultPhraseForTextView {
            buttonSave.isEnabled = true
            buttonDelete.isEnabled = true
        } else {
            buttonSave.isEnabled = false
            buttonDelete.isEnabled = false
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height + 15

            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    }
}
