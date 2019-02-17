//
//  AppDelegate.swift
//  macos-spaces
//
//  Created by Collin Murch on 1/20/19.
//  Copyright © 2019 collinmurch. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar: NSStatusItem = NSStatusBar.system.statusItem(withLength: -1)
    var menu: NSMenu = NSMenu()
    var menuItem: NSMenuItem = NSMenuItem()
    
    @IBOutlet weak var workspace: NSWorkspace!
    
    let path = "~/Library/Preferences/com.apple.spaces.plist"

    override func awakeFromNib() {
        workSpaceObserver()
        
        statusBar.menu = menu
        
        updateSpace()
        
        menuItem.title = "Collin's app"
        menu.addItem(menuItem)
    }
    
    if DispatchSource
    
    func workSpaceObserver() {
        workspace = NSWorkspace.shared
        workspace.notificationCenter.addObserver(
            self,
            selector: #selector(AppDelegate.updateSpace),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: workspace
        )
    }
    
    func generateImage(activeSpace: Int, totalSpaces: Int) -> NSImage {
        let img: NSImage = NSImage(size: NSSize.init(width: 68.0, height: 15.0))
        
        var text: String
        var bColor: NSColor
        var tColor: NSColor
        
        for i in 1...totalSpaces {
            text = "\(i)"
            
            let rect = NSMakeRect(0.0 + CGFloat(i-1)*17.0, 0, 15, 15)
            let textRect = NSMakeRect(-5 + CGFloat(i-1)*17.0, -11, 25, 25)
            
            let path: NSBezierPath = NSBezierPath(roundedRect: rect, xRadius: 2.5, yRadius: 2.5)
            
            img.lockFocus()
            
            NSColor.white.set()
            path.fill()
            
            img.unlockFocus()
            
            if i == activeSpace {
                let iRect = NSMakeRect(1 + CGFloat(i-1)*17.0, 1, 13, 13)
                let iPath: NSBezierPath = NSBezierPath(roundedRect: iRect, xRadius: 2.5, yRadius: 2.5)
                
                tColor = NSColor.white
                bColor = NSColor.black
                
                img.lockFocus()
                
                bColor.set()
                iPath.fill()
                
                img.unlockFocus()
            } else {
                tColor = NSColor.black
                bColor = NSColor.white
            }
        
            let font = NSFont(name: "Helvetica Bold", size: 12.0)
            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.center
            
            
            let attributeDict: [NSAttributedString.Key : Any] = [
                .font: font!,
                .foregroundColor: tColor,
                .paragraphStyle: textStyle,
                ]
            
            img.lockFocus()
            
            text.draw(in: textRect, withAttributes: attributeDict)
            
            img.unlockFocus()
        }
        
        return img
    }
    
    // Needs to be available in the Objective-C runtime for notification center
    @objc func updateSpace() {
        let space = getCurrentSpace()
        
        statusBar.button?.image = generateImage(activeSpace: space, totalSpaces: 4)
    }
    
    func getCurrentSpace() -> Int {
        let location = NSString(string: path).expandingTildeInPath
        let fileContent = NSDictionary(contentsOfFile: location)!
        
        // Doing it this way is the pits but I can't find a better way
        // I hate intermediate object declaration
        let data = (((fileContent["SpacesDisplayConfiguration"] as! NSDictionary)["Management Data"] as! NSDictionary)["Monitors"] as! NSArray)[0] as! NSDictionary
        
        // Grab ID of current space, but this one doesn't necessarily coorespond to the space
        // Just gives a starting point. We have to make it relative
        let currentSpaceID = (data["Current Space"] as! NSDictionary)["ManagedSpaceID"] as! Int

        let spaceList = data["Spaces"] as! NSArray
        
        // Iterate through all created spaces
        // If space ID is current ID, then return it's position in the list (fixes dumb ID assignments)
        for (i, item) in spaceList.enumerated() {
            let spaceID = (item as! NSDictionary)["ManagedSpaceID"] as! Int
            
            if spaceID == currentSpaceID {
                return i + 1
            }
        }
        
        return 4
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
