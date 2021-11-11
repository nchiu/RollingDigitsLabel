//
//  RollingDigitsLabel.swift
//
//  Created by Nathan Chiu on 11/9/21.
//

import UIKit

public class RollingDigitsLabel: UIView {
    
    // MARK: Properties
    private(set) var number: Double = 0 {
        didSet {
            buildStack()
        }
    }
    private var animationConfig = AnimationConfig()
    private var formatter = NumberFormatter()
    private var digits = [DigitColumn.Digit]()
    private var lastFont: UIFont?
    private var lastColor: UIColor?
    
    private var labelStack: UIStackView?
    
    
    // MARK: Initializers
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    // MARK: UIView
    public override var accessibilityLabel: String? {
        get { text }
        set { /* no-op */ }
    }
}

// MARK: Public
private extension RollingDigitsLabel {
    struct AnimationConfig {
        var duration: TimeInterval = 0.75
        var delay: TimeInterval = 0
        var springDamping: CGFloat = 0.85
        var initialVelocity: CGFloat = 0.5
    }
}

public extension RollingDigitsLabel {
    
    /// The `String` representation of `number`.
    var text: String {
        formatter.string(from: .init(floatLiteral: number)) ?? "\(number)"
    }
    
    /// The preset number style used by the label.
    var numberStyle: NumberFormatter.Style {
        get { formatter.numberStyle }
        set { formatter.numberStyle = newValue }
    }
    
    /// The minimum number of digits before the decimal separator.
    var minimumIntegerDigits: Int {
        get { formatter.minimumIntegerDigits }
        set { formatter.minimumIntegerDigits = newValue }
    }
    
    /// The maximum number of digits before the decimal separator.
    var maximumIntegerDigits: Int {
        get { formatter.maximumIntegerDigits }
        set { formatter.maximumIntegerDigits = newValue }
    }
    
    /// The minimum number of digits after the decimal separator.
    var minimumFractionDigits: Int {
        get { formatter.minimumFractionDigits }
        set { formatter.minimumFractionDigits = newValue }
    }
    
    /// The maximum number of digits after the decimal separator.
    var maximumFractionDigits: Int {
        get { formatter.maximumFractionDigits }
        set { formatter.maximumFractionDigits = newValue }
    }
    
    /// Set the `NumberFormatter` for the label.
    func setNumberFormatter(_ formatter: NumberFormatter) {
        self.formatter = formatter
    }
    
    /// Set the text color of the label.
    func set(color: UIColor) {
        labelStack?.arrangedSubviews.forEach {
            ($0 as? UILabel)?.textColor = color
            ($0 as? DigitColumn)?.set(color: color)
        }
        lastColor = color
    }
    
    /// Set the font of the label.
    func set(font: UIFont) {
        labelStack?.arrangedSubviews.forEach {
            ($0 as? UILabel)?.font = font
            ($0 as? DigitColumn)?.set(font: font)
        }
        lastFont = font
    }
    
    /// Configure the animation properties of the label.
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them. Defaults to `0.75`
    ///   - delay: The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately. Defaults to `0`
    ///   - springDamping: The damping ratio for the spring animation as it approaches its quiescent state. To smoothly decelerate the animation without oscillation, use a value of 1. Employ a damping ratio closer to zero to increase oscillation. Defaults to `0.85`
    ///   - initialVelocity: The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment. A value of 1 corresponds to the total animation distance traversed in one second. For example, if the total animation distance is 200 points and you want the start of the animation to match a view velocity of 100 pt/s, use a value of 0.5. Defaults to `0.5`
    func setAnimation(duration: TimeInterval = 0.75, delay: TimeInterval = 0, springDamping: CGFloat = 0.85, initialVelocity: CGFloat = 0.5) {
        animationConfig.duration = duration
        animationConfig.delay = delay
        animationConfig.initialVelocity = initialVelocity
        animationConfig.springDamping = springDamping
    }
    
    /// Set the number to display as a `Double`
    /// - Parameters:
    ///   - double: The number to display.
    ///   - animated: If true, the label will animate to the text.
    ///   - completion: An optional block to be called when the animation finishes. If `animated` is `false`, then `completion` will be called immediately.
    func setNumber(_ double: Double, animated: Bool, completion: (() -> Void)? = nil) {
        number = double
        layoutIfNeeded()
        if animated {
            animate(animation: updateColumns, completion: completion)
        } else {
            updateColumns()
            completion?()
        }
    }
    
    /// Set the number to display as an `Int`
    /// - Parameters:
    ///   - double: The number to display.
    ///   - animated: If true, the label will animate to the text.
    ///   - completion: An optional block to be called when the animation finishes. If `animated` is `false`, then `completion` will be called immediately.
    func setNumber(_ integer: Int, animated: Bool, completion: (() -> Void)? = nil) {
        setNumber(Double(integer), animated: animated, completion: completion)
    }
    
