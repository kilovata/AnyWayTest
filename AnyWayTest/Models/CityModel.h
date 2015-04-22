//
//  CityModel.h
//  AnyWayTest
//
//  Created by kilovata-iMac on 17/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CityModelDelegate <NSObject>

- (void)citiesGetReceived:(NSArray*)array;
- (void)citiesError:(NSError*)error;
@end

@interface CityModel : NSObject

@property (nonatomic, weak) id<CityModelDelegate> delegate;

- (void)getCitiesWithText:(NSString*)strText;

@end
