import Foundation
import UIKit

// MARK: extension UIColor -><- HEX String

extension UIColor {
    var hexString: String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        var a: Float = 1.0
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        let hex = String(format: "%02lX%02lX%02lX%02lX",
                         lroundf(r * 255),
                         lroundf(g * 255),
                         lroundf(b * 255),
                         lroundf(a * 255))
        return hex
    }
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 8: // RGBA
            (r, g, b, a) = ((int >> 24) & 255, (int >> 16) & 255, (int >> 8) & 255, int & 255)
        case 6: // RGB
            (r, g, b, a) = ((int >> 16) & 255, (int >> 8) & 255, int & 255, 255)
        default:
            (r, g, b, a) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var alpha: CGFloat {
        return cgColor.alpha
    }
}
