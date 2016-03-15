//
//  ViewController.swift
//  tips
//
//  Created by ericslee on 2/28/16.
//  Copyright © 2016 ericcodepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var tipSymbolLabel: UILabel!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var equalsSymbolLabel: UILabel!

  @IBOutlet weak var twoPeopleSymbolLabel: UILabel!
  @IBOutlet weak var threePeopleSymbolLabel: UILabel!
  @IBOutlet weak var fourPeopleSymbolLabel: UILabel!
  @IBOutlet weak var twoPeopleSplitLabel: UILabel!
  @IBOutlet weak var threePeopleSplitLabel: UILabel!
  @IBOutlet weak var fourPeopleSplitLabel: UILabel!

  @IBOutlet weak var settingsButton: UIBarButtonItem!

  var isDarkTheme = false

  var isFirstAppearance = true

  let formatter = NSNumberFormatter()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Store a reference to this view controller in the app delegate.
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.mainViewController = self

    // Use locale specific currency.
    formatter.numberStyle = .CurrencyStyle

    tipLabel.text = formatter.stringFromNumber(0)
    totalLabel.text = formatter.stringFromNumber(0)

    // Remember the bill amount across app restarts if it has been <10 min since
    // app restart. If it has been >10 min, the stored bill amount will have been
    // overwritten to zero.
    let defaults = NSUserDefaults.standardUserDefaults()
    if let savedBill = defaults.objectForKey(kLastBillAmount) {
      if (savedBill as? String != "") {
        billField.text = savedBill as? String
        onEditingChanged(billField)
      }
    }

    self.billField.becomeFirstResponder()

    isFirstAppearance = false
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultTip = defaults.integerForKey(kDefaultTip)
    let defaultTheme = defaults.integerForKey(kDefaultColorTheme)
    tipControl.selectedSegmentIndex = defaultTip
    isDarkTheme = defaultTheme == 1 ? true : false

    // Change theme color if necessary.
    changeColorTheme()

    // Update tip amount.
    if (!isFirstAppearance) {
      onEditingChanged(self)
    }
  }

  @IBAction func onEditingChanged(sender: AnyObject) {
    var tipPercentages = [kDefaultSmallTipAmount, kDefaultMediumTipAmount, kDefaultLargeTipAmount]
    let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]

    let billAmount = (billField.text! as NSString).doubleValue
    let tip = billAmount * tipPercentage
    let total = billAmount + tip
    let splitByTwoTotal = total / 2.0
    let splitByThreeTotal = total / 3.0
    let splitByFourTotal = total / 4.0

    tipLabel.text = formatter.stringFromNumber(tip)!
    totalLabel.text = formatter.stringFromNumber(total)!
    twoPeopleSplitLabel.text = formatter.stringFromNumber(splitByTwoTotal)!
    threePeopleSplitLabel.text = formatter.stringFromNumber(splitByThreeTotal)!
    fourPeopleSplitLabel.text = formatter.stringFromNumber(splitByFourTotal)!

    animateElementsIn()
  }

  @IBAction func onTap(sender: AnyObject) {
    view.endEditing(true)
  }

  func animateElementsIn() {
    // Animate everything coming in
    // TODO: use constants.

    UIView.animateWithDuration(kMainViewAppearanceAnimationDuration,
      delay: 0,
      options: .CurveEaseInOut,
      animations: {
        self.billField.center = CGPointMake(self.billField.center.x, 130)

        // TODO: should put all these labels in one UIView for the left and right sides and just
        // animate those two views in.

        self.tipControl.alpha = 1.0;
        self.tipSymbolLabel.center =
            CGPointMake(50, self.tipSymbolLabel.center.y)
        self.tipLabel.center = CGPointMake(195, self.tipLabel.center.y)
        self.equalsSymbolLabel.center = CGPointMake(45, self.equalsSymbolLabel.center.y)
        self.totalLabel.center = CGPointMake(200, self.totalLabel.center.y)
        self.twoPeopleSymbolLabel.center = CGPointMake(50, self.twoPeopleSymbolLabel.center.y)
        self.twoPeopleSplitLabel.center = CGPointMake(200, self.twoPeopleSplitLabel.center.y)
        self.threePeopleSymbolLabel.center = CGPointMake(45, self.threePeopleSymbolLabel.center.y)
        self.threePeopleSplitLabel.center = CGPointMake(200, self.threePeopleSplitLabel.center.y)
        self.fourPeopleSymbolLabel.center = CGPointMake(45, self.fourPeopleSymbolLabel.center.y)
        self.fourPeopleSplitLabel.center = CGPointMake(200, self.fourPeopleSplitLabel.center.y)
        self.backgroundView.alpha = 0.8;
    }, completion: nil)
  }

  func changeColorTheme() {
    let newBackgroundColor = isDarkTheme ? kDarkColor : kLightColor
    let newTextColor = isDarkTheme ? kLightColor : kDarkColor
    let newTintColor =
    isDarkTheme ? UIColor.darkGrayColor() : UIColor.whiteColor()

    view.backgroundColor = newBackgroundColor
    billField.textColor = newTextColor
    tipLabel.textColor = newTextColor
    totalLabel.textColor = newTextColor
    tipControl.tintColor = newTextColor
    tipSymbolLabel.textColor = newTextColor
    equalsSymbolLabel.textColor = newTextColor

    twoPeopleSymbolLabel.textColor = newTextColor
    threePeopleSymbolLabel.textColor = newTextColor
    fourPeopleSymbolLabel.textColor = newTextColor
    twoPeopleSplitLabel.textColor = newTextColor
    threePeopleSplitLabel.textColor = newTextColor
    fourPeopleSplitLabel.textColor = newTextColor
    settingsButton.tintColor = newTextColor

    backgroundView.backgroundColor = newTintColor
    navigationController?.navigationBar.barTintColor = newTintColor
    UIApplication.sharedApplication().statusBarStyle =
      isDarkTheme ? .LightContent : .Default
  }
}

