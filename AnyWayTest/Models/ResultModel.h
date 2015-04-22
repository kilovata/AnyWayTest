//
//  ResultModel.h
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData+MagicalRecord.h>

@class Fare, Airline;

@interface ResultModel : NSObject

- (NSFetchRequest*)getRequestAirlines;
- (Fare*)getMinFareAmountForAirline:(Airline*)airline;
- (void)truncateAll;
- (NSString*)getNameAirlaneByCode:(NSString*)strCode;

@end
