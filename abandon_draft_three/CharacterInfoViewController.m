//
//  CharacterInfoViewController.m
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/2/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "CharacterInfoViewController.h"
#import "CharacterBreakdownViewController.h"
#import "FlatButton.h"
#import "RecordViewController.h"

#define kOFFSET_FOR_KEYBOARD 150.0

@implementation CharacterInfoViewController{
    BOOL helpVisible;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set labels
    [_chinese setText:[_word valueForKey:@"chinese"]];
    [_pinyin setText:[_word valueForKey:@"pinyin"]];
    [_english setText:[_word valueForKey:@"english"]];
    [_breakdown setText:[_word valueForKey:@"firstDecomp"]];
    [_mnemonic setText:[_word valueForKey:@"mnemonic"]];
    
    //send help labels to back
    helpVisible = FALSE;
    [[self view] sendSubviewToBack:[self helpLabelOne]];
    [[self view] sendSubviewToBack:[self helpLabelTwo]];
    [[self view] sendSubviewToBack:[self helpLabelThree]];
    [[self view] sendSubviewToBack:[self helpLabelFour]];
    
    [_mnemonic setDelegate:self];

    //add flat buttons
    UIButton *helpBtn;
    UIButton *deleteWordBtn;
    UIButton *gottenButton;
    
    if ([self hasFourInchDisplay]) {
        helpBtn = [FlatButton FlatButtonWithFrame:CGRectMake(27, 470, 75, 35) WithText:@"help" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.58]];
        [[helpBtn titleLabel] setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:13]];
    
        deleteWordBtn = [FlatButton FlatButtonWithFrame:CGRectMake(122, 470, 70, 35) WithText:@"delete word" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.58]];
        [[deleteWordBtn titleLabel] setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:13]];
        
        gottenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [gottenButton setFrame:CGRectMake(220, 470, 70, 35)];
    }
    else {
        helpBtn = [FlatButton FlatButtonWithFrame:CGRectMake(27, 400, 75, 35) WithText:@"help" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.58]];
        [[helpBtn titleLabel] setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:13]];
        
        deleteWordBtn = [FlatButton FlatButtonWithFrame:CGRectMake(122, 400, 70, 35) WithText:@"delete word" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.58]];
        [[deleteWordBtn titleLabel] setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:13]];
        
        gottenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [gottenButton setFrame:CGRectMake(220, 400, 70, 35)];
    }

    [[self view] addSubview:helpBtn];
    [helpBtn addTarget:self action:@selector(makeHelpVisible) forControlEvents:UIControlEventTouchDown];
    
    [[self view] addSubview:deleteWordBtn];
    [deleteWordBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchDown];
    
    [gottenButton setTitle:@"Got this." forState:UIControlStateNormal];
    [[gottenButton titleLabel] setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:13]];
    [self.view addSubview:gottenButton];
    [gottenButton addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchDown];

    //init audio player and sesson
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionsError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionsError];
    [session setActive:YES error:nil];


    if ([_word valueForKey:@"chineseRecording"]){
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[_word valueForKey:@"chineseRecording"]] error:nil];
        [_player setDelegate:self];
        [_player prepareToPlay];
    }
    
    //all the gesture recognizers
    //double tap for breakdown
    UITapGestureRecognizer *decompTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDecompTap:)];
    decompTap.numberOfTapsRequired = 2;
    decompTap.delegate = _breakdown;
    [[_breakdown viewWithTag:0]addGestureRecognizer:decompTap];
    
    //tap to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //tap to play recording
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlayTap:)];
    playTap.numberOfTapsRequired = 1;
    playTap.delegate = _chinese;
    [[_chinese viewWithTag:0]addGestureRecognizer:playTap];
    
    /* //to incorporate later
    //tap to redo recording
    UITapGestureRecognizer *recordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecordTap:)];
    recordTap.numberOfTapsRequired = 1;
    recordTap.numberOfTouchesRequired = 2;
    recordTap.delegate = _chinese;
    [[_chinese viewWithTag:0]addGestureRecognizer:recordTap];
     */

    
}

- (BOOL)hasFourInchDisplay { //detects if it's 4in or 3.5 in. retina display
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didSelectDone:(id)sender {
    [self.modalDelegate didDismissPresentedViewController];
}


- (void)dismissScreen {
    [self didSelectDone:self];
}

-(void)makeHelpVisible{
    
    if (!helpVisible){
        [[self view] bringSubviewToFront:[self helpLabelOne]];
        [[self view] bringSubviewToFront:[self helpLabelTwo]];
        [[self view] bringSubviewToFront:[self helpLabelThree]];
        [[self view] bringSubviewToFront:[self helpLabelFour]];

        helpVisible = TRUE;
    }
    else{
        [[self view] sendSubviewToBack:[self helpLabelOne]];
        [[self view] sendSubviewToBack:[self helpLabelTwo]];
        [[self view] sendSubviewToBack:[self helpLabelThree]];
        [[self view] sendSubviewToBack:[self helpLabelFour]];

        helpVisible = FALSE;

    }

}

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)handleDecompTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        
        CharacterBreakdownViewController *viewController = [[CharacterBreakdownViewController alloc]init];
        [viewController setText:[_word valueForKey:@"secondDecomp"]];
        viewController.modalDelegate = self;
        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:viewController animated:YES completion:NULL];

    }
}

- (void)handlePlayTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if(![_player url]){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hmmm..." message:@"Doesn't seem like you've recorded this word yet" delegate:self cancelButtonTitle:@"I understand." otherButtonTitles:nil];
            [alert show];
        }
        [_player play];        
    }
}

- (void)handleRecordTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        RecordViewController *controller = [[RecordViewController alloc] init];
        controller.modalDelegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        controller.dataDelegate = self.dataDelegate;
        controller.wordList = @[_word];

    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self setViewMovedUp:TRUE];
    textView.textColor = [UIColor colorWithRed:116.0/255.0 green:160.0/255.0 blue:246.0/255.0 alpha:1.0];
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    [[self dataDelegate] addMnemonic:textView.text ToWord:[_word valueForKey:@"chinese"]];
    [textView resignFirstResponder];
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)dismissKeyboard {
    [_mnemonic resignFirstResponder];
    CGRect rect = self.view.frame;
    if (rect.origin.y<0){
        [self setViewMovedUp:NO];
    }
}

-(void)delete{
    [[self dataDelegate] deleteWordFromBank:[_word valueForKey:@"chinese"]];
    [[self delegate] didDeleteWord:_word];
    [self didSelectDone:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WordHasBeenDeleted" object:_word];
}


@end
