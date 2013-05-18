//
//  recordViewController.m
//  abandonDraft
//
//  Created by Gwendolyn Weston on 1/20/13.
//  Copyright (c) 2013 Coefficient Zero. All rights reserved.
//
// lot of this code for recording was taken from stackoverflow:http://stackoverflow.com/questions/1010343/how-do-i-record-audio-on-iphone-with-avaudiorecorder/1011273#1011273
// also some from this repo on  github: https://github.com/rpplusplus/iOSMp3Recorder

//NOTE, WORDLIST IS NOT SET WITH THIS. VIEW CONTROLLER CALLING THIS MUST SET WORDLIST.
#import "recordViewController.h"
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    [session setActive:YES error:nil];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else{
        [session setActive:YES error:nil];
    }
    [self setTimesPressed:0];
    [self setCurrentIndex:0];
        
    if ([_wordList count]<1){
        [[[UIAlertView alloc]
          initWithTitle:@"No words"
          message:@"Heya.  Doesn't seem like you have any words to record."
          delegate:self
          cancelButtonTitle:@"Ok"
          otherButtonTitles: nil] show];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];

    
}


- (void)viewDidUnload {
}

- (IBAction)Record:(id)sender{
    NSURL *url;
    NSString *URLString;
    
    if (_currentIndex<[_wordList count]){        
        NSString *hanzi = [[_wordList objectAtIndex:_currentIndex] valueForKey:@"chinese"];
        NSString *pinyin = [[_wordList objectAtIndex:_currentIndex] valueForKey:@"pinyin"];
        NSString *english = [[_wordList objectAtIndex:_currentIndex] valueForKey:@"english"];
        
        switch (_timesPressed) {
            case 0:
                URLString = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:[NSString stringWithFormat:@"%@.aac", hanzi]];
                url = [NSURL fileURLWithPath:URLString];
                [self storeAAC: URLString ForWord:hanzi InLanguage:@"Chinese"];
                                
                [self initRecorderWithUrl:url];
                [_recorder stop];  //stop recording the word from previous index
                [_recorder record];
                _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                         target:self
                                                       selector:@selector(timerUpdate)
                                                       userInfo:nil
                                                        repeats:YES];
                [_English setFont:[UIFont fontWithName:@"Gill Sans" size:16]];
                [_Chinese setFont:[UIFont fontWithName:@"Gill Sans" size:22]];
                [_Chinese setText:[NSString stringWithFormat:@"%@\n%@",hanzi, pinyin]];
                [_English setText:english];
                _timesPressed++;
                [_recordBtn setTitle:@"Chinese" forState:UIControlStateNormal];
                break;
            case 1:
                URLString = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:[NSString stringWithFormat:@"%@(eng).aac", hanzi]];
                url = [NSURL fileURLWithPath:URLString];
                [self storeAAC: URLString ForWord:hanzi InLanguage:@"English"];
                                
                [self initRecorderWithUrl:url];
                [_recorder stop];  //stop recording the word from previous index
                [_recorder record];
                _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                         target:self
                                                       selector:@selector(timerUpdate)
                                                       userInfo:nil
                                                        repeats:YES];
                [_Chinese setFont:[UIFont fontWithName:@"Gill Sans" size:16]];
                [_English setFont:[UIFont fontWithName:@"Gill Sans" size:22]];
                _timesPressed=0;
                _currentIndex++;
                [_recordBtn setTitle:@"English" forState:UIControlStateNormal];
                [self deleteWordFromQueue:hanzi];
                break;
            default:
                break;
        }
    }
    
    else{
        [_recorder stop];
        [_Chinese setText:@"all done!"];
        [_English setText:@"all done!"];
        [_recordBtn setTitle:@"all done!" forState:UIControlStateNormal];
        [[self navigationController] popViewControllerAnimated:YES];
        
    }
}

-(void)initRecorderWithUrl:(NSURL *)url{
    NSDictionary *recordSetting =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
     [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
     [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
     [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
     nil];
    
    NSError *err = nil;
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    [_recorder setDelegate:self];
    [_recorder prepareToRecord];
}


- (void) timerUpdate
{
    
    int m = _recorder.currentTime / 60;
    int s = ((int) _recorder.currentTime) % 60;
    
    _duration.text = [NSString stringWithFormat:@"%.2d:%.2d", m, s];
}

-(void)deleteWordFromQueue:(NSString *)Word{
    [[self dataDelegate] deleteWordFromQueue:Word];
}

-(void)storeAAC:(NSString *)URLString
        ForWord:(NSString *)Word
     InLanguage:(NSString *)Language{
    [[self dataDelegate] storeAAC:URLString ForWord:Word InLanguage:Language];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)didSelectDone:(id)sender {
    [self.modalDelegate didDismissPresentedViewController];
}

@end