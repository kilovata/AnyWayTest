//
//  DetailModel.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "DetailModel.h"
#import "Airline.h"
#import "Fare.h"

@implementation DetailModel


- (NSFetchRequest*)getRequestWithAirline:(Airline*)airline {
    
    return [Fare MR_requestAllSortedBy:@"totalAmount" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"airline == %@", airline]];
}

@end
