//
//  DetailViewController.h
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Airline;

@interface DetailViewController : UIViewController

- (id)initWithAirline:(Airline*)airline andTitle:(NSString*)strTitle;

@end
