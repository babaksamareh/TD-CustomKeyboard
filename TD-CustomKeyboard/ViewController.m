//
//  ViewController.m
//  TD-CustomKeyboard
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
    customKeyboard = [[TDCustomKeyboard alloc] init];
    [customKeyboard setKeyboardTint:[UIColor orangeColor]];
}

// Text field 1 edit did begin
- (IBAction)textField1EditBegan:(id)sender
{
    // Attach the custom keyboard
    [customKeyboard setKeyboardStyle:TDKeyboardStyleLight];
    [customKeyboard setEnableAccessoryView:NO];
    [customKeyboard attachKeyboardToTextField:sender];
}

// Text field 2 edit did begin
- (IBAction)textField2EditBegan:(id)sender
{
    // Attach the custom keyboard
    [customKeyboard setKeyboardStyle:TDKeyboardStyleDark];
    [customKeyboard setEnableAccessoryView:YES];
    [customKeyboard attachKeyboardToTextField:sender];
}

@end
