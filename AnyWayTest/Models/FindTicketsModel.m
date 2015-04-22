//
//  FindTicketsModel.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 21/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "FindTicketsModel.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreData+MagicalRecord.h>
#import "Airline.h"
#import "Fare.h"
#import "AirlineFull.h"

@interface FindTicketsModel()

@property (nonatomic, strong) NSString *strIdSynonym;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FindTicketsModel


- (void)getTicketsWithDate:(NSString*)strDate andDeparture:(NSString*)strDeparture andArrival:(NSString*)strArrival andNumberPassengers:(NSNumber*)numPassengers andClass:(NSString*)strClass {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *strFull = [NSString stringWithFormat:@"%@%@%@AD%@CN0IN0SC%@", strDate, strDeparture, strArrival, numPassengers, strClass];
    NSDictionary *parameters = @{@"Route" : strFull, @"_Serialize" : @"JSON"};
    [manager GET:@"https://www.anywayanyday.com/api2/NewRequest2/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:@"Error"] isEqual:[NSNull null]]) {
            self.strIdSynonym = [responseObject objectForKey:@"IdSynonym"];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(requestFindTickets) userInfo:nil repeats:YES];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(findTicketsError:)]) {
            [self.delegate findTicketsError:error];
        }
    }];
}


- (void)requestFindTickets {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary *parameters = @{@"R" : self.strIdSynonym, @"_Serialize" : @"JSON"};
    [manager GET:@"https://www.anywayanyday.com/api2/RequestState/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:@"Error"] isEqual:[NSNull null]]) {
            NSNumber *numPercentage = [NSNumber numberWithInteger:[[responseObject objectForKey:@"Completed"] integerValue]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateStatusPercentage:)]) {
                [self.delegate updateStatusPercentage:numPercentage];
            }
            if ([numPercentage isEqualToNumber:@100]) {
                [self.timer invalidate];
                [self performSelector:@selector(delayCall) withObject:nil afterDelay:0.5f];
            }
        } else {
            [self.timer invalidate];
            if (self.delegate && [self.delegate respondsToSelector:@selector(findTicketsError:)]) {
                [self.delegate findTicketsError:nil];
            }
        }
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(findTicketsError:)]) {
            [self.delegate findTicketsError:error];
        }
    }];
}


- (void)delayCall {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateStatusPercentageComplete)]) {
        [self.delegate updateStatusPercentageComplete];
    }
}


- (void)requestGetResult {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary *parameters = @{@"R" : self.strIdSynonym, @"L" : @"RU", @"C" : @"RUB", @"DebugFullNames" : @"true", @"_Serialize" : @"JSON"};
    [manager GET:@"https://www.anywayanyday.com/api2/Fares2/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self saveToCoreData:responseObject];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(resultsDidReceived)]) {
            [self.delegate resultsDidReceived];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(findTicketsError:)]) {
            [self.delegate findTicketsError:error];
        }
    }];
}


- (void)saveToCoreData:(id)responseObject {
    
    NSArray *arrayAirlines = [responseObject objectForKey:@"Airlines"];
    for (int i=0; i<arrayAirlines.count; i++) {
        Airline *airline = airline = [Airline MR_findFirstByAttribute:@"code" withValue:[arrayAirlines[i] objectForKey:@"Code"]];
        if (!airline) {
            airline = [Airline MR_createEntity];
            airline.code = [arrayAirlines[i] objectForKey:@"Code"];
        }
        NSArray *arrayFares = [arrayAirlines[i] objectForKey:@"Fares"];
        for (int j=0; j<arrayFares.count; j++) {
            NSDictionary *dictFare = arrayFares[j];
            if (dictFare) {
                Fare *fare = [Fare MR_findFirstByAttribute:@"fareId" withValue:[dictFare objectForKey:@"FareId"]];
                if (!fare) {
                    fare = [Fare MR_createEntity];
                    fare.fareId = [dictFare objectForKey:@"FareId"];
                    fare.totalAmount = [dictFare objectForKey:@"TotalAmount"];
                    [fare setAirline:airline];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
        }
    }
}


- (void)getAirlinesFullName {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:@"https://www.anywayanyday.com/Controller/UserFuncs/BackOffice/GetAirlines/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self saveFullNameAirlines:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
}


- (void)saveFullNameAirlines:(id)responseObject {
    
    NSArray *array = responseObject;
    for (int i=0; i<array.count; i++) {
        NSString *strCode = [array[i] objectForKey:@"Code"];
        AirlineFull *airLineFull = [AirlineFull MR_findFirstByAttribute:@"code" withValue:strCode];
        if (!airLineFull) {
            airLineFull = [AirlineFull MR_createEntity];
            airLineFull.code = [array[i] objectForKey:@"Code"];
            airLineFull.name = [array[i] objectForKey:@"Name"];
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


- (void)truncateAll {
    
    [Airline MR_truncateAll];
    [Fare MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


@end
