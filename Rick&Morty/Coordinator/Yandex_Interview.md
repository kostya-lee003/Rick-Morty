
//
//  Yandex_Interview.swift
//
import UIKit
import OSLog

// ---------------------- Task 1 ----------------------
// Сделать ревью кода, обьяснить что не так и исправить проблемные места
class SomeViewController: UIViewController {
    private var label: UILabel!
    
    func print(_ text: String) {
        NSLog(text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
    }
    
    func setupLabel() {
        label = UILabel()
        // настройка фонта, цвета и тд
    }
    
    func performTask() {
        let s = NetworkManager()
        s.downloadData { text in
            self.print(text)
        }
        self.navigationController?.pushViewController(self, animated: true)
    }
}

// Представим что реализация класса скрыта
fileprivate class NetworkManager {
    func downloadData(_ handler: @escaping (String) -> Void) {
        handler("Some value")
    }
}

// ---------------------- Task 2 ----------------------

// Что такое Optional в Swift?
// Представим что его у нас нет в Swift и нам нужно его реализовать, как бы это выглядело?

// Теперь представь что у тебя есть такой вспомогательный метод map(). Как бы ты его реализовал/реализовала?
let first = Optional.some(10)
let second = Optional.none

let a = first.map { $0 * $0 } // Optional.some(100)
let b = first.map { "Value b contains: \($0)" } // Optional.some("Value b contains: 10")

let c = second.map { $0 * $0 } // Optional.none
let d = second.map { "Value d contains: \($0)" } // "Value d contains: Optional.none"
