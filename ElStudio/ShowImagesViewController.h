//
//  ShowImagesViewController.h
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImagesViewController : UIViewController <UITableViewDataSource , UITableViewDelegate> {
    UIImage *imagetopass ; 
}

@property (retain) NSMutableArray *images ;
@property (retain) IBOutlet UITableView *tableView ; 

@end
