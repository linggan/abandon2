//
//  VocabList.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/28/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface VocabList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * recordingURL;
@property (nonatomic, retain) NSSet *wordsInList;
@end

@interface VocabList (CoreDataGeneratedAccessors)

- (void)addWordsInListObject:(Word *)value;
- (void)removeWordsInListObject:(Word *)value;
- (void)addWordsInList:(NSSet *)values;
- (void)removeWordsInList:(NSSet *)values;

@end
