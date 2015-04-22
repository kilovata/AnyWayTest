//
//  CityModel.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 17/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "CityModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation CityModel


- (void)getCitiesWithText:(NSString*)strText {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary *parameters = @{@"language" : @"RU", @"filter" : strText, @"_Serialize" : @"JSON"};
    [manager GET:@"https://www.anywayanyday.com/AirportNames/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(citiesGetReceived:)]) {
            [self.delegate citiesGetReceived:[responseObject objectForKey:@"Array"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(citiesError:)]) {
            [self.delegate citiesError:error];
        }
    }];
}


@end
