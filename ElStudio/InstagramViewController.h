//
//  InstagramViewController.h
//  ElStudio
//
//  Created by John Maher on 5/31/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramKit.h" 

@interface InstagramViewController : UIViewController

@property (nonatomic , retain) IBOutlet UIWebView *mWebView ;
@property (nonatomic , retain) IBOutlet UIImageView *imageView ; 

-(IBAction)InstagramLogin:(id)sender;

@end
