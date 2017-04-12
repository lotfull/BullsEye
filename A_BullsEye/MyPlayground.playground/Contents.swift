import UIKit

let l00in2_3pow: Double = pow(100, 2/3)

var currentbonus = 0
var difference = 0
var roundScore = 0
var differenceSquare: Int
for difference in 0..<50 {
    differenceSquare = difference * difference
    switch difference {
    case 0...20:
        roundScore = 10 * Int(pow(l00in2_3pow - Double(difference), 1.5))
        continue
    case 21..<100:
        roundScore = (100 - difference) / 3 + currentbonus
    case 0:
        roundScore += 250
    case 1:
        roundScore += 130
    case 2:
        roundScore += 50
    default:
        break
    }
    print("\(difference): \(roundScore)")
}

