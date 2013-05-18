//
//  CCRMemoryCardCell.m
//  Memory
//
//  Created by Carl G Cota-Robles on 4/13/13.
//  Copyright (c) 2013 Carl G Cota-Robles. All rights reserved.
//

#import "CCRMemoryCardCell.h"
#import "CCRViewController.h"

@implementation CCRMemoryCardCell
{
    SystemSoundID winSoundID;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

#define FLIP_TIME .5
#define FLY_TIME 1
#define BEGINNING_ANIMATION_TIME 4

-(IBAction)flip:(id)sender
{
    if ((self.button.imageView.image == self.backOfCard) && ((self.prevCardType != self.cardType) || (self.prevCardType == 2))) {
        //Animates Card Flip
        [UIView beginAnimations:@"flip" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
        [UIView setAnimationDuration:FLIP_TIME];
        [UIView setAnimationDelegate:self];
        [self playRecording];
        [self playCardFlipSound];
        
        //Writes the info on the card
        [self writeData];
        
        [UIView commitAnimations];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CardFlippedUp" object:self]; //Passes notification to CCRViewController that the card was flipped
    }
}

-(void)flipDown
{
    if (self.button.imageView.image == self.frontOfCard) {
        [UIView beginAnimations:@"flip" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
        [UIView setAnimationDuration:FLIP_TIME];
        [UIView setAnimationDelegate:self];
        [self playCardFlipSound];
        [self.recordingPlayer stop];
        
        [self clearData]; //Deletes info
        
        [UIView commitAnimations];
    }
}

-(void)syncLastCardFlipped:(NSNotification *)notification
{
    if ([[notification object] getStoredClass] != self.storedClass)
    {
        [self.recordingPlayer stop];
    }
    
    if (self.prevCardType == 2)
    {
        self.prevCardType = [[notification object] getCardType];
    }
    else if (self.prevCardType != 2)
    {
        self.prevCardType = 2;
    }
}

-(void)setData:(NSObject *)info : (NSInteger)cardType
{
    //Sets the data that will be later written onto the card
    self.prevCardType = 2;
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //Removes a previous observer if it exists
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncLastCardFlipped:) name:@"CardFlippedUp" object:nil];
    self.cardType = cardType;
    self.storedClass = info;
    [self runBeginningAnimation];
}

-(void)writeData
{
    //Writes the info onto the card, different depending on the type of card.
    
    CGRect rectForLabelTop;
    
    if (self.cardType == 0) {
        NSString *english = [self parseEnglishToSlash:[self.storedClass valueForKey:@"english"]];
        self.word.text = english;
        rectForLabelTop = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        //self.picRepresentation.image = [UIImage imageNamed:@"BlueCard.png"];
    }
    else if (self.cardType == 1)
    {
        self.word.text = [self.storedClass valueForKey:@"chinese"];
        self.pronunciation.text =  [self.storedClass valueForKey:@"pinyin"];
        rectForLabelTop = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2);
        self.pronunciation.numberOfLines = 0;
        CGRect rectForLabelBottom = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);
        [self sizeLabel:self.pronunciation toRect:rectForLabelBottom];
    }
    
    self.word.numberOfLines = 0;
    [self sizeLabel:self.word toRect:rectForLabelTop];
    
    
    [self.button setImage:self.frontOfCard forState:UIControlStateNormal];
}

-(NSString*)parseEnglishToSlash:(NSString *)englishWord //shortens the english definition to only stuff before parenthesis
{
    for (int i=0; i<englishWord.length;i++)
    {
        char thisChar = [englishWord characterAtIndex:i];
        if (thisChar == '/')
        {
            englishWord = [englishWord substringToIndex:i];
            break;
        }
    }
    return englishWord;
}

-(void)clearData //Just clears the info in a cell, doesn't remove it.
{
    [self.button setImage:self.backOfCard forState:UIControlStateNormal];
    self.pronunciation.text = @"";
    self.word.text = @"";
    
    //if (self.cardType == 0)
    //NSString *currentScore = [self.storedClass valueForKey:@"score"];
}

//Code to size label, found on Stack Overflow http://stackoverflow.com/questions/7158581/changing-label-text-size-in-code
- (void) sizeLabel: (UILabel *) label toRect: (CGRect) labelRect  {
    
    // Set the frame of the label to the targeted rectangle
    label.frame = labelRect;
    
    // Try all font sizes from largest to smallest font size
    int fontSize = 40;
    int minFontSize = 5;
    
    // Fit label width wize
    CGSize constraintSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    
    do {
        // Set current font size
        label.font = [UIFont systemFontOfSize:fontSize];
        
        // Find label size for current font size
        CGSize labelSize = [[label text] sizeWithFont:label.font
                                    constrainedToSize:constraintSize
                                        lineBreakMode:UILineBreakModeWordWrap];
        
        // Done, if created label is within target size
        if( labelSize.height <= label.frame.size.height )
            break;
        
        // Decrease the font size and try again
        fontSize --;
        
    } while (fontSize > minFontSize);    
}

-(void)getRidOfCell //Removes the cell entirely, to be used when it's matched with another cell.
{
    CGPoint animateToPoint = CGPointMake(-60, 100);
    [UIView beginAnimations:@"moveOffScreen" context:nil];
    [UIView setAnimationTransition:UIViewAnimationOptionCurveLinear forView:self cache:NO];
    [UIView setAnimationDuration:FLY_TIME];
    [UIView setAnimationDelegate:self];
    [self.recordingPlayer stop];
        
    [self setCenter:animateToPoint];
    [UIView commitAnimations];
    
    /*
    if (self.cardType == 0) {
        NSInteger numberOfTimesRight = [[self.storedClass valueForKey:@"score"] intValue];
        numberOfTimesRight++;
        NSString *timesRight = [NSString stringWithFormat:@"%i", numberOfTimesRight];
        [self.storedClass setValue:timesRight forKey:@"score"];
    }*/
}

-(void)runBeginningAnimation
{    
    CGPoint animateToPoint = CGPointMake(-100.0, -100.0);
    CGPoint animateFromPoint = self.frame.origin;
    [UIView beginAnimations:@"beginningAnimation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationOptionCurveLinear forView:self cache:NO];
    [UIView setAnimationDuration:BEGINNING_ANIMATION_TIME];
    [UIView setAnimationDelegate:self];
    
    [self setCenter:animateToPoint];
    [self setCenter:animateFromPoint];
    [UIView commitAnimations];
}

-(NSObject *)getStoredClass
{
    return self.storedClass;
}

-(NSInteger)getCardType
{
    return self.cardType;
}

-(void)playCardFlipSound
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/FlipCard.wav", [[NSBundle mainBundle] resourcePath]]];
    NSError *error = nil;
    self.soundEffectsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.soundEffectsPlayer.volume = 0.1;
    [self.soundEffectsPlayer play];
}

-(void)playRecording
{
    NSURL *url;
    
    if (self.cardType==0) {
        if ([self.storedClass valueForKey:@"chineseRecording"] != nil) {
            url = [NSURL fileURLWithPath:[self.storedClass valueForKey:@"chineseRecording"]];
        }
    }
    else {
        if ([self.storedClass valueForKey:@"englishRecording"] != nil) {
            url = [NSURL fileURLWithPath:[self.storedClass valueForKey:@"englishRecording"]];
        }
    }
    
    if (url!=nil)
    {
        NSError *error = nil;
        self.recordingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.recordingPlayer.volume = 1.0;
        [self.recordingPlayer play];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
