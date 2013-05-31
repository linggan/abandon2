//
//  VocabBreakdownViewController.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/31/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VocabList.h"
#import <AVFoundation/AVFoundation.h>

@interface VocabBreakdownViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic, retain) VocabList *vocabList;
@property (nonatomic, retain) AVAudioPlayer *player;


@end
