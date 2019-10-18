//
// The MIT License (MIT)
//
// Copyright (c) 2018 Roman Kotov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

/// Менеджер работы с клавиатурой
open class RKKeyboardManager: NSObject {
    // MARK: - Types
    /// Событие открытия клавиатуры
    public enum Event {
        /// Будет показана
        case willShow
        /// Будет скрыта
        case willHide
        /// Изменение размера (например, изменение типа клавиатуры
        /// или отключение предиктивного ввода)
        case justChange
    }

    /// Тип замыкания вызываемого при изменении клавиатуры
    ///
    /// - Parameter keyboardFrame: Фрейм клавиатуры
    /// - Parameter event: Событие происходящее с клавиатурой
    public typealias OnWillChangeFrameBlock = (_ keyboardFrame: CGRect, _ event: Event) -> Void
    
    // MARK: - Variables
    public var bottomSafeAreaInset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    // MARK: - Properties
    private(set) public var scrollView: UIScrollView? = nil
    private var onWillChangeFrame: OnWillChangeFrameBlock?
    private var isSubscribed: Bool = false
    private var contentInsetBottom: CGFloat = 0
    private var scrollIndicatorBottomInset: CGFloat = 0
    
    // MARK: - Init
    public override init() {
        super.init()
    }
    
    public init(with scrollView: UIScrollView?) {
        self.scrollView = scrollView
        self.contentInsetBottom = scrollView?.contentInset.bottom ?? 0
        self.scrollIndicatorBottomInset = scrollView?.scrollIndicatorInsets.bottom ?? 0
        
        super.init()
    }
    
    // MARK: - Setters
    public func setOnWillChangeFrameBlock(_ block: OnWillChangeFrameBlock?) {
        self.onWillChangeFrame = block
    }
    
    // MARK: - Subscribe / Unsubscribe
    /// Подписаться на обновления клавиатуры
    public func subscribe() {
        guard !isSubscribed else { return }
        isSubscribed = true

        #if swift(>=4.2)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        #else
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: .UIKeyboardWillChangeFrame,
            object: nil)
        #endif
    }
    
    /// Отписаться от обновлений клавиатуры
    public func unsubscribe() {
        isSubscribed = false
        #if swift(>=4.2)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
        #else
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        #endif
    }
    
    // MARK: - Actions
    @objc
    private func keyboardWillChangeFrame(_ notification: Notification) {
        #if swift(>=4.2)
        guard let userInfo = notification.userInfo,
            let beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        #else
        guard let userInfo = notification.userInfo,
            let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
            }
        #endif

        var event: Event = .justChange
        var bottomInset: CGFloat = UIScreen.main.bounds.height - endFrame.minY - bottomSafeAreaInset
        if beginFrame.origin.y - endFrame.origin.y > 0 && beginFrame.minY >= UIScreen.main.bounds.height {
            event = .willShow
        } else if beginFrame.origin.y - endFrame.origin.y <= 0 && endFrame.minY >= UIScreen.main.bounds.height {
            event = .willHide
            bottomInset = 0
        }

        scrollView?.contentInset.bottom = bottomInset + self.contentInsetBottom
        scrollView?.scrollIndicatorInsets.bottom = bottomInset + self.scrollIndicatorBottomInset
        
        onWillChangeFrame.flatMap({ $0(endFrame, event) })
    }
}
