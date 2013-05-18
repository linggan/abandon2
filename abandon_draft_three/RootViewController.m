//
//  RootViewController.m
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/1/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "RootViewController.h"
#import "FlatButton.h"
#import "NewCharacterScreenViewController.h"
#import "NavigationViewController.h"


#define kOFFSET_FOR_KEYBOARD 90.0


@interface RootViewController ()

@end

@implementation RootViewController{
    UIScrollView *scrollView;
    UIImageView *imageView;
}


- (void)viewDidLoad
{
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    [[self view]addSubview:imageView];
    
    [super viewDidLoad];
    
    UIButton *goToWordBankBtn = [FlatButton FlatButtonWithFrame:CGRectMake(35, 336, 100, 40) WithText:@"about" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.58]];
    UIButton *goToAboutPageBtn = [FlatButton FlatButtonWithFrame:CGRectMake(175, 336, 120, 40) WithText:@"word bank" andBackgroundColor:[UIColor colorWithRed:(float)136/255 green:(float)184/255 blue:(float)184/255 alpha:0.58]];
    
    [[self view] addSubview:goToWordBankBtn];
    [goToWordBankBtn addTarget:self action:@selector(goToWordBank) forControlEvents:UIControlEventTouchDown];
    
    [[self view] addSubview:goToAboutPageBtn];
    [goToAboutPageBtn addTarget:self action:@selector(goToAboutPage) forControlEvents:UIControlEventTouchDown];
    
    [_WordInputField setDelegate: self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[self view] sendSubviewToBack:imageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToWordBank{
    [self callNewScreen:@"word_bank"];
}

-(void)goToAboutPage{
    [self callNewScreen:@"about_page"];
}

-(void) callNewScreen: (NSString *)screenName{
    [[self delegate] callNewScreen:screenName];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NavigationViewController *navigationController = (NavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}


- (void)attemptToAddInputToDatabase:(NSString *)word{    
    //first check that the input is not empty
    if([word isEqualToString:@""]){
        [[[UIAlertView alloc]
          initWithTitle:@"Hmm."
          message:@"It doesn't look like you entered anything"
          delegate:self
          cancelButtonTitle:@"Ok"
          otherButtonTitles: nil] show];
    }
    
    //check that the word isn't already already in the database
    else if ([[self dataDelegate] WordIsAlreadyInDatabase: word]){
        [[[UIAlertView alloc]
          initWithTitle:@"Whoo!"
          message:@"That word is already in the database!"
          delegate:self
          cancelButtonTitle:@"Nice."
          otherButtonTitles: nil] show];
    }
    
    //and then see if the dictionary contains an entry for this word
    else{
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(160, 260);
        spinner.color = [UIColor colorWithRed:(float)255/255 green:(float)101/255 blue:(float)136/255 alpha:1];

        __block NSArray *entryFound;
        
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        
        dispatch_queue_t searchQueue = dispatch_queue_create("search", NULL);
        dispatch_async(searchQueue, ^{
            
            entryFound = [[self dataDelegate] addToDatabaseDictEntryOfWord:word];
            [NSThread sleepForTimeInterval:0.03];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                if([entryFound count] != 0){
                    NewCharacterScreenViewController *viewController = [[NewCharacterScreenViewController alloc]init];
                    
                    [viewController setModalDelegate:self];
                    [viewController setWord:entryFound];
                    viewController.modalPresentationStyle = UIModalPresentationPageSheet;
                    [self presentViewController:viewController animated:YES completion:NULL];
                }
                
                [_WordInputField setText:@""];
                
                if (!entryFound){
                    [[[UIAlertView alloc]
                      initWithTitle:@"Nothing. Dang."
                      message:@"Sorry. Looks like our dictionary doesn't have that word."
                      delegate:self
                      cancelButtonTitle:@"Forgive us?"
                      otherButtonTitles: nil] show];
                }
                });
            
            });
        
        
        
        
    }
    [self dismissKeyboard];

    
}

#pragma mark - methods to move keyboard when inputting characters

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setViewMovedUp:YES];
}


// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self attemptToAddInputToDatabase:[textField text]];

    return YES;
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
    [_WordInputField resignFirstResponder];
    CGRect rect = self.view.frame;
    if (rect.origin.y<0){
        [self setViewMovedUp:NO];
    }
}

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
