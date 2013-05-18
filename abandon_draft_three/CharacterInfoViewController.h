//
//  CharacterInfoViewController.h
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/2/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "CoreDataDelegate.h"


@protocol CharacterInfoViewControllerDelegate <NSObject>
- (void)didDeleteWord: (NSManagedObject *)word;
@end


@interface CharacterInfoViewController : UIViewController <ModalViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel<UIGestureRecognizerDelegate> *chinese;
@property (weak, nonatomic) IBOutlet UILabel *pinyin;
@property (weak, nonatomic) IBOutlet UILabel *english;
@property (weak, nonatomic) IBOutlet UILabel<UIGestureRecognizerDelegate> *breakdown;
@property (weak, nonatomic) IBOutlet UITextView *mnemonic;

@property (weak, nonatomic) IBOutlet UILabel *helpLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *helpLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *helpLabelThree;
@property (weak, nonatomic) IBOutlet UILabel *helpLabelFour;

@property (retain, nonatomic) NSManagedObject *word;
@property (retain, nonatomic) AVAudioPlayer *player;
@property (nonatomic, assign) id<ModalViewDelegate> modalDelegate;
@property (nonatomic, assign) id<CoreDataDelegate> dataDelegate;
@property (nonatomic, assign) id<CharacterInfoViewControllerDelegate> delegate;




- (void)dismissScreen;

@end
