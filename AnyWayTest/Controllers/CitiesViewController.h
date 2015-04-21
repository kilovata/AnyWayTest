//
//  CitiesViewController.h
//  AnyWayTest
//
//  Created by Sveta Kilovata on 17/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CitiesViewControllerDelegate <NSObject>

- (void)returnCity:(NSString*)strCity andCountry:(NSString*)strCountry andArrive:(BOOL)isArrive andCityCode:(NSString*)strCityCode;

@end

@interface CitiesViewController : UIViewController

@property (weak, nonatomic) id <CitiesViewControllerDelegate> delegate;

- (id)initWithArrive:(BOOL)isArriveValue;

@end
