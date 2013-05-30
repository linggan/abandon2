//
//  VocabViewController.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/28/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataDelegate.h"
#import "ModalViewDelegate.h"

@interface VocabViewController : UIViewController <UIScrollViewDelegate, ModalViewDelegate>

@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;
@property (nonatomic, retain) NSArray *vocabLists;

@end
