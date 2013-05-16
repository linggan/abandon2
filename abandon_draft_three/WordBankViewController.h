//
//  WordBankViewController.h
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/1/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataDelegate.h"
#import "CharacterInfoViewController.h"
#import "RecordViewController.h"
#import "VocabExportViewController.h"
#import "ModalViewDelegate.h"


@interface WordBankViewController : UIViewController <UIScrollViewDelegate, ModalViewDelegate, CharacterInfoViewControllerDelegate>
@property (nonatomic, retain) NSMutableArray *wordList;
@property (nonatomic, retain) id<CoreDataDelegate> dataDelegate;


@end
