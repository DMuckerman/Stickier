//
//  AppDelegate.swift
//  Stickier
//
//  Created by Daniel Muckerman on 1/16/15.
//  Copyright (c) 2015 Daniel Muckerman. All rights reserved.
//

import Cocoa
import AppKit

extension NSStatusBarButton {
    public override func mouseDown(theEvent: NSEvent) {
        self.highlighted = true
        self.sendAction(self.action, to: nil)
    }
    
    public override func mouseUp(theEvent: NSEvent) {
        self.highlighted = false
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var subtitleField: NSTextField!
    @IBOutlet weak var noteField: NSTextField!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Intialize icon for status bar menu
        let icon = NSImage(named: "note_status_black")
        icon?.setTemplate(true)
        
        // Create status item
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.button?.action = "menuClicked:"
        
        // Set Notification Center Delegate
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
        
        // Make note window draggable from anywhere
        window.movableByWindowBackground = true
        window.movable = true
    }
    
    override func awakeFromNib() {
        // Let's define two handlers, which switch between the Vibrant Dark and the Vibrant Light appearance
        WAYTheDarkSide.welcomeApplicationWithBlock({self.window.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)}, immediately: true)
        
        WAYTheDarkSide.outcastApplicationWithBlock({self.window.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)}, immediately: true)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    // When New Notification is clicked!
    @IBAction func menuClicked(sender: AnyObject) {
        window.makeKeyAndOrderFront(nil)
        
        // Allow note window to present itself over all other apps
        window.level = Int(CGWindowLevelForKey(Int32(kCGFloatingWindowLevelKey))) + 1
        NSApp.activateIgnoringOtherApps(true)
    }
    
    // When the make note button is clicked!
    @IBAction func makeNote(sender: AnyObject) {
        if titleField.stringValue != "" || subtitleField.stringValue != "" || noteField.stringValue != "" {
            sendNotification(titleField.stringValue, subtitle: subtitleField.stringValue, message: noteField.stringValue)
        }
        
        closeWindow(self)
    }
    
    // Close the make a note window
    @IBAction func closeWindow(sender: AnyObject) {
        window.close()
        
        titleField.stringValue = "Reminder"
        subtitleField.stringValue = ""
        noteField.stringValue = ""
    }
    
    // Force Notification Center to present the notification, even if the app is focused
    func userNotificationCenter(center: NSUserNotificationCenter,
        shouldPresentNotification notification: NSUserNotification) -> Bool {
          return true
    }
    
    // Terminate app
    @IBAction func quitApp(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // Send feedback
    @IBAction func sendFeedback(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string:"mailto:danielmuckerman@me.com?subject=Stickier%20Feedback")!)
    }
    
    /**
    Send the user a notification
    
    :param: title    The notification's title
    :param: subtitle The notification's subtitle
    :param: message  The notification's message
    */
    func sendNotification(title: NSString, subtitle: NSString, message: NSString) {
        var notification:NSUserNotification = NSUserNotification()
        
        notification.title = title as String
        notification.subtitle = subtitle as String
        notification.informativeText = message as String
        notification.hasActionButton = false
        
        notification.soundName = NSUserNotificationDefaultSoundName
        
        notification.deliveryDate = NSDate(timeIntervalSinceNow: 1)
        var notificationcenter:NSUserNotificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
        
        let notificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
        notificationcenter.scheduleNotification(notification)
    }

}