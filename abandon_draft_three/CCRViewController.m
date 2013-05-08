//
//  CCRViewController.m
//  Memory
//
//  Created by Carl G Cota-Robles on 4/13/13.
//  Copyright (c) 2013 Carl G Cota-Robles. All rights reserved.
//

#import "CCRViewController.h"

@interface CCRViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@end

@implementation CCRViewController
{
    SystemSoundID winSoundID;
}

@synthesize wordList;

#define WON 0
#define LOST 1

//WE CAN PLAY AROUND WITH THESE TO CHANGE THE AMOUNT OF TIME ANIMATIONS TAKE:
#define TIMEVISIBLE_FIRSTCARD 1
#define MATCHTIME .5
#define DELAY .03
#define TIMERSTARTINGVALUE 300

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToLooking:) name:@"CardFlippedUp" object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
        
    UINib *cellNib = [UINib nibWithNibName:@"MemoryCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MemoryCell"];
        
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(countDown)
                                                    userInfo:nil
                                                     repeats:YES];
    
    self.matchingLabel.backgroundColor = [UIColor clearColor];
    self.inProgress = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];


}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

    self.stopTimer = NO; //If we want to pause the Clock, set this to YES.
    
    if (!self.inProgress)
    {
        [self reloadEverything];
    }
}

-(void)reloadEverything
{
    self.totalMatched = 0; //When this hits 16 (or however many cards we're displaying, it ends the game.
    
    srandom(time(NULL));
    
    [self getWords:self];
    if (wordList.count>8) {
        wordList = [NSMutableArray arrayWithObjects:wordList[0], wordList[1], wordList[2], wordList[3], wordList[4], wordList[5], wordList[6], wordList[7], nil];
    }
    
    //self.wordList = [NSArray arrayWithObjects:self.wordList[2], self.wordList[3], nil];
    
    //Smaller arrays that store each of the cards we will use.
    self.allBlueCards = [NSMutableArray arrayWithArray:self.wordList];
    self.allRedCards = [NSMutableArray arrayWithArray:self.wordList];
    
    self.counter = TIMERSTARTINGVALUE; //Initializes the Countdown Clock
    
    [self.collectionView reloadData];
    self.inProgress = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.audioPlayer stop];
    self.stopTimer = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)getWords:(id)ViewController{
    wordList = [[self dataDelegate] getAllWords];
}

-(void)playSound:(NSString*)sound
{
    if (sound == @"Slide")
    {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/SlideCard2.wav", [[NSBundle mainBundle] resourcePath]]];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [self.audioPlayer play];
    }
    else if (sound == @"Applause")
    {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Applause.wav", [[NSBundle mainBundle] resourcePath]]];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [self.audioPlayer play];
    }
}

-(void)enableUserInteraction //used to we can call this with the perform selector method
{
    self.view.userInteractionEnabled = YES;
}

-(void)eraseMatchingLabel //erases matching label after a certain period of time.
{
    self.matchingLabel.text = @"";
    self.matchingLabel.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    [self playSound:@"Slide"];
}

-(void)countDown //Counts down the clock
{
    if ((self.counter != 0) && !self.stopTimer)
    {
        self.counter--;
        NSString *counterText = [[NSString alloc] initWithFormat:@"%i", self.counter];
        self.timeDisplay.text = counterText;
    }
    else if (self.counter == 0) {
        if (!self.stopTimer) {
            [self exitWithFailure];
        }
        self.stopTimer = YES;
    }
}

-(void)exitWithFailure {  //exits the game if you lose.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Dog-gone it!"
                          message: @"You obviously need some more purrr-actice!"
                          delegate: self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    alert.tag = LOST;
    [alert show];
}

