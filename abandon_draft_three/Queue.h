//
//  Queue.h
//  abandon_draft_three
//
//  Created by Gwendolyn Weston on 5/4/13.
//  Copyright (c) 2013 Gwendolyn Weston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Queue : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *notRecored;

@end
