//
//  ViewController.m
//  TD-DecimalKeyboard
//
//  Created by Babak Samareh on 2017-11-24.
//  Copyright © 2017 touchDev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize the keyboard
    decimalKeyboard = [[TDDecimalKeyboard alloc] init];
    [decimalKeyboard setKeyboardTint:[UIColor orangeColor]];
}

// Text field 1 edit did begin
- (IBAction)textField1EditBegan:(id)sender
{
    // Attach the decimal keyboard
    [decimalKeyboard setKeyboardStyle:TDKeyboardStyleLight];
    [decimalKeyboard setEnableAccessoryView:NO];
    [decimalKeyboard attachKeyboardToTextField:sender];
}

// Text field 2 edit did begin
- (IBAction)textField2EditBegan:(id)sender
{
    // Attach the decimal keyboard
    [decimalKeyboard setKeyboardStyle:TDKeyboardStyleDark];
    [decimalKeyboard setEnableAccessoryView:YES];
    [decimalKeyboard attachKeyboardToTextField:sender];
}

@end
