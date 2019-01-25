//
//  AppDelegate.swift
//  macos-spaces
//
//  Created by Collin Murch on 1/20/19.
//  Copyright © 2019 collinmurch. All rights reserved.
//

/*
 
 Spaces notes - use app icon as the top menu bar choice and then let user prioritize
 what application they want to be shown -- right now images are working so maybe use that.
 
 Also -- implement choice between numbers and icons -- find away to programitacally generate
 the number icons for the status bar.
 
 SC.PNG was deleted. Oops.
 
 */

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar: NSStatusItem = NSStatusBar.system.statusItem(withLength: 100)
    var menu: NSMenu = NSMenu()
    var menuItem: NSMenuItem = NSMenuItem()
    
    override func awakeFromNib() {
        statusBar.menu = menu
        statusBar.button?.title = "Presses"
        
        statusBar.button?.image = generateImage()
        
        menuItem.title = "Collin's app"
        menu.addItem(menuItem)
    }
    
    func generateImage() -> NSImage {
        let img: NSImage = NSImage(size: NSSize.init(width: 68.0, height: 15.0))
        
        let bColor = NSColor.white
        let tColor = NSColor.black
        
        var text: String
        let font = NSFont(name: "Helvetica Bold", size: 12.0)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.center
        
        
        let attributeDict: [NSAttributedString.Key : Any] = [
            .font: font!,
            .foregroundColor: tColor,
            .paragraphStyle: textStyle,
            ]
        
        for i in 1...4 {
            text = "\(i)"
            
            let rect = NSMakeRect(0.0 + CGFloat(i-1)*17.0, 0, 15, 15)
            let textRect = NSMakeRect(-5 + CGFloat(i-1)*17.0, -11, 25, 25)
            
            let path: NSBezierPath = NSBezierPath(roundedRect: rect, xRadius: 2.5, yRadius: 2.5)
            
            img.lockFocus()
            
            bColor.set()
            path.fill()
            
            img.unlockFocus()
            
            img.lockFocus()
            
            text.draw(in: textRect, withAttributes: attributeDict)
            
            img.unlockFocus()
        }
        
        return img
    }
    
    func update(_ text: String) {
        statusBar.button?.title = "\(text)"
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
