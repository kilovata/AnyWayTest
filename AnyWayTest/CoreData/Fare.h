//
//  Fare.h
//  
//
//  Created by kilovata-iMac on 22/04/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Airline;

@interface Fare : NSManagedObject

@property (nonatomic, retain) NSString * fareId;
@property (nonatomic, retain) NSNumber * totalAmount;
@property (nonatomic, retain) Airline *airline;

@end
