//
//  ShowImageTableViewCell.h
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowImagesViewController.h"

@interface ShowImageTableViewCell : UITableViewCell

@property (retain) IBOutlet UIImageView *oneimg ;
@property (retain) IBOutlet UIView *container ;
@property (retain) IBOutlet UILabel *counter ;
@property (nonatomic,weak) ShowImagesViewController *delegate ;
@property NSInteger index ; 

-(IBAction)scale:(UIPinchGestureRecognizer*)pinch;
-(IBAction)IncreaseCount:(id)sender;
-(IBAction)DecreaseCount:(id)sender;

@end
