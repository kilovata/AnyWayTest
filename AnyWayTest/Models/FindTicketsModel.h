//
//  FindTicketsModel.h
//  AnyWayTest
//
//  Created by kilovata-iMac on 21/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FindTicketsModelDelegate <NSObject>

- (void)updateStatusPercentage:(NSNumber*)numPercentage;
- (void)updateStatusPercentageComplete;
- (void)findTicketsError:(NSError*)error;
- (void)resultsDidReceived;

@end

@interface FindTicketsModel : NSObject

@property (nonatomic, weak) id<FindTicketsModelDelegate> delegate;

- (void)getTicketsWithDate:(NSString*)strDate andDeparture:(NSString*)strDeparture andArrival:(NSString*)strArrival andNumberPassengers:(NSNumber*)numPassengers andClass:(NSString*)strClass;
- (void)requestGetResult;
- (void)truncateAll;
- (void)getAirlinesFullName;

@end
