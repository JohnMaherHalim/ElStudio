//
//  ShowImageTableViewCell.h
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageTableViewCell : UITableViewCell

@property (retain) IBOutlet UIImageView *oneimg ;
@property (retain) IBOutlet UIView *container ;

-(IBAction)scale:(UIPinchGestureRecognizer*)pinch;

@end
