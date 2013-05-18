//
//  Word.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/4/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * chinese;
@property (nonatomic, retain) NSString * chineseRecording;
@property (nonatomic, retain) NSString * english;
@property (nonatomic, retain) NSString * englishRecording;
@property (nonatomic, retain) NSString * pinyin;

@end
