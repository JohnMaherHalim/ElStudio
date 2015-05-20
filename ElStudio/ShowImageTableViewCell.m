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

-(void)ModifyAccordingToSavedScale:(NSNumber*)scale {
	float myscale = [scale floatValue] ;
	oneimg.transform = CGAffineTransformScale(oneimg.transform, myscale, myscale);
}

-(IBAction)scale:(UIPinchGestureRecognizer*)pinch
{
	float scale = pinch.scale;
	float realscale = oneimg.frame.size.width / self.container.frame.size.width ;
	NSNumber *ScaleToBeSent = [NSNumber numberWithFloat:realscale] ;
	oneimg.transform = CGAffineTransformScale(oneimg.transform, scale, scale);
	pinch.scale = 1;
	[self.delegate SaveImageScale:ScaleToBeSent AtIndex:self.index];
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
