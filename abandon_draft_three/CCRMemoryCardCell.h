//
//  CCRMemoryCardCell.h
//  MemoryProject
//
//  Created by Carl G Cota-Robles on 4/29/13.
//  Copyright (c) 2013 Carl G Cota-Robles. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@class CCRMemoryCardCell;
@interface CCRMemoryCardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)flip:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) IBOutlet UILabel *pronunciation;

@property (strong, nonatomic) AVAudioPlayer *soundEffectsPlayer;
@property (strong, nonatomic) AVAudioPlayer *recordingPlayer; //This audioplayer is specifically for playing the recordings when cards are flipped over.

@property (nonatomic, strong) UIImage *frontOfCard;
@property (nonatomic, strong) UIImage *backOfCard;
@property(nonatomic) NSInteger cardType; //Each card either has a card type of 0 or 1, 0 if it displays the english definition, 1 if it displays the chinese word.
@property(nonatomic) NSInteger prevCardType; //The card type of the previous card that was flipped over.

@property (nonatomic, strong) NSObject *storedClass; //Stores the NSObject (which contains a Chinese word and all the information about it) that is associated with this card

-(void)flipDown;
-(NSString*)parseEnglishToSlash:(NSString*)englishWord; //shortens the english definition so that the card is easier to read

-(void)setData:(NSObject *)info: (NSInteger)cardType;
-(void)syncLastCardFlipped:(NSNotification*)notification;
-(void)getRidOfCell;

-(void)writeData;
-(void)clearData;

-(void)runBeginningAnimation;

-(NSObject*)getStoredClass;
-(NSInteger)getCardType;

-(void)playRecording;

@end
