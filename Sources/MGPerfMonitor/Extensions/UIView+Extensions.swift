//
// UIView+Extensions.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import UIKit

extension UIView {
    
    public static func spacingView(height: CGFloat? = nil, width: CGFloat? = nil) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        return view
    }
    
    public static func dividerHorizontalView(_ height: CGFloat = 0.5) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
    
    public static func dividerVerticalView(_ width: CGFloat = 0.5, height: CGFloat? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        if let height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return view
    }
    
    public var parentScrollView: UIScrollView? {
        var parentView: UIView? = superview
        while parentView != nil {
            if let scrollView = parentView as? UIScrollView {
                return scrollView
            }
            parentView = parentView?.superview
        }
        return nil
    }
    
    public var parentStackView: UIStackView? {
        var parentView: UIView? = superview
        while parentView != nil {
            if let stackView = parentView as? UIStackView {
                return stackView
            }
            parentView = parentView?.superview
        }
        return nil
    }

    /**
     Returns the UIViewController object that manages the receiver.
     */
   public func currentController() -> UIViewController? {
        var nextResponder = next
        while nextResponder != nil {
            if nextResponder is UIViewController {
                return nextResponder as? UIViewController
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    public func setCornerRadius(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func roundCorners(radius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    public var isDarkMode: Bool {
        let mode = UserDefaults.displayColorsSetting.toUserInterfaceStyle
        if mode == .unspecified {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark
        } else {
            return mode == .dark
        }
    }
    
    public func isPortraitLayout() -> Bool {
        let screenSize = UIScreen.main.bounds.size
        if screenSize.width > screenSize.height {
            return false
        } else {
            return true
        }
    }
}

extension UIView {
    public func makeViewConstraints(toFitSuperView superView: UIView, edgeInsets: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: edgeInsets.left),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: edgeInsets.right),
            topAnchor.constraint(equalTo: superView.topAnchor, constant: edgeInsets.top),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: edgeInsets.bottom)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    public func makeViewConstraints(setHeight height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    public static func fillerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

public extension UIView {
    func rotate(duration: CFTimeInterval = 0.5, completion: (() -> Void)? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatDuration = 1
        layer.add(rotateAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.layer.removeAllAnimations()
            completion?()
        }
    }
}

// MARK: - find
public extension UIView {
    func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard !view.subviews.isEmpty else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }

    func getSubviewsOf<T: UIView>(view: UIView) -> [T] {
        var subviews = [T]()
        for subview in view.subviews {
            subviews += getSubviewsOf(view: subview) as [T]
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        return subviews
    }
}

public class CustomContentEdgeLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0.0 {
        didSet {
            updateContentEdgeInsets()
        }
    }

    @IBInspectable var leftInset: CGFloat = 0.0 {
        didSet {
            updateContentEdgeInsets()
        }
    }

    @IBInspectable var bottomInset: CGFloat = 0.0 {
        didSet {
            updateContentEdgeInsets()
        }
    }

    @IBInspectable var rightInset: CGFloat = 0.0 {
        didSet {
            updateContentEdgeInsets()
        }
    }

    private func updateContentEdgeInsets() {
        contentEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        setNeedsLayout()
    }

    public var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsLayout()
        }
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentEdgeInsets))
    }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentEdgeInsets.left + contentEdgeInsets.right,
                      height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
    }
    public func updateInset(topInset: CGFloat? = nil, leftInset: CGFloat? = nil, rightInset: CGFloat? = nil, bottomInset: CGFloat? = nil) {
        if let _topInset = topInset {
            self.topInset = _topInset
        }
        
        if let _leftInset = leftInset {
            self.leftInset = _leftInset
        }
        
        if let _rightInset = rightInset {
            self.rightInset = _rightInset
        }
        
        if let _bottomInset = bottomInset {
            self.bottomInset = _bottomInset
        }
    }
}


extension UIView {
    public func animateShowLikePresent(completion: (() -> Void)? = nil) {
        let originalY = frame.origin.y
        let height = frame.height
        isHidden = false
        transform = CGAffineTransform(translationX: 0, y: originalY + height)

        UIView.animate(withDuration: 0.5, animations: {
            self.transform = .identity
        }, completion: { _ in
            completion?()
        })
    }

    public func animateHideLikeDismiss(completion: (() -> Void)? = nil) {
        let originalY = frame.origin.y
        let height = frame.height

        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: originalY + height)
        }, completion: {_ in
            self.transform = .identity
            self.isHidden = true
            completion?()
        })
    }
}

extension UIView {
    public func addBottomSeparator(color: UIColor, height: CGFloat, distance: CGFloat) {
        let separator = UIView()
        separator.backgroundColor = color
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: height).isActive = true
        separator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: distance).isActive = true
    }
}

extension UIView {
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


extension UILabel {
    public func flashBackgroundAndTextChange(withOld oldText: String, newText: String, _ bgColor: UIColor = UIColor(hexString: "#E3FAFF"), _ repeatCount: Int = 2) {
        text = oldText

        let flashingView = UIView()
        flashingView.backgroundColor = bgColor
        flashingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flashingView)
        sendSubviewToBack(flashingView)

        NSLayoutConstraint.activate([
            flashingView.topAnchor.constraint(equalTo: topAnchor),
            flashingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flashingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            flashingView.widthAnchor.constraint(equalToConstant: textSize().width + 30)
        ])

        // Animation to change text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.text = newText
            }, completion: nil)
        }

        // Animation for flashing view
        var count = repeatCount * 2
        func animateFlashingView() {
            UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                flashingView.alpha = (count % 2 == 0) ? 1 : 0
            }) { _ in
                count -= 1
                if count > 0 {
                    animateFlashingView()
                } else {
                    flashingView.removeFromSuperview()
                }
            }
        }
        animateFlashingView()
    }


    public func textSize() -> CGSize {
        guard let text = text else { return CGSize.zero }
        let textSize = (text as NSString).boundingRect(with: CGSize(width: frame.width, height: .greatestFiniteMagnitude),
                                                       options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                       attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 12)],
                                                       context: nil).size
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
}

public class PaddedImageView: UIView {
    private let imageView = UIImageView()

    public var imagePadding: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }

    public var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(imageView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds.inset(by: imagePadding)
        // set the same isUserInteractionEnabled
        imageView.isUserInteractionEnabled = isUserInteractionEnabled
    }
}


extension UIView {
    
    public var isHiddenWithoutAnimation: Bool {
        get {
            return isHidden
        }
        set {
            UIView.performWithoutAnimation {
                self.isHidden = newValue
            }
        }
    }
}
