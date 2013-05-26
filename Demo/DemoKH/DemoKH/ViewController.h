//
//  ViewController.h
//  DemoKH
//
//  Created by Dangelo on 5/26/13.
//  Copyright (c) 2013 Dangelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWKeyboardHandler.h"

@interface ViewController : UIViewController <RWKeyboardHandlerDelegate>

@property (nonatomic, strong) IBOutlet RWKeyboardHandler *keyboardHandler;

@end
