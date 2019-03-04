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

    var darkMode: Bool = true

    var totalSpaces: Int = 1
    
    var statusBar: NSStatusItem = NSStatusBar.system.statusItem(withLength: -1)
    var menu: NSMenu = NSMenu()
    
    @IBOutlet weak var workspace: NSWorkspace!

    // Configure application
    override func awakeFromNib() {
        NSApplication.shared.setActivationPolicy(.accessory)
        
        statusBar.menu = menu
        // menu.addItem(withTitle: "@collinmurch", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Quit macos-spaces", action: #selector (quitClicked), keyEquivalent: "")
        
        // Update UIMode (also generates new image), and configure observers
        observers()
        updateUIMode()
    }
    
    // Configure observers for dark mode and space switch
    func observers() {
        // Configure observer that fires when desktop space changes
        workspace = NSWorkspace.shared
        
        workspace.notificationCenter.addObserver(
            self,
            selector: #selector(AppDelegate.updateSpace),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: workspace
        )
        
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUIMode(sender: )),
            name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"),
            object: nil
        )
    }
    
    // Generate an image based on currently focused space
    func generateImage(activeSpace: Int) -> NSImage {
        // Create an image that is the correct size to hold all space boxes
        let img: NSImage = NSImage(size: NSSize.init(width: 17.0*Double(totalSpaces), height: 15.0))
        
        var text: String
        var bColor: NSColor
        var tColor: NSColor
        
        // Make new number rect for each space
        for i in 1...totalSpaces {
            text = "\(i)"
            
            // Create a text box
            let textRect = NSMakeRect(-5 + CGFloat(i-1)*17.0, -11, 25, 25)
            
            // If you get to the active space, then do the following (special)
            if i == activeSpace {
                
                // Create new rounded rect inside of original, to be background color
                let iRect = NSMakeRect(1 + CGFloat(i-1)*17.0, 1, 13, 13)
                let iPath: NSBezierPath = NSBezierPath(roundedRect: iRect, xRadius: 2.5, yRadius: 2.5)
                
                // Check for dark mode, and set colors appropriately
                if darkMode {
                    tColor = NSColor.black
                    bColor = NSColor.white
                } else {
                    tColor = NSColor.white
                    bColor = NSColor.black
                }
                
                // Select rounded rect and fill with background color
                img.lockFocus()
                
                bColor.set()
                iPath.fill()
                
                img.unlockFocus()
            } else {
                // Otherwise, set text color appropriately (no need for background color)
                if darkMode {
                    tColor = NSColor.white
                } else {
                    tColor = NSColor.black
                }
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
    
    // Update status bar icon
    @objc func updateSpace() {
        let currentSpace = getCurrentSpace()
        
        statusBar.button?.image = generateImage(activeSpace: currentSpace)
    }
    
    // Grab status of light or dark modes
    @objc func updateUIMode(sender: AnyObject?=nil) {
        let dictionary = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain);
        if let interfaceStyle = dictionary?["AppleInterfaceStyle"] as? NSString {
            self.darkMode = interfaceStyle.localizedCaseInsensitiveContains("dark")
        } else {
            self.darkMode = false
        }
        
        updateSpace()
    }
    
    // Get int of focused space
    func getCurrentSpace() -> Int {
        // Both return CFArrays which are not fun to deal with
        let allWindows = CGWindowListCopyWindowInfo(CGWindowListOption.optionAll, kCGNullWindowID)
        let currentWindow = CGWindowListCopyWindowInfo(CGWindowListOption.optionOnScreenOnly, kCGNullWindowID)
        
        // Get all desktop picture names in order, and grab currently active desktop
        let allMatched = parseWindowData(String(describing: allWindows))
        let currentMatched = parseWindowData(String(describing: currentWindow))
        
        totalSpaces = allMatched.count
        
        // Since pattern returns matches in reverse order, subtract matched index from total
        for (i, item) in allMatched.enumerated() {
            if item == currentMatched[0] {
                return totalSpaces-i
            }
        }
        
        // If fails, then return something that won't be displayed
        return 0
    }
    
    // Get desktop ID
    func parseWindowData(_ text: String) -> [String] {
        let lines = text.components(separatedBy: CharacterSet.newlines)
        var id = [String]()
        
        // Find line after "desktop" match, return all instances
        for (i, _) in lines.enumerated() {
            if lines[i].range(of:"Desktop Picture -") != nil {
                id.append(lines[i+1])
            }
        }
        
        return id
    }
    
    // Close application
    @objc func quitClicked() {
        NSApplication.shared.terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
