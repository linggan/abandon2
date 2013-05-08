//
//  AppDelegate.m
//  abandon_draft_two
//
//  Created by Gwendolyn Weston on 5/1/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#define MR_SHORTHAND

#import "AppDelegate.h"
#import "RootViewController.h"
#import "AboutPageViewController.h"
#import "WordBankViewController.h"
#import "CoreData+MagicalRecord.h"
#import "NavigationViewController.h"

#import "Word.h"
#import "Queue.h"
#import "DictEntry.h"

@implementation AppDelegate{
    RootViewController *RootVC;
    AboutPageViewController *AboutPageVC;
    WordBankViewController *WordBankVC;
    NavigationViewController *NaviVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blueColor];
    [self.window makeKeyAndVisible];
    
    //setting up ALL the views!!!
    RootVC = [[RootViewController alloc]init];
    AboutPageVC = [[AboutPageViewController alloc] init];
    WordBankVC = [[WordBankViewController alloc] init];
    
    NaviVC = [[NavigationViewController alloc]initWithRootViewController:RootVC];
    [NaviVC setDataDelegate:self];
    
    [RootVC setDelegate:self];
    [RootVC setDataDelegate:self];
    
    [WordBankVC setDataDelegate:self];
        
    [_window setRootViewController:NaviVC];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"abandon_draft_three"];
        
    //if dict hasn't been parsed through, parse through it
    DictEntry *result = [DictEntry MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"traditional like[cd] %@", @"的"]];
    if (!result){
        [self parseDict];
    }
    return YES;

}

-(void)deleteData{
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    NSArray *words = [Word MR_findAll];
    
    for (id word in words){
        [context deleteObject:word];
    }
    
    [self saveContext];
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

-(void)saveContext{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
}

#pragma mark - Database Parsing

//parse the CC-CEDICT dictionary so that CoreData has all the entries in a much more manageable format
-(void)parseDict{
    NSString* dictionaryContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cedict_ts" ofType:@"u8"] encoding:NSUTF8StringEncoding error:NULL];
    
    NSMutableArray *dictionaryArray = [[dictionaryContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    
    //delete index 0 - 60, which is license information
    [dictionaryArray removeObjectsInRange:NSMakeRange(0, 60)];
    
    //delete indices that are only whitespace
    NSIndexSet *indexSet = [dictionaryArray indexesOfObjectsPassingTest:^(NSString *obj, NSUInteger idx, BOOL *stop){
        return [obj isEqualToString:@""];
    }];
    
    [dictionaryArray removeObjectsAtIndexes:indexSet];
    
    //go through every entry
    //sample entry: 你 你 [ni3] /you, yourself/
    //split by whitespace, trad is split_result[0], simplified is split_result[1]
    //[] is pinyin
    //first and last / is english definition
    
    for (int i = 0; i<[dictionaryArray count]; i++){
        NSString *currentEntry = dictionaryArray[i];
        NSArray *entrySplitByWhitespace = [currentEntry componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *trad = entrySplitByWhitespace[0];
        NSString *simp = entrySplitByWhitespace[1];
        
        NSRange bracketOne = [currentEntry rangeOfString:@"["];
        NSRange bracketTwo = [currentEntry rangeOfString:@"]"];
        
        NSRange slashOne = [currentEntry rangeOfString:@"/"];
        NSRange slashTwo = [currentEntry rangeOfString:@"/" options:NSBackwardsSearch];
        
        //the +1 and -1 are to trim the brackets and slashes from the resulting strings
        NSString *pinyin = [currentEntry substringWithRange:NSMakeRange(bracketOne.location+1, bracketTwo.location-bracketOne.location-1)];
        NSString *english = [currentEntry substringWithRange:NSMakeRange(slashOne.location+1, slashTwo.location-slashOne.location-1)];
        
        DictEntry *wordObject = [DictEntry MR_createEntity];
        [wordObject setValue: trad forKey:@"traditional"];
        [wordObject setValue: simp forKey:@"simplified"];
        [wordObject setValue: pinyin forKey:@"pinyin"];
        [wordObject setValue: english forKey:@"english"];
        
    }
    
    [self saveContext];
    
}

#pragma mark - Navigation Controller Methods


-(void) callNewScreen: (NSString *)screenName{
    if ([screenName isEqualToString:@"word_bank"]){
        [NaviVC pushViewController:AboutPageVC animated:TRUE];
    }
    if ([screenName isEqualToString:@"about_page"]){
        [NaviVC pushViewController:WordBankVC animated:TRUE];
    }
}

#pragma mark - Getting Word Entities From Database


-(BOOL)WordIsAlreadyInDatabase:(NSString *)word{
    NSManagedObject *alreadyInWordBank = [Word MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"chinese like[cd] %@", word]];
    
    return alreadyInWordBank? TRUE: FALSE;
}

-(NSArray *)getAllWords{
    return[Word MR_findAll];
}

-(NSArray *)getAllUnrecordedWordsinQueue{
    Queue *queue = [Queue MR_findFirst];
    NSSet *unrecordedWordSet = [queue valueForKey:@"notRecorded"];
    NSArray *list = [unrecordedWordSet allObjects];

    return list;
}

#pragma mark - Updating Word Entities From Database

-(NSArray *) addToDatabaseDictEntryOfWord: (NSString *)word{
    DictEntry *dictEntry = [DictEntry MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"traditional like[cd] %@", word]];
    Word *isRepeatEntry = [Word MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"chinese like[cd] %@", word]];
    NSArray *resultArray;
    
    //if word is not found or is in database already, return nil
    if (!dictEntry||isRepeatEntry){
        resultArray = nil;
        return nil;
    }
    
    // if result is found, make new Word Entity
    if ([[dictEntry valueForKey:@"traditional"] isEqualToString:word]){
        
        resultArray = @[[dictEntry valueForKey:@"traditional"], [dictEntry valueForKey:@"pinyin"], [dictEntry valueForKey:@"english"]];
        
        Word *wordObject = [Word MR_createEntity];
        [wordObject setValue:[dictEntry valueForKey:@"traditional"] forKey:@"chinese"];
        [wordObject setValue:[dictEntry valueForKey:@"pinyin"] forKey:@"pinyin"];
        [wordObject setValue:[dictEntry valueForKey:@"english"] forKey:@"english"];
        
        //if no queue, create queue
        Queue *queue= [Queue MR_findFirst];
        
        if (!queue){
            queue = [Queue MR_createEntity];
            [queue setValue:@"unrecorded" forKey:@"name"];
        }
        
        //add relationship
        NSMutableSet *newWords = [queue mutableSetValueForKey:@"notRecorded"];
        [newWords addObject:wordObject];
        
        [self saveContext];
    }
    
    return resultArray;
}


-(void)deleteWordFromQueue:(NSString*)word{
    Queue *queue = [Queue MR_findFirst];
    Word *wordObject = [Word MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"chinese like[cd] %@", word]];
    
    NSMutableSet *newWords = [queue mutableSetValueForKey:@"notRecorded"];
    [newWords removeObject:wordObject];
    
    [self saveContext];
}

-(void)storeAAC:(NSString *)URL ForWord:(NSString *)word InLanguage:(NSString *)Language{
    Word *wordObject = [Word MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"chinese like[cd] %@", word]];
    
    if ([Language isEqualToString:@"English"]){
        [wordObject setValue:URL forKey:@"englishRecording"];
    }
    if ([Language isEqualToString:@"Chinese"]){
        [wordObject setValue:URL forKey:@"chineseRecording"];
    }
    
    [self saveContext];
    
}

@end