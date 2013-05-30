//
//  RWKeyboardHandler.m
//  DemoKH
//
//  Created by Den on 5/26/13.
//  Copyright (c) 2013 Den. All rights reserved.
//

#import "RWKeyboardHandler.h"

@implementation RWKeyboardHandler

#pragma mark - Init methods
@synthesize keyboardDelegate = _keyboardDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initKeyboardHandler];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initKeyboardHandler];
}

- (void)initKeyboardHandler
{
    textFields = [[NSMutableArray alloc] init];

    [self getAllTextField];
    [self registerForKeyboardNotifications];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

- (void)getAllTextField
{
    NSInteger currentTag = 0;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.delegate = self;
            textField.tag = currentTag++;
            [textFields addObject:textField];
        }
    }
}

#pragma mark - Helpers
- (void)closeKeyboard
{
   [activeTextField resignFirstResponder];
}

- (void)reinitialize {

}


#pragma mark - Keyboard notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// unregistered for keyboard notifications while not visible.
- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidShow:(NSNotification*)notification
{
	initialRect = self.frame;
	//set full screen content size
    self.contentSize = CGSizeMake(initialRect.size.width, initialRect.size.height);

    //get keyboard size
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = keyboardSize.height;

	//Resize the scroll view to make room for the keyboard
    self.frame = CGRectMake(initialRect.origin.x,
                            initialRect.origin.y,
                            initialRect.size.width,
                            initialRect.size.height - keyboardHeight);
    [self showActiveTextField];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)notification
{
    self.contentOffset = CGPointMake(0, 0);
    self.frame = initialRect;
}

- (void)showActiveTextField
{
    CGRect textFieldRect = activeTextField.frame;
    textFieldRect.origin.y += 5;
    [self scrollRectToVisible:textFieldRect animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
	[self showActiveTextField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *lastField = [textFields lastObject];
    if ([lastField isEqual:textField]) {
        [self.keyboardDelegate lastTextFieldShouldReturn];
        [self closeKeyboard];
    } else {
        NSUInteger tag = (NSUInteger) (textField.tag + 1);
        UITextField *nextTextField = [textFields objectAtIndex:tag];
        [nextTextField becomeFirstResponder];
    }
    return YES;
}

@end
