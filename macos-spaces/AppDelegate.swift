//
//  AppDelegate.swift
//  macos-spaces
//
//  Created by Collin Murch on 1/20/19.
//  Copyright © 2019 collinmurch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var statusBar: NSStatusItem = NSStatusBar.system.statusItem(withLength: -1)
    var menu: NSMenu = NSMenu()
    var menuItem: NSMenuItem = NSMenuItem()
    
    var totalSpaces: Int = 1
    
    @IBOutlet weak var workspace: NSWorkspace!
    
    let path = "~/Library/Preferences/com.apple.spaces.plist"

    override func awakeFromNib() {
        NSApplication.shared.setActivationPolicy(.accessory)
        
        spaceObserver()
        
        statusBar.menu = menu
    
        updateSpace()
        
        menuItem.title = "@collinmurch"
        menu.addItem(menuItem)
        
        menu.addItem(withTitle: "Quit macos-spaces", action: #selector (quitClicked), keyEquivalent: "")
    }
    
    func spaceObserver() {
        workspace = NSWorkspace.shared
        workspace.notificationCenter.addObserver(
            self,
            selector: #selector(AppDelegate.updateSpace),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: workspace
        )
    }
    
    func generateImage(_ activeSpace: Int) -> NSImage {
        let img: NSImage = NSImage(size: NSSize.init(width: 68.0, height: 15.0))
        
        var text: String
        var bColor: NSColor
        var tColor: NSColor
        
        // Make new number rect for each space
        for i in 1...totalSpaces {
            text = "\(i)"
            
            // Create a rect with a text box inside it
            let rect = NSMakeRect(0.0 + CGFloat(i-1)*17.0, 0, 15, 15)
            let textRect = NSMakeRect(-5 + CGFloat(i-1)*17.0, -11, 25, 25)
            
            // Make outer rect have rounded corners
            let path: NSBezierPath = NSBezierPath(roundedRect: rect, xRadius: 2.5, yRadius: 2.5)
            
            // Select image and make border rounded rect white
            img.lockFocus()
            
            NSColor.white.set()
            path.fill()
            
            img.unlockFocus()
            
            // If you get to the active space, then do the following (special)
            if i == activeSpace {
                
                // Create new rounded rect inside of original, to be background color
                let iRect = NSMakeRect(1 + CGFloat(i-1)*17.0, 1, 13, 13)
                let iPath: NSBezierPath = NSBezierPath(roundedRect: iRect, xRadius: 2.5, yRadius: 2.5)
                
                // Invert colors
                tColor = NSColor.white
                bColor = NSColor.black
                
                // Select rounded rect and fill with background color
                img.lockFocus()
                
                bColor.set()
                iPath.fill()
                
                img.unlockFocus()
            } else {
                
                // Otherwise, set text as black and background as white
                tColor = NSColor.black
                bColor = NSColor.white
            }
        
            // Font and text settings
            let font = NSFont(name: "Helvetica Bold", size: 12.0)
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.center
            let attributeDict: [NSAttributedString.Key : Any] = [
                .font: font!,
                .foregroundColor: tColor,
                .paragraphStyle: textStyle,
                ]
            
            // Select image and draw in text
            img.lockFocus()
            
            text.draw(in: textRect, withAttributes: attributeDict)
            
            img.unlockFocus()
        }
        
        return img
    }
    
    // Needs to be available in the Objective-C runtime for notification center
    @objc func updateSpace() {
        let activeSpace = getCurrentSpace()
        
        statusBar.button?.image = generateImage(activeSpace)
    }
    
    func getCurrentSpace() -> Int {
        // Both return CFArrays which are not fun to deal with
        let allWindows = CGWindowListCopyWindowInfo(CGWindowListOption.optionAll, kCGNullWindowID)
        let currentWindow = CGWindowListCopyWindowInfo(CGWindowListOption.optionOnScreenOnly, kCGNullWindowID)
        
        // Get all desktop pictures in order, and grab currently active desktop picture
        let allMatched = parseWindowData(String(describing: allWindows))
        let currentMatched = parseWindowData(String(describing: currentWindow))[0]
        
        totalSpaces = allMatched.count
        
        // Since pattern returns matches in reverse order, subtract matched index from total
        for (i, item) in allMatched.enumerated() {
            if item == currentMatched {
                return totalSpaces-i
            }
        }
        
        // If fails, then return something that can't be displayed
        return 0
    }
    
    // Use regex to get the name of the desktop picture
    func parseWindowData(_ text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: "(?<=Desktop Picture - )(.*)(?=\\\")")
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    @objc func quitClicked() {
        NSApplication.shared.terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
