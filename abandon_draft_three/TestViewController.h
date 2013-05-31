//
//  TestViewController.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/29/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ModalViewDelegate.h"

@interface TestViewController : UIViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate, ModalViewDelegate, AVAudioPlayerDelegate>

@property (nonatomic, retain) NSString *testingMode;
@property (nonatomic, retain) NSArray *wordList;

@property (weak, nonatomic) IBOutlet UILabel *translationLabel;
@property (weak, nonatomic) IBOutlet UILabel *recognitionLabel;
@property (retain, nonatomic) AVAudioPlayer *player;


@end
