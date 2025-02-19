//
//  FontMap.swift
//  WDBFontOverwrite
//
//  Created by Noah Little on 4/1/2023.
//

import Foundation

struct FontMap {
    static var fontMap = [String: CustomFont]()
    
    static let emojiCustomFont = CustomFont(
        name: "Emoji",
        targetPath: .many([
            "/System/Library/Fonts/CoreAddition/AppleColorEmoji-160px.ttc",
            "/System/Library/Fonts/Core/AppleColorEmoji.ttc",
        ]),
        localPath: "CustomAppleColorEmoji.woff2"
    )
    
    static func populateFontMap() async throws {
        let fm = FileManager.default
        let fontDirPath = "/System/Library/Fonts/"
        
        let fontSubDirectories = try fm.contentsOfDirectory(atPath: fontDirPath)
        for dir in fontSubDirectories {
            let fontFiles = try fm.contentsOfDirectory(atPath: "\(fontDirPath)\(dir)")
            for font in fontFiles {
                guard !font.contains("AppleColorEmoji") else {
                    continue
                }
                guard let validatedLocalPath = validateFont(name: font) else {
                    continue
                }
                fontMap[key(forFont: font)] = CustomFont(
                    name: font,
                    targetPath: .single("\(fontDirPath)\(dir)/\(font)"),
                    localPath: "Custom\(validatedLocalPath)",
                    alternativeTTCRepackMode: .ttcpad
                )
            }
        }
    }
    
    public static func key(forFont font: String) -> String {
        var components = font.components(separatedBy: ".")
        components.removeLast()
        var rejoinedString = components.joined(separator: ".")
        if rejoinedString.hasPrefix("Custom") {
            rejoinedString = rejoinedString.replacingOccurrences(of: "Custom", with: "")
        }
        return rejoinedString
    }
    
    private static func validateFont(name: String) -> String? {
        var components = name.components(separatedBy: ".")
        guard components.last == "ttc" || components.last == "ttf" else {
            return nil
        }
        components[components.count - 1] = "woff2"
        return components.joined(separator: ".")
    }
}
