//
//  ViewController.m
//  DemoKH
//
//  Created by Dangelo on 5/26/13.
//  Copyright (c) 2013 Dangelo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize keyboardHandler = _keyboardHandler;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keyboardHandler.keyboardDelegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
#pragma mark - RWKeyboardHandler
- (void)lastTextFieldShouldReturn
{

}

@end
