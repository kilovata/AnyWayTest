//
//  ResultModel.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "ResultModel.h"
#import "Fare.h"
#import "Airline.h"
#import "AirlineFull.h"

@implementation ResultModel


- (NSFetchRequest*)getRequestAirlines {
    
    NSFetchRequest *request = [Airline MR_requestAllSortedBy:@"code" ascending:YES];
    request.returnsDistinctResults = YES;
    return request;
}


- (Fare*)getMinFareAmountForAirline:(Airline*)airline {
    
    return [Fare MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"airline == %@", airline] sortedBy:@"totalAmount" ascending:YES];
}


- (NSString*)getNameAirlaneByCode:(NSString*)strCode {
    
    AirlineFull *airlineFull = [AirlineFull MR_findFirstByAttribute:@"code" withValue:strCode];
    return airlineFull.name;
}


- (void)truncateAll {
    
    [Fare MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


@end