-(void)exitWithWinning { //exits the game if you win.
    [self playSound:@"Applause"];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Cat tastic!!"
                          message: @"Go fetch some new words!"
                          delegate: self
                          cancelButtonTitle: @"OK"
                          otherButtonTitles:nil];
    alert.tag = WON;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == WON)
    {
        self.inProgress = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if (alertView.tag == LOST)
    {
        self.inProgress = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)respondToLooking:(NSNotification *)notification {
    //This method either stores the cell that is flipped over, if it's the first cell flipped over, or if it's the second, it compares
    //it to the previous cell that was flipped and if it's a match, leaves the cells flipped over, if not, flips both cells back to the
    //original position.
    
    CCRMemoryCardCell *cellProvided = [notification object];
    
    NSObject *cellClassProvided = [cellProvided getStoredClass];
    
    if (self.prevCell == nil)
    {
        self.cellClassLookingFor = cellClassProvided;
        self.prevCell = cellProvided;
        return;
    }
    else if (self.cellClassLookingFor == cellClassProvided)
    {
        [self.prevCell performSelector:@selector(getRidOfCell) withObject:self.prevCell afterDelay:MATCHTIME];
        [cellProvided performSelector:@selector(getRidOfCell) withObject:cellProvided afterDelay:MATCHTIME];
        
        self.prevCell = nil;
        self.totalMatched += 2;
                
        //This all pertains to the matching label, displaying it and then removing it.
        self.matchingLabel.text = @"Match!";
        self.matchingLabel.backgroundColor = [UIColor whiteColor];
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(eraseMatchingLabel)withObject:self afterDelay:MATCHTIME];
        
        //Test to see if we've won
        if (self.totalMatched == self.wordList.count*2) {
            self.stopTimer = YES;
            [self performSelector:@selector(exitWithWinning)withObject:self afterDelay:MATCHTIME+DELAY];
        }
        return;
    }
    else if (self.cellClassLookingFor != cellClassProvided)
    {
        self.view.userInteractionEnabled = NO;
        
        [self.prevCell performSelector:@selector(flipDown)withObject:self.prevCell afterDelay:TIMEVISIBLE_FIRSTCARD];
        [cellProvided performSelector:@selector(flipDown)withObject:cellProvided afterDelay:TIMEVISIBLE_FIRSTCARD+DELAY];
        
        [self performSelector:@selector(enableUserInteraction)withObject:self afterDelay:TIMEVISIBLE_FIRSTCARD+DELAY];
        
        self.prevCell = nil;
        return;
    }
    else {
        NSLog(@"Impossible Situation!");
        return;
    }
}

#pragma mark - UICollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.wordList.count*2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//THIS CODE SETS UP THE CELL AND MODIFIES IMAGES, VARIABLES, ETC IN THE CELL
-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCRMemoryCardCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MemoryCell" forIndexPath:indexPath];
    
    cell.frontOfCard = [UIImage imageNamed:@"Yellowcard.png"];
    
    if (self.allBlueCards.count > 0)
    { //Creates all the blue cards first.
        cell.backOfCard = [UIImage imageNamed:@"BlueCard"];
        NSInteger squareToMatchAt = random() % (self.allBlueCards.count);
        [cell setData:[self.allBlueCards objectAtIndex:squareToMatchAt] :0];
        [cell clearData];
        [self.allBlueCards removeObjectAtIndex:squareToMatchAt];
    }
    else if (self.allBlueCards.count <= 0)
    { //When all blue cards have been created, then creates the red cards.
        cell.backOfCard = [UIImage imageNamed:@"RedCard"];
        NSInteger squareToMatchAt = random() % (self.allRedCards.count);
        [cell setData:[self.allRedCards objectAtIndex:squareToMatchAt] :1];
        [cell clearData];
        [self.allRedCards removeObjectAtIndex:squareToMatchAt];
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Not Implemented right now
    NSInteger cellNumber = indexPath.item;
    NSLog(@"Selected Cell #%i", cellNumber);
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Not implemented right now
    NSInteger cellNumber = indexPath.item;
    NSLog(@"De-selected Cell #%i", cellNumber);
    
}

#pragma mark - UICollectionViewFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger totalCards = [self collectionView:collectionView numberOfItemsInSection:0];
    
    //Code that adjusts the screen based on the number of cards to make it look pretty
    NSInteger width = 110;
    if (totalCards > 5)
    {
        width = 70;
    }
    if (totalCards > 9)
    {
        width = 50;
    }
    //----------------------------
    
    
    NSInteger height = width * 3/2;
    
    CGSize retval = CGSizeMake(width, height);
    return retval;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end