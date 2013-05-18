//
//  CoreDataTestHelper.m
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/5/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import "CoreDataTestHelper.h"
#import "CoreData+MagicalRecord.h"
#import "Word.h"
#import "Queue.h"
#import "DictEntry.h"


@implementation CoreDataTestHelper

-(NSArray *)printDataForEntitiesOfType: (NSString *)entityName{
    NSArray *list;
    
    if ([entityName isEqualToString:@"Word"]){
        list = [Word MR_findAll];
        for (id word in list){
            NSLog(@"Word: %@, %@, %@, \n%@\n", [word valueForKey:@"chinese"], [word valueForKey:@"pinyin"], [word valueForKey:@"english"], [word valueForKey:@"chineseRecording"]);
        }
    }
    
    if ([entityName isEqualToString:@"Queue"]){
        Queue *queue = [Queue MR_findFirst];
        NSLog(@"Queue Found: %@", [queue valueForKey:@"name"]);
        NSSet *unrecordedWordSet = [queue valueForKey:@"notRecorded"];
        
        for (id word in unrecordedWordSet){
            NSLog(@"Word: %@, %@, %@", [word valueForKey:@"chinese"], [word valueForKey:@"pinyin"], [word valueForKey:@"english"]);
        }
        list = [unrecordedWordSet allObjects];
    }
    
    return list;
}

-(void)deleteALLtheData{
    [Word MR_truncateAll];
    [Queue MR_truncateAll];
}

@end
