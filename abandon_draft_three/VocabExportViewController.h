//
//  VocabExportViewController.h
//  abandonDraft
//
//  Created by Gwendolyn Weston on 4/28/13.
//  Copyright (c) 2013 Coefficient Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "CoreDataDelegate.h"
#import "ModalViewDelegate.h"

@interface VocabExportViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;
@property (nonatomic, retain) NSArray *wordList;
@property (nonatomic, retain) NSMutableArray *vocabList;
@property (nonatomic, retain) NSString *vocabListName;


@property (nonatomic, assign) id<ModalViewDelegate> modalDelegate;

@end
