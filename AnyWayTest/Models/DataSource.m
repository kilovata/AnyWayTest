//
//  DataSource.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "DataSource.h"

@interface DataSource()<NSFetchedResultsControllerDelegate>

@end


@implementation DataSource


- (void)setupFetchResultsControllerWithRequest:(NSFetchRequest*)request {
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    if (!self.fetchedResultsController.delegate) {
        self.fetchedResultsController.delegate = self;
    }
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


@end
