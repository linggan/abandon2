//
//  DecompEntry.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/14/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DecompEntry : NSManagedObject

@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) NSString * decomp;

@end
