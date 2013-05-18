//
//  BubbleView.h
//  abandon_draft_three
//
//  Created by Carl G Cota-Robles on 5/11/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BubbleView : UIButton

-(void)setUpBubble: (NSObject*)thisBubbleWord;

@property (nonatomic) Boolean floatingDown;
@property (nonatomic) NSInteger xDirection;
@property (nonatomic) Boolean moving; //This tells the bubble if it should move around or not, only set to yes when the bubble is grabbed.
@property (nonatomic) NSInteger sizeOfBubble;

@property (nonatomic, strong) NSObject *thisBubbleWord;

@property (nonatomic, strong) AVAudioPlayer *recordingPlayer;

-(void)bubbleGrabbed;
-(void)bubbleReleased;
-(void)animatePopping;
-(void)animateRejection;

-(void)enableUserInteraction;

-(NSObject*)getThisBubbleWord;

@end
