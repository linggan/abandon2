//
//  BubbleView.m
//  abandon_draft_three
//
//  Created by Carl G Cota-Robles on 5/11/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "BubbleView.h"

@implementation BubbleView

//IF YOU CHANGE THESE MAKE SURE TO ALSO CHANGE THESE VALUES IN THE BUBBLEGAMEVIEWCONTROLLER CLASS
#define POP_TIME 2
#define FAIL_TIME 1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setUpBubble:(NSObject*)thisBubbleWord
{
    self.floatingDown = YES;
    self.xDirection = 1;
    self.moving = YES;
    self.sizeOfBubble = self.frame.size.width;
    
    self.thisBubbleWord = thisBubbleWord;
            
    UIImage *bubbleImage = [UIImage imageNamed:@"Bubble"];
    [self setBackgroundImage:bubbleImage forState:UIControlStateNormal];
        
    NSTimer *animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animateBubble) userInfo:nil repeats:YES]; //This timer animates the bubbles and makes them move in a set direction.
    
    NSTimer *switchDirectionTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(switchDirection) userInfo:nil repeats:YES]; //This timer runs less often and changes the direction that the bubbles move in.
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{ //Makes the bubbles follow the user's finger when they're grabbed.
    UITouch *touch = [touches anyObject];
    CGPoint PointToMoveBubbleTo = [touch locationInView:self.superview];
    if (PointToMoveBubbleTo.x < 0) {
        PointToMoveBubbleTo.x = 0;
    }
    if (PointToMoveBubbleTo.y < 0) {
        PointToMoveBubbleTo.y = 0;
    }
    [self setFrame:CGRectMake(PointToMoveBubbleTo.x-self.frame.size.width/2, PointToMoveBubbleTo.y-self.frame.size.height/2, self.sizeOfBubble, self.sizeOfBubble)];
}

-(void)animateBubble
{
    float currentX = self.frame.origin.x;
    float currentY = self.frame.origin.y;

    if (self.moving == NO)
    {
        return;
    }
        
    if (!self.floatingDown)
    {
        currentY--;
    }
    else if (self.floatingDown)
    {
        currentY++;
    }
        
    //KEEPS THE BUBBLES FROM GOING OFF SCREEN
    if (currentY+self.frame.size.height> self.superview.frame.size.height)
    {
        self.floatingDown = NO;
    }
    
    if (currentY < 70)
    {
        self.floatingDown = YES;
    }
    
    if (currentX < 70)
    {
        self.xDirection = 1;
    }
    
    if (currentX+self.frame.size.width > self.superview.frame.size.width)
    {
        self.xDirection = -1;
    }
    
    [self setFrame:CGRectMake(currentX+self.xDirection, currentY, self.frame.size.width, self.frame.size.height)];
}

-(void)switchDirection //ONLY OCCASIONALLY CHANGES DIRECTION
{
    NSInteger direction = random()%10;
    
    switch (direction) {
        case 0:
            self.xDirection = 1;
            break;
        case 1:
            self.xDirection = -1;
        default:
            break;
    }

}

-(void)animatePopping
{
    self.userInteractionEnabled = NO;
    [UIView beginAnimations:@"pop" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:NO];
    [UIView setAnimationDuration:POP_TIME];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    
    [self setFrame:CGRectMake(self.frame.origin.x-self.frame.size.width, self.frame.origin.y-self.frame.size.height, self.frame.size.width*2, self.frame.size.height*2)];
    
    [UIView commitAnimations];
}

-(void)animateRejection
{
    self.userInteractionEnabled = NO;
    [UIView beginAnimations:@"pop" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:NO];
    [UIView setAnimationDuration:FAIL_TIME];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(enableUserInteraction)];
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+200, self.frame.size.width, self.frame.size.height)];
    
    [UIView commitAnimations];

}

-(void)enableUserInteraction
{
    self.userInteractionEnabled = YES;
}

-(void)bubbleGrabbed
{
    self.moving = NO; //when it's grabbed, stops the animation
    [self playRecording];
}

-(void)bubbleReleased
{
    if (self.frame.origin.y < 70)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleReleasedInDefinitionZone" object:self];
    }
    self.moving = YES;
    [self.recordingPlayer stop];
}

-(NSObject*)getThisBubbleWord {
    return self.thisBubbleWord;
}

-(void)playRecording
{
    NSURL *url;
    if ([self.getThisBubbleWord valueForKey:@"chineseRecording"] != nil) {
        url = [NSURL fileURLWithPath:[self.getThisBubbleWord valueForKey:@"chineseRecording"]];
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
