//
//  TDCustomKeyboard.m
//  TD-DecimalKeyboard
//
//  Created by Babak Samareh on 2017-11-24.
//  Copyright © 2017 touchDev. All rights reserved.
//

#import "TDDecimalKeyboard.h"

@implementation TDDecimalKeyboard

// Initialization
- (id)init
{
    if (self = [super init])
    {
        // Set defaults
        self.enableAccessoryView = YES;
        self.screenTint = 0.4;
        self.keyboardTint = [UIColor blueColor];
        self.highlightTint = [UIColor colorWithRed:190.0/250.0 green:190.0/250.0 blue:190.0/250.0 alpha:1.0];
    }
    
    return self;
}

// Attach keyboard to textField
- (void)attachKeyboardToTextField:(UITextField *)textField
{
    // Return if the keyboard already exists in the view
    if (keyboard) return;
    
    // Assign the textField to make them visible to the rest of the methods
    hostTextField = textField;
    
    // Disable the keyboard and input accessory view for textfields
    [textField setInputView:[UIView new]];
    [textField.inputAssistantItem setLeadingBarButtonGroups:@[]];
    
    // Get the main app window
    window = [UIApplication sharedApplication].keyWindow;
    if (!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    // Create the black mask layer
    [self createBlackMask];
    
    // Animate the black mask
    [UIView animateWithDuration:0.25 animations:^{[blackMask setAlpha:self.screenTint];}];
    
    // Create the keyboard
    [self createKeyboardView];
    
    // Move the keyboard into the view with blackMask
    CGRect keyboardFrame = keyboard.frame;
    keyboardFrame.origin.y -= keyboardFrame.size.height+10.0;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[keyboard setFrame:keyboardFrame];}
                     completion:nil];
}

// Close keyboard if it is in the view
- (void)closeCustomKeyboards
{
    // Close the keyboard if it is present
    [self keyboardClosePressed:nil];
}

#pragma Generate keyboard and black mask

// Generate the black mask
- (void)createBlackMask
{
    // Create the layer
    blackMask = [[UIView alloc] initWithFrame:window.bounds];
    [blackMask setBackgroundColor:[UIColor blackColor]];
    [blackMask setAlpha:0.0];
    
    // Add tag gesture to black mask to dismiss the keyboard
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardClosePressed:)];
    [blackMask addGestureRecognizer:singleFingerTap];
    
    // Add the black mask to the window
    [window addSubview:blackMask];
}

