//
//  MainCell.h
//  AnyWayTest
//
//  Created by Sveta Kilovata on 16/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainCellDelegate <NSObject>

- (void)updatePeopleCount:(NSInteger)peopleCount;

@end

@interface MainCell : UITableViewCell

@property (weak, nonatomic) id <MainCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPassengers;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

- (IBAction)actionStep:(id)sender;

@end
