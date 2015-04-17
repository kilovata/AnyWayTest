//
//  CalendarViewController.h
//  AnyWayTest
//
//  Created by kilovata-iMac on 17/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarViewControllerDelegate <NSObject>

- (void)getDateFomCalendar:(NSDate*)date;

@end

@interface CalendarViewController : UIViewController

@property (weak, nonatomic) id <CalendarViewControllerDelegate> delegate;

@end