// Generate the keyboard view
- (void)createKeyboardView
{
    // Set keyboard height and width
    int keyboardWidth = window.frame.size.width-2*5.0;;
    int keyboardHeight = 230;
    
    // Set padding, key dimensions, and accessory view height
    float keyPadding = 7.0;
    float keyWidth = (keyboardWidth-4*keyPadding)/3;
    float keyHeight = (keyboardHeight-5*keyPadding)/4;
    float accessoryViewHeight = 0.0;
    
    // Adjust keyboard parameters to accomodate accessory view
    if (self.enableAccessoryView)
    {
        accessoryViewHeight = 40.0;
        keyboardHeight += accessoryViewHeight;
    }
    
    // Create keyboard UIView
    keyboard = [[UIView alloc] initWithFrame:CGRectMake(5.0, window.frame.size.height, keyboardWidth, keyboardHeight)];
    [keyboard.layer setCornerRadius:8.0];
    [keyboard setClipsToBounds:YES];
    [keyboard setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    // Add swipe gesture recognizer to close the keyboard
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardClosePressed:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [keyboard addGestureRecognizer:swipeDown];
    
    // Generate number keys (1...9)
    for (int row = 0; row < 3; row++)
    {
        for (int column = 0; column < 3; column++)
        {
            // Generate title and origin
            NSString *keyTitle = [NSString stringWithFormat:@"%d", row*3+column+1];
            float originX = keyPadding+column*(keyPadding+keyWidth);
            float originY = keyPadding+row*(keyPadding+keyHeight)+accessoryViewHeight;
            
            // Generate number keys
            UIButton *numberKey = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, keyWidth, keyHeight)];
            [numberKey addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
            [numberKey setTitle:keyTitle forState:UIControlStateNormal];
            [numberKey setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [numberKey.titleLabel setFont:[UIFont systemFontOfSize:numberKey.frame.size.height*0.5 weight:UIFontWeightMedium]];
            [numberKey setBackgroundImage:[self imageFromColor:self.highlightTint] forState:UIControlStateHighlighted];
            [numberKey setBackgroundColor:[UIColor whiteColor]];
            [numberKey.layer setCornerRadius:7.0];
            [numberKey setClipsToBounds:YES];
            [keyboard addSubview:numberKey];
        }
    }
    
    // Generate the zero key
    UIButton *zeroKey = [[UIButton alloc] initWithFrame:CGRectMake(2*keyPadding+keyWidth, 4*keyPadding+3*keyHeight+accessoryViewHeight, keyWidth, keyHeight)];
    [zeroKey addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [zeroKey setTitle:@"0" forState:UIControlStateNormal];
    [zeroKey setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [zeroKey.titleLabel setFont:[UIFont systemFontOfSize:zeroKey.frame.size.height*0.5 weight:UIFontWeightMedium]];
    [zeroKey setBackgroundImage:[self imageFromColor:self.highlightTint] forState:UIControlStateHighlighted];
    [zeroKey setBackgroundColor:[UIColor whiteColor]];
    [zeroKey.layer setCornerRadius:7.0];
    [zeroKey setClipsToBounds:YES];
    [keyboard addSubview:zeroKey];
    
    // Generate the plus/minus key
    UIButton *pmKey = [[UIButton alloc] initWithFrame:CGRectMake(keyPadding, 4*keyPadding+3*keyHeight+accessoryViewHeight, (keyWidth-keyPadding)/2.0, keyHeight)];
    [pmKey addTarget:self action:@selector(plusMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
    [pmKey setTitle:@"±" forState:UIControlStateNormal];
    [pmKey setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pmKey.titleLabel setFont:[UIFont systemFontOfSize:pmKey.frame.size.height*0.5 weight:UIFontWeightMedium]];
    [pmKey setBackgroundImage:[self imageFromColor:self.highlightTint] forState:UIControlStateHighlighted];
    [pmKey setBackgroundColor:[UIColor whiteColor]];
    [pmKey.layer setCornerRadius:7.0];
    [pmKey setClipsToBounds:YES];
    [keyboard addSubview:pmKey];
    
    // Generate the decimal key
    UIButton *decimalKey = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pmKey.frame)+keyPadding, 4*keyPadding+3*keyHeight+accessoryViewHeight, (keyWidth-keyPadding)/2.0, keyHeight)];
    [decimalKey addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
    [decimalKey setTitle:@"." forState:UIControlStateNormal];
    [decimalKey setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [decimalKey.titleLabel setFont:[UIFont systemFontOfSize:decimalKey.frame.size.height*0.5 weight:UIFontWeightMedium]];
    [decimalKey setBackgroundImage:[self imageFromColor:self.highlightTint] forState:UIControlStateHighlighted];
    [decimalKey setBackgroundColor:[UIColor whiteColor]];
    [decimalKey.layer setCornerRadius:7.0];
    [decimalKey setClipsToBounds:YES];
    [keyboard addSubview:decimalKey];
    
    // Generate the backspace key
    UIButton *backSpaceKey = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zeroKey.frame)+keyPadding, 4*keyPadding+3*keyHeight+accessoryViewHeight, keyWidth, keyHeight)];
    [backSpaceKey addTarget:self action:@selector(backSpacePressed:) forControlEvents:UIControlEventTouchUpInside];
    [backSpaceKey setImage:[UIImage imageNamed:@"backspace"] forState:UIControlStateNormal];
    [backSpaceKey setBackgroundImage:[self imageFromColor:self.highlightTint] forState:UIControlStateHighlighted];
    [backSpaceKey setBackgroundColor:self.keyboardTint];
    [backSpaceKey.layer setCornerRadius:7.0];
    [backSpaceKey setClipsToBounds:YES];
    [keyboard addSubview:backSpaceKey];
    
    // Add the accessory view if requested
    if (self.enableAccessoryView)
    {
        // Add the keyboard close button
        UIButton *keyboardClose = [UIButton buttonWithType:UIButtonTypeSystem];
        [keyboardClose setFrame:CGRectMake(keyboardWidth-50.0-keyPadding, 0.0, 50.0, accessoryViewHeight+keyPadding)];
        [keyboardClose addTarget:self action:@selector(keyboardClosePressed:) forControlEvents:UIControlEventTouchUpInside];
        [keyboardClose setContentMode:UIViewContentModeCenter];
        [keyboardClose setImage:[UIImage imageNamed:@"keyboardClose"] forState:UIControlStateNormal];
        [keyboardClose setTintColor:[UIColor blackColor]];
        [keyboard addSubview:keyboardClose];
        
        // Add the accessory view textfield
        accessoryTextField = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, 200.0, accessoryViewHeight+keyPadding)];
        [accessoryTextField setUserInteractionEnabled:NO];
        [accessoryTextField setText:hostTextField.text];
        [keyboard addSubview:accessoryTextField];
    }
    
    // Add the keyboard to the window
    [window addSubview:keyboard];
}

#pragma Keyboard action control

// Keyboard keys pressed
- (void)keyPressed:(UIButton *)sender
{
    // Update the host text field
    [hostTextField setText:[NSString stringWithFormat:@"%@%@", hostTextField.text, sender.titleLabel.text]];
    [hostTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    
    // Update the accessory text field
    if (self.enableAccessoryView) [accessoryTextField setText:hostTextField.text];
}

// Keyboard plus/minus pressed
- (void)plusMinusPressed:(UIButton *)sender
{
    if ([hostTextField.text containsString:@"-"])
        hostTextField.text = [hostTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    else
        hostTextField.text = [NSString stringWithFormat:@"-%@", hostTextField.text];
    
    // Update the accessory text field
    if (self.enableAccessoryView) [accessoryTextField setText:hostTextField.text];
}

// Keyboard backspace pressed
- (void)backSpacePressed:(UIButton *)sender
{
    hostTextField.text = [hostTextField.text substringToIndex:hostTextField.text.length-(hostTextField.text.length>0)];
    [hostTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    
    // Update the accessory text field
    if (self.enableAccessoryView) [accessoryTextField setText:hostTextField.text];
}

// Keyboard close pressed
- (void)keyboardClosePressed:(UIButton *)sender
{
    // Return if no keyboard
    if (!keyboard) return;
    
    // Resign first responder
    [hostTextField resignFirstResponder];
    
    // Move the keyboard out of the view and remove it, then resign the first responder for host view
    CGRect keyboardFrame = keyboard.frame;
    keyboardFrame.origin.y = window.frame.size.height;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[keyboard setFrame:keyboardFrame];}
                     completion:^(BOOL finished){[keyboard removeFromSuperview]; keyboard = nil;}];
    
    // Animate the blackMask and remove it after completion
    [UIView animateWithDuration:0.25
                     animations:^{[blackMask setAlpha:0.0];}
                     completion:^(BOOL finished){[blackMask removeFromSuperview];}];
}

// Create background image from color, used for UIButton highlighted state
- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
