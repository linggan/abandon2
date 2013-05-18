//
//  AppDelegate.h
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/1/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "NewCharacterScreenViewController.h"
#import "RecordViewController.h"
#import "CoreDataDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RootViewControllerDelegate, CoreDataDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
