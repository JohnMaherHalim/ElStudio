//
//  ShowImageTableViewCell.m
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "ShowImageTableViewCell.h"

@implementation ShowImageTableViewCell


@synthesize oneimg ;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)scale:(UIPinchGestureRecognizer*)pinch
{
	float scale = pinch.scale;
	oneimg.transform = CGAffineTransformScale(oneimg.transform, scale, scale);
	pinch.scale = 1;
}

-(IBAction)IncreaseCount:(id)sender {
    int countnum = [self.counter.text intValue]; ;
    countnum++ ;
    [self.counter setText:[NSString stringWithFormat:@"%d",countnum]];
    [self.delegate PlusOne:self.index];
    
}

-(IBAction)DecreaseCount:(id)sender {
    int countnum = [self.counter.text intValue]; ;
    if (countnum > 1){
        countnum-- ;
        [self.counter setText:[NSString stringWithFormat:@"%d",countnum]];
        [self.delegate MinusOne:self.index];
    }
}

@end
