//
//  MainCell.m
//  AnyWayTest
//
//  Created by Sveta Kilovata on 16/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell


- (void)awakeFromNib {

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}


- (IBAction)actionStep:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatePeopleCount:)]) {
        [self.delegate updatePeopleCount:(NSInteger)self.stepper.value];
    }
}


@end