    /// Set the number to display as a `Float`
    /// - Parameters:
    ///   - double: The number to display.
    ///   - animated: If true, the label will animate to the text.
    ///   - completion: An optional block to be called when the animation finishes. If `animated` is `false`, then `completion` will be called immediately.
    func setNumber(_ float: Float, animated: Bool, completion: (() -> Void)? = nil) {
        setNumber(Double(float), animated: animated, completion: completion)
    }
    
    /// Set the number to display as an `NSNumber`
    /// - Parameters:
    ///   - double: The number to display.
    ///   - animated: If true, the label will animate to the text.
    ///   - completion: An optional block to be called when the animation finishes. If `animated` is `false`, then `completion` will be called immediately.
    func setNumber(_ number: NSNumber, animated: Bool, completion: (() -> Void)? = nil) {
        setNumber(number.doubleValue, animated: animated, completion: completion)
    }
}



// MARK: - Private
private extension RollingDigitsLabel {
    func commonInit() {
        clipsToBounds = true
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        addConstraints([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        labelStack = stack
    }
    
    func clearStack() {
        while !(labelStack?.arrangedSubviews.isEmpty ?? true) {
            guard let view = labelStack?.arrangedSubviews.last else { return }
            labelStack?.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        digits.removeAll()
    }
    
    func buildStack() {
        clearStack()
        text.forEach {
            if let digit = DigitColumn.Digit(rawValue: $0) {
                let column = DigitColumn(frame: .zero)
                labelStack?.addArrangedSubview(column)
                digits.append(digit)
            } else {
                let label = UILabel()
                label.text = "\($0)"
                labelStack?.addArrangedSubview(label)
            }
        }
        if let lastFont = lastFont { set(font: lastFont) }
        if let lastColor = lastColor { set(color: lastColor) }
    }
    
    func updateColumns() {
        let columns = labelStack?.arrangedSubviews.filter { $0 is DigitColumn } ?? []
        guard columns.count == digits.count else { return }
        columns.indices.forEach {
            (columns[$0] as? DigitColumn)?.digit = digits[$0]
        }
        layoutIfNeeded()
    }
    
    func animate(animation: @escaping () -> Void, completion: (() -> Void)?) {
        UIView.animate(withDuration: animationConfig.duration,
                       delay: animationConfig.delay,
                       usingSpringWithDamping: animationConfig.springDamping,
                       initialSpringVelocity: animationConfig.initialVelocity,
                       options: .beginFromCurrentState,
                       animations: animation,
                       completion: { _ in completion?() })
    }
}

private extension RollingDigitsLabel {
    class DigitColumn: UIView {
        // MARK: Properties
        var digit: Digit = .zero {
            didSet { refreshConstraints() }
        }
        private var stack: UIStackView?
        private var heightConstraint: NSLayoutConstraint?
        private var offsetConstraint: NSLayoutConstraint?
        
        // MARK: Initializers
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
    }
}

private extension RollingDigitsLabel.DigitColumn {
    func set(color: UIColor) {
        stack?.arrangedSubviews.forEach { ($0 as? UILabel)?.textColor = color }
    }
    
    func set(font: UIFont) {
        stack?.arrangedSubviews.forEach { ($0 as? UILabel)?.font = font }
        refreshConstraints()
    }
}

private extension RollingDigitsLabel.DigitColumn {
    func commonInit() {
        clipsToBounds = true
        let stack = UIStackView(arrangedSubviews: Digit.allCases.reversed().map {
            let label = UILabel()
            label.text = "\($0.rawValue)"
            label.textAlignment = .center
            return label
        })
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        let heightConstraint = heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.1)
        let offsetConstraint = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        addConstraints([
            heightConstraint, offsetConstraint,
            widthAnchor.constraint(equalTo: stack.widthAnchor),
            centerXAnchor.constraint(equalTo: stack.centerXAnchor)
        ])
        self.stack = stack
        self.heightConstraint = heightConstraint
        self.offsetConstraint = offsetConstraint
    }
    
    func refreshConstraints() {
        offsetConstraint?.constant = CGFloat(digit.intValue) * (stack?.arrangedSubviews.first?.bounds.height ?? 0)
        setNeedsLayout()
    }
}

private extension RollingDigitsLabel.DigitColumn {
    enum Digit: Character, CaseIterable {
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        
        var intValue: Int {
            switch self {
            case .zero: return 0
            case .one: return 1
            case .two: return 2
            case .three: return 3
            case .four: return 4
            case .five: return 5
            case .six: return 6
            case .seven: return 7
            case .eight: return 8
            case .nine: return 9
            }
        }
    }
}
