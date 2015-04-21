//
//  FindTicketsModel.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 21/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "FindTicketsModel.h"
#import <AFNetworking/AFNetworking.h>

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
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateStatusPercentageComplete)]) {
                    [self.delegate updateStatusPercentageComplete];
                }
            }
        } else {
            [self.timer invalidate];
        }
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(findTicketsError:)]) {
            [self.delegate findTicketsError:error];
        }
    }];
}


- (void)requestGetResult {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary *parameters = @{@"R" : self.strIdSynonym, @"L" : @"RU", @"C" : @"RUB", @"DebugFullNames" : @"true", @"_Serialize" : @"JSON"};
    [manager GET:@"https://www.anywayanyday.com/api2/Fares2/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(findTicketsError:)]) {
            [self.delegate findTicketsError:error];
        }
    }];
}


@end
