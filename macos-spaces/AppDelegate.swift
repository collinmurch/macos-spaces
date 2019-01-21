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

    var statusBar = NSStatusBar.system.statusItem(withLength: -1)
    var menu: NSMenu = NSMenu()
    var menuItem : NSMenuItem = NSMenuItem()

    override func awakeFromNib() {
        statusBar.menu = menu
        statusBar.button?.title = "Presses"
        
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

