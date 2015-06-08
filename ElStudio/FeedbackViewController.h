//
//  FeedbackViewController.h
//  ElStudio
//
//  Created by John Maher on 6/8/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController

@property (nonatomic,retain) IBOutlet UITextView *textView ;

-(IBAction)SendFeedback:(id)sender;

@end
