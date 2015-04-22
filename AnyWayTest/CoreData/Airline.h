//
//  Airline.h
//  
//
//  Created by kilovata-iMac on 22/04/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fare;

@interface Airline : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSSet *fares;
@end

@interface Airline (CoreDataGeneratedAccessors)

- (void)addFaresObject:(Fare *)value;
- (void)removeFaresObject:(Fare *)value;
- (void)addFares:(NSSet *)values;
- (void)removeFares:(NSSet *)values;

@end
