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

@property (weak, nonatomic) IBOutlet UIImageView *picRepresentation;
@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) IBOutlet UILabel *pronunciation;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) UIImage *frontOfCard;
@property (nonatomic, strong) UIImage *backOfCard;
@property(nonatomic) NSInteger cardType;
@property(nonatomic) NSInteger prevCardType;

@property (nonatomic, strong) NSObject *storedClass;

-(void)flipDown;
-(NSString*)parseEnglishToSlash:(NSString*)englishWord;

-(void)setData:(NSObject *)info: (NSInteger)cardType;
-(void)syncLastCardFlipped:(NSNotification*)notification;
-(void)getRidOfCell;

-(void)writeData;
-(void)clearData;

-(void)runBeginningAnimation;

-(NSObject*)getStoredClass;
-(NSInteger)getCardType;

@end
