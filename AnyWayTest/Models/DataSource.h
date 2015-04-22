//
//  DataSource.h
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData+MagicalRecord.h>

@interface DataSource : NSObject

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)setupFetchResultsControllerWithRequest:(NSFetchRequest*)request;

@end
