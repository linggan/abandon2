//
//  NavigationViewController.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/5/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"
#import "CoreDataDelegate.h"


@interface NavigationViewController : UINavigationController

@property (strong, readonly, nonatomic) REMenu *menu;
@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;

- (void)toggleMenu;

@end
