//
//  Color+Ext.swift
//  iOS26Test
//
//  Created by Langpeu on 9/26/25.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI Color Extension
extension Color {
    
    /// Hex 코드로부터 Color 생성
    /// - Parameter hex: "#FF0000", "FF0000", "#FF0000FF" 등의 형태
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // 기본값: 검은색
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// 편의 생성자 - 옵셔널 처리
    init?(hexString: String?) {
        guard let hexString = hexString else { return nil }
        self.init(hex: hexString)
    }
    
    /// Color를 hex 문자열로 변환
    var hexString: String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)
        
        if a == 255 {
            return String(format: "#%02X%02X%02X", r, g, b)
        } else {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }
    }
}

// MARK: - UIColor Extension
extension UIColor {
    
    /// Hex 코드로부터 UIColor 생성
    /// - Parameter hex: "#FF0000", "FF0000", "#FF0000FF" 등의 형태
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // 기본값: 검은색
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    /// 편의 생성자 - 옵셔널 처리
    convenience init?(hexString: String?) {
        guard let hexString = hexString else { return nil }
        self.init(hex: hexString)
    }
    
    /// UIColor를 hex 문자열로 변환
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)
        
        if a == 255 {
            return String(format: "#%02X%02X%02X", r, g, b)
        } else {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }
    }
    
    /// RGB 값으로 UIColor 생성 (0-255 범위)
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - 자주 사용하는 색상 상수
extension Color {
    // 브랜드 컬러
    static let primaryBlue = Color(hex: "#007AFF")
    static let primaryGreen = Color(hex: "#34C759")
    static let primaryRed = Color(hex: "#FF3B30")
    static let primaryOrange = Color(hex: "#FF9500")
    static let primaryPurple = Color(hex: "#AF52DE")
    
    // 그레이 스케일
    static let lightGray = Color(hex: "#F2F2F7")
    static let mediumGray = Color(hex: "#C7C7CC")
    static let darkGray = Color(hex: "#8E8E93")
    
    // 다크모드 대응 색상
    static let adaptiveBackground = Color(UIColor.systemBackground)
    static let adaptiveText = Color(UIColor.label)
    static let adaptiveSecondaryText = Color(UIColor.secondaryLabel)
}

extension UIColor {
    // 브랜드 컬러
    static let primaryBlue = UIColor(hex: "#007AFF")
    static let primaryGreen = UIColor(hex: "#34C759")
    static let primaryRed = UIColor(hex: "#FF3B30")
    static let primaryOrange = UIColor(hex: "#FF9500")
    static let primaryPurple = UIColor(hex: "#AF52DE")
    
    // 그레이 스케일
    static let lightGray = UIColor(hex: "#F2F2F7")
    static let mediumGray = UIColor(hex: "#C7C7CC")
    static let darkGray = UIColor(hex: "#8E8E93")
}

// MARK: - 사용 예시
struct ColorExamples {
    
    func swiftUIExamples() {
        // SwiftUI에서 사용
        let redColor = Color(hex: "#FF0000")
        let blueColor = Color(hex: "0066CC")
        let greenWithAlpha = Color(hex: "#00FF00AA")
        
        // 옵셔널 처리
        let optionalColor = Color(hexString: "#FF5733")
        
        // 미리 정의된 색상 사용
        let brandColor = Color.primaryBlue
        
        // 색상을 hex 문자열로 변환
        let hexString = Color.red.hexString
        print("Red color hex: \(hexString)")
    }
    
    func uikitExamples() {
        // UIKit에서 사용
        let redColor = UIColor(hex: "#FF0000")
        let blueColor = UIColor(hex: "0066CC")
        let greenWithAlpha = UIColor(hex: "#00FF00AA")
        
        // 옵셔널 처리
        let optionalColor = UIColor(hexString: "#FF5733")
        
        // RGB 값으로 생성
        let customColor = UIColor(red: 255, green: 100, blue: 50)
        
        // 미리 정의된 색상 사용
        let brandColor = UIColor.primaryBlue
        
        // 색상을 hex 문자열로 변환
        let hexString = UIColor.red.hexString
        print("Red color hex: \(hexString)")
    }
}
