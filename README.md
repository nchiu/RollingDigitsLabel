# RollingDigitsLabel

A simple label that animates a number with each digit falling into place.

![Various example labels](/Images/overview.gif)

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/nchiu/RollingDigitsLabel", from: "1.0.0")
]
```

## Initialization

### In Code

```swift
let animatedLabel = RollingDigitsLabel(frame: .zero)
```

### In Interface Builder

Drag a new UIView on to the canvas and set its class and module in the Identity inspector.
![Interface Builder configuration](/Images/ibCustomClass.png)

## Configuration

### Set the label style

Color and font can be adjusted using these functions 
```swift
animatedLabel.set(color: .systemTeal)
animatedLabel.set(font: .systemFont(ofSize: 30, weight: .semibold))
```

### Set the NumberFormatter style

Common formatting adjustments can be made to the label directly...
```swift
animatedLabel.numberStyle = .currency
animatedLabel.minimumIntegerDigits = 5
animatedLabel.maximumIntegerDigits = 10
animatedLabel.minimumFractionDigits = 3
animatedLabel.maximumFractionDigits = 6
```

... or an existing `NumberFormatter` can be applied to the label.
```swift
let myFormatter = NumberFormatter()
animatedLabel.setNumberFormatter(myFormatter)
```

## Animation

Set the number value of the label
```swift
animatedLabel.setNumber(newValue, animated: true, completion: { print("animation complete") })
```
`newValue` can be a `Double`, `Int`, `Float`, or `NSNumber`.

### Adjusting the animation timing

You can change the duration, delay, spring damping, and initial velocity of the animation.
```swift
animatedLabel.setAnimation(duration: 0.75, delay: 0, springDamping: 0.85, initialVelocity: 0.5)
```
These values will be used every time a new number is set.

## Example
```swift
import RollingDigitsLabel

class ViewController: UIViewController {
    
    @IBOutlet private var rollingDigitsLabel: RollingDigitsLabel? {
        didSet {
            rollingDigitsLabel?.numberStyle = .decimal
            rollingDigitsLabel?.set(font: .boldSystemFont(ofSize: 30))
            rollingDigitsLabel?.set(color: .systemMint)
        }
    }
    
    @IBAction func pressedNewNumber(_ sender: UIButton) {
        sender.isEnabled = false
        let newNumber = Int(arc4random() % 999999999)
        rollingDigitsLabel?.setNumber(newNumber, animated: true, completion: {
            sender.isEnabled = true
        })
    }
}
```
![Example code running](/Images/example.gif)
