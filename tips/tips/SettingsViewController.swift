//
//  SettingsViewController.swift
//  tips
//
//  Created by ericslee on 2/28/16.
//  Copyright © 2016 ericcodepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  @IBOutlet weak var tipTitleLabel: UILabel!
  @IBOutlet weak var themeLabel: UILabel!
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var themeControl: UISegmentedControl!

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultTip = defaults.integerForKey(kDefaultTip)
    let defaultTheme = defaults.integerForKey(kDefaultColorTheme)
    tipControl.selectedSegmentIndex = defaultTip
    themeControl.selectedSegmentIndex = defaultTheme

    changeColorTheme(false)
  }

  @IBAction func onTap(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func onValueChange(sender: AnyObject) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(tipControl.selectedSegmentIndex, forKey: kDefaultTip)
    defaults.synchronize()
  }

  @IBAction func onThemeValueChange(sender: AnyObject) {
    changeColorTheme(true)
  }

  func changeColorTheme(animated: Bool) {
    let isDarkTheme = themeControl.selectedSegmentIndex == 1 ? true : false

    // Set new theme value on the main VC.
    let parentNavVC = self.presentingViewController as! UINavigationController
    let parentVC = parentNavVC.topViewController as! ViewController
    parentVC.isDarkTheme = isDarkTheme

    // Change theme colors.
    let newBackgroundColor = isDarkTheme ? kDarkColor : kLightColor
    let newTextColor = isDarkTheme ? kLightColor : kDarkColor

    let animationDuration = animated ? kColorThemeChangeAnimationDuration : 0.0

    UIView.animateWithDuration(animationDuration, animations: {
      self.view.backgroundColor = newBackgroundColor
      self.doneButton.tintColor = newTextColor
      self.tipTitleLabel.textColor = newTextColor
      self.tipControl.tintColor = newTextColor
      self.themeLabel.textColor = newTextColor
      self.themeControl.tintColor = newTextColor
      UIApplication.sharedApplication().statusBarStyle =
        isDarkTheme ? .LightContent : .Default
    })

    // Save theme color to user presets.
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setInteger(themeControl.selectedSegmentIndex, forKey: kDefaultColorTheme)
    defaults.synchronize()
  }
}
