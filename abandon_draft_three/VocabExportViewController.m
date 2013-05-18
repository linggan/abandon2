//
//  ReviewGridViewController.m
//  abandonDraft
//
//  Created by Gwendolyn Weston on 4/26/13.
//  Copyright (c) 2013 Coefficient Zero. All rights reserved.
//

#import "MGScrollView.h"
#import "CharacterGridBox.h"
#import "VocabExportViewController.h"
#import "FlatButton.h"
#import <AVFoundation/AVFoundation.h>

@implementation VocabExportViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getWords:self];
    [self setVocabList:[[NSMutableArray alloc] init]];
    
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    [self.view addSubview:scroller];
    [scroller setDelegate:self];
    
    MGBox *grid = [MGBox boxWithSize:self.view.bounds.size];
    grid.contentLayoutMode = MGLayoutGridStyle;
    [scroller.boxes addObject:grid];
    
    
    FlatButton *FinishSelection = [FlatButton FlatButtonWithFrame:CGRectMake(0, 0, 320, 44) WithText:@"record new words" andBackgroundColor:[UIColor colorWithRed:(float)255/255 green:(float)101/255 blue:(float)136/255 alpha:1]];
    [FinishSelection setTitle:@"finish selection" forState:UIControlStateNormal];
    [FinishSelection addTarget:self action:@selector(didSelectDone) forControlEvents:UIControlEventTouchDown];
    CharacterGridBox *buttonBox02 = [[CharacterGridBox alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [buttonBox02 addSubview:FinishSelection];
    [[grid boxes] addObject:buttonBox02];
    
    
    for (id word in _wordList){
        NSString *hanzi = [word valueForKey:@"chinese"];
        
        if([word valueForKey:@"englishRecording"] != nil){
            CharacterGridBox *wordTile = [[CharacterGridBox alloc]initWithFrame: CGRectMake(0, 0, 53.3*ceil((double)hanzi.length/2), 44)AndCharacter:hanzi];
            [[grid boxes] addObject:wordTile];
            
            wordTile.onTap = ^{
                if (!wordTile.selected){
                    [wordTile setSelected:TRUE];
                    [[wordTile characterBoxText] setTextColor:[UIColor grayColor]];
                    [[self vocabList] addObject:word];
                }
                else{
                    [wordTile setSelected:FALSE];
                    [[wordTile characterBoxText] setTextColor:[UIColor whiteColor]];
                    [[self vocabList] removeObject:word];
                }
            };
        }
    }
    
    [grid layoutWithSpeed:0.3 completion:nil];
    [scroller layoutWithSpeed:0.3 completion:nil];
    [scroller scrollToView:grid withMargin:10];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];

}

-(void)getWords:(id)ViewController{
    _wordList = [[self dataDelegate] getAllWords];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [(id)scrollView snapToNearestBox];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [(id)scrollView snapToNearestBox];
    }
}

- (void)didSelectCancel
{
    [self.modalDelegate didDismissPresentedViewController];
}

- (void)didSelectDone
{
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    NSString *output = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:[NSString stringWithFormat:@"%@.m4a", _vocabListName]];
    CMTime currentTrackTime = kCMTimeZero;
    
    for (id word in _vocabList){        
        AVURLAsset *chineseTrack = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[word valueForKey:@"chineseRecording"]] options:nil];
        AVURLAsset *englishTrack = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[word valueForKey:@"englishRecording"]] options:nil];
        
        AVMutableCompositionTrack *compositionTrack01 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionTrack01 insertTimeRange:CMTimeRangeMake(kCMTimeZero, chineseTrack.duration) ofTrack:[[chineseTrack tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:currentTrackTime error:nil];
        AVMutableCompositionTrack *compositionTrack02 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionTrack02 insertTimeRange:CMTimeRangeMake(kCMTimeZero, englishTrack.duration) ofTrack:[[englishTrack tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:CMTimeAdd(currentTrackTime, chineseTrack.duration) error:nil];
        
        currentTrackTime = CMTimeAdd(CMTimeAdd(chineseTrack.duration, englishTrack.duration), currentTrackTime);
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    exporter.outputURL = [NSURL fileURLWithPath:output];
    exporter.outputFileType = AVFileTypeAppleM4A;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        // Export Finished
        NSLog(@"successfully export to folder: %@", output);
    }];
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Exported!" message:@"You can find your new vocab list under the App tab in iTunes." delegate:self cancelButtonTitle:@"Aw yeahh" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeAlphabet;
    [alert show];
    
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
