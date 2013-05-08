//
//  WordBankViewController.m
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/1/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "WordBankViewController.h"
#import "MGScrollView.h"
#import "CharacterGridBox.h"
#import "CharacterInfoViewController.h"
#import "FlatButton.h"
#import "REMenu.h"


@implementation WordBankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getWords:self];
    
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    [self.view addSubview:scroller];
    [scroller setDelegate:self];
    
    MGBox *grid = [MGBox boxWithSize:self.view.bounds.size];
    grid.contentLayoutMode = MGLayoutGridStyle;
    [scroller.boxes addObject:grid];
    
    
    for (id word in _wordList){
        NSString *hanzi = [word valueForKey:@"chinese"];
        NSArray *wordArray = @[[word valueForKey:@"chinese"], [word valueForKey:@"pinyin"], [word valueForKey:@"english"]];
        CharacterGridBox *wordTile = [[CharacterGridBox alloc]initWithFrame: CGRectMake(0, 0, 53.3*ceil((double)hanzi.length/2), 44)AndCharacter:hanzi];
        [[grid boxes] addObject:wordTile];
        
        wordTile.onTap = ^{
            CharacterInfoViewController *viewController = [[CharacterInfoViewController alloc]init];
            [viewController setWord:wordArray];
            viewController.modalDelegate = self;
            viewController.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:viewController animated:YES completion:NULL];
            
        };
        
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

- (void)didDismissPresentedViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
