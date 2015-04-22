//
//  DetailModel.h
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData+MagicalRecord.h>

@class Airline;

@interface DetailModel : NSObject

- (NSFetchRequest*)getRequestWithAirline:(Airline*)airline;

@end
