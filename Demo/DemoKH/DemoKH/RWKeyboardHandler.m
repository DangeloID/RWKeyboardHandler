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
    //set initial keyboard height
    //for iPhone = 216
    //TODO: Add default value for iPad
    keyboardHeight = 216;
    initialRect = self.frame;

    textFields = [[NSMutableArray alloc] init];

    [self getAllTextField];
    [self registerForKeyboardNotifications];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];

    //set full screen content size
    self.contentSize = CGSizeMake(initialRect.size.width, initialRect.size.height);
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
    //get keyboard size
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;

    //set the scrollView size according to the keyboard size
    self.frame = CGRectMake(initialRect.origin.x,
                            initialRect.origin.y,
                            initialRect.size.width,
                            initialRect.size.height - keyboardHeight);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)notification
{
    self.contentOffset = CGPointMake(0, 0);
    self.frame = initialRect;
}

- (void)showActiveTextField:(UITextField *)activeField
{
    //calculate distance between active text field and keyboard top border
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screen.size.height;
    CGFloat yKeyboard = screenHeight - keyboardHeight;
    CGRect fieldFrame = activeField.frame;
    CGFloat bottomPointTextFiled = fieldFrame.origin.y + fieldFrame.size.height;

    //if keyboard closes active text field - scroll up
    if (yKeyboard < bottomPointTextFiled) {
        CGPoint offset = CGPointMake(0.0, activeField.frame.origin.y - keyboardHeight + 10);
        [self setContentOffset:offset animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    [self showActiveTextField:textField];
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
