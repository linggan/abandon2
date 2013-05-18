//
//  BubbleGameViewController.m
//  abandon_draft_three
//
//  Created by Carl G Cota-Robles on 5/11/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "BubbleGameViewController.h"
#import "BubbleView.h"
#import <QuartzCore/QuartzCore.h>

@interface BubbleGameViewController ()

@end

@implementation BubbleGameViewController

@synthesize wordList;

#define INAPP 5
#define TIMERVALUE 300

//IF YOU CHANGE THESE MAKE SURE TO ALSO CHANGE IN THE BUBBLEVIEW CLASS
#define POP_TIME 2
#define FAIL_TIME 1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"Bubble View Began!");
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(compareAnswer:) name:@"BubbleReleasedInDefinitionZone" object:nil];
    
    self.instructions.image = [UIImage imageNamed:@"Instructions.png"];
    self.showInstructions = YES; //Shows instructions to the user at the start
    
    NSLog(@"Bubble View Loaded!");
}

-(void)viewDidAppear:(BOOL)animated
{
    [self getWords:self];
    self.wordListTracker = 0;
    
    if (wordList.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Your word bank is empty!" message:@"You need words to make bubbles!" delegate:self cancelButtonTitle:@"Bounce!" otherButtonTitles:nil];
        alertView.tag = INAPP;
        [alertView show];
        self.stopTimer = YES;
        return;
    }
    
    if (self.showInstructions == 1) //If the screen is showing the instructions for this game, then don't display
        //anything else.
    {
        return;
    }
    
    NSString *value = [wordList[self.wordListTracker] valueForKey:@"english"];
    self.englishDefinition.text = value;
    self.popUpStatus.backgroundColor = [UIColor clearColor];
    self.counter = TIMERVALUE;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(countDown)
                                                    userInfo:nil
                                                     repeats:YES];

    
    srandom(time(NULL));
    for (int i=0;i<wordList.count;i++)
    { //Creates all the bubbles for each word in the list
        CGRect randomSquare = CGRectMake(random()%250, random()%400+100, 50, 50);
        BubbleView *button = [BubbleView buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:button
                   action:@selector(bubbleGrabbed)
         forControlEvents:UIControlEventTouchDown];
        [button addTarget:button
                   action:@selector(bubbleReleased)
         forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:[wordList[i] valueForKey:@"chinese"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = randomSquare;
        [button setUpBubble:wordList[i]];
        [self.view addSubview:button];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.wordListTracker = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)compareAnswer:(NSNotification *)notification
{ //This compares to see if the bubble that's been dragged into the definition zone is correct
    NSObject *bubbleWord = [[notification object] getThisBubbleWord];
    if (bubbleWord == wordList[self.wordListTracker]) { //If it's correct
        [[notification object] animatePopping]; //do popping animation
        
        //Display a little message
        self.popUpStatus.backgroundColor = [UIColor blackColor];
        self.popUpStatus.textColor = [UIColor whiteColor];
        self.popUpStatus.text = @"POP GOES THE WEASEL!";
        
        self.view.userInteractionEnabled = NO;
        [self.view bringSubviewToFront:self.popUpStatus];
        
        //after a certain period of time, erases the message
        [self performSelector:@selector(erasePopUpStatus) withObject:self afterDelay:POP_TIME];
        
        self.wordListTracker++;
        
        if (self.wordListTracker == wordList.count) { //If we're at the end of the word list, displays message we've won
            [self performSelector:@selector(exitWithSuccess) withObject:self afterDelay:POP_TIME];
            self.stopTimer = YES;
            return;
        }
        
        NSString *value = [wordList[self.wordListTracker] valueForKey:@"english"];
        self.englishDefinition.text = value;
    }
    else { //If it's incorrect, rejects it and does rejection animation and rejection message
        [[notification object] animateRejection];
        self.popUpStatus.backgroundColor = [UIColor redColor];
        self.popUpStatus.textColor = [UIColor blackColor];
        self.popUpStatus.text = @"REJECTED!";
        self.view.userInteractionEnabled = NO;
        [self.view bringSubviewToFront:self.popUpStatus];
        [self performSelector:@selector(erasePopUpStatus) withObject:self afterDelay:FAIL_TIME];
    }
}

-(void)erasePopUpStatus
{
    self.popUpStatus.backgroundColor = [UIColor clearColor];
    self.popUpStatus.text = @"";
    self.view.userInteractionEnabled = YES;
}

-(void)exitWithFailure
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Awful!" message:@"Bounce out of here!" delegate:self cancelButtonTitle:@"BOUNCE" otherButtonTitles:nil];
    alert.tag = INAPP;
    [alert show];
}

-(void)exitWithSuccess
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YEAH!" message:@"That was bubble-licious!" delegate:self cancelButtonTitle:@"POP" otherButtonTitles:nil];
    alert.tag = INAPP;
    [alert show];

}

-(void)countDown //Counts down the clock
{
    if ((self.counter != 0) && !self.stopTimer)
    {
        self.counter--;
        NSString *counterText = [[NSString alloc] initWithFormat:@"%i", self.counter];
        self.timerDisplay.text = counterText;
    }
    else if (self.counter == 0) {
        if (!self.stopTimer) {
            [self exitWithFailure];
        }
        self.stopTimer = YES;
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == INAPP) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getWords:(id)ViewController{
    wordList = [[self dataDelegate] getAllWords];
}


- (IBAction)closeInstructions:(id)sender {
    self.showInstructions = NO;
    [self.instructions removeFromSuperview];
    [self.instructionsButton removeFromSuperview];
    [self viewDidAppear:YES];
}
@end
