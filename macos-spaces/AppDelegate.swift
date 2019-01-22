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

    var statusBar: NSStatusItem = NSStatusBar.system.statusItem(withLength: -1)
    var menu: NSMenu = NSMenu()
    var menuItem: NSMenuItem = NSMenuItem()
    
    override func awakeFromNib() {
        statusBar.menu = menu
        statusBar.button?.title = "Presses"
        
        // statusBar.button?.image = NSImage(named: "sc.png")
        
        menuItem.title = "Clicked"
        menu.addItem(menuItem)
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
