//
//  abandon_draft_threeTests.m
//  abandon_draft_threeTests
//
//  Created by Gwendolyn Weston on 5/4/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "abandon_draft_threeTests.h"
#import "AppDelegate.h"
#import "CoreDataTestHelper.h"

/*
 //getting entries for coredata
 -(NSArray *)printDataForEntitiesOfType: (NSString *)entityName;
 -(BOOL)WordIsAlreadyInDatabase:(NSString *)word;
 -(NSArray *)getAllWords;
 -(NSArray *)getAllUnrecordedWordsinQueue;
 
 //setting/changing entries from coredata
 -(NSArray *)addToDatabaseDictEntryOfWord: (NSString *)word;
 -(void)deleteWordFromQueue:(NSString*)Word;
 -(void)storeAAC:(NSString *)URL ForWord:(NSString *)Word InLanguage:(NSString *)Language;
*/

@implementation abandon_draft_threeTests{
    AppDelegate *test_subject;
    CoreDataTestHelper *test_helper;
}

- (void)setUp
{
    
    [MagicalRecord setDefaultModelFromClass:[self class]];
	[MagicalRecord setupCoreDataStack];

    [super setUp];
    
    test_subject = [[AppDelegate alloc] init];
    test_helper = [[CoreDataTestHelper alloc]init];
    STAssertNotNil(test_subject, @"Could not create test subject.");
}

- (void)tearDown
{
    [MagicalRecord cleanUp];
    [super tearDown];
}

- (void)testGettingAndSetting
{
    [test_helper deleteALLtheData];
    
    //test adding words to database
    //see if chinese characters that should be in dictionary return result
    NSArray *wordList = @[@"計較", @"解決", @"迷惘", @"好像", @"牆壁"];
    for (NSString *word in wordList){
        NSAssert([test_subject addToDatabaseDictEntryOfWord:word], @"array should not have returned nil for word: %@", word);
       
    }
    
    //test that adding repeat words doesn't happen
    for (NSString *word in wordList){
        NSAssert(![test_subject addToDatabaseDictEntryOfWord:word], @"array should have returned nil for word because of repeat: %@", word);
        
    }
    
    //see if non-valid inputs return false
    NSArray *badInput = @[@"hi", @"dog", @"';lqiw", @"12832", @"<>?"];
    for (NSString *word in badInput){
        NSAssert(![test_subject addToDatabaseDictEntryOfWord:word], @"array should not have returned a result for word: %@", word);
        
    }
    
    //see if list of input words are the same as list of words in database
    NSArray *resultWordList = [test_subject getAllWords];
    for(NSString *word in wordList){
        NSAssert([[resultWordList valueForKey:@"chinese"] containsObject:word], @"word %@ should have been added to the database", word);
    }
    
    //see if list of input words are the same as list of words in queue
    NSArray *resultQueueWordList = [test_subject getAllUnrecordedWordsinQueue];
    for(NSString *word in wordList){
        NSAssert([[resultQueueWordList valueForKey:@"chinese"] containsObject:word], @"word %@ should have been added to the queue", word);
    }
    
    [test_helper printDataForEntitiesOfType:@"Queue"];

    //see if deleting words from queue works
    [test_subject deleteWordFromQueue:@"計較"];
    [test_subject deleteWordFromQueue:@"解決"];
    NSMutableArray *wordListAfterDeletion = [wordList mutableCopy];
    [wordListAfterDeletion removeObject:@"計較"];
    [wordListAfterDeletion removeObject:@"解決"];

    NSArray *resultQueueWordListAfterDeletion = [test_subject getAllUnrecordedWordsinQueue];
    for(NSString *word in resultQueueWordListAfterDeletion){
        NSAssert([wordListAfterDeletion containsObject:[word valueForKey:@"chinese"]], @"word %@ should have been deleted from the queue", word);
    }
    
    [test_helper printDataForEntitiesOfType:@"Queue"];
    [test_helper deleteALLtheData];

}

@end
