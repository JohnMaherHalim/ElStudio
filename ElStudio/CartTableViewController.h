//
//  CartTableViewController.h
//  ElStudio
//
//  Created by John Maher on 5/14/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WholeOrder.h"

@interface CartTableViewController : UITableViewController {
    NSMutableArray *orderItems ;
    NSInteger globalindex ;
}

@property (nonatomic , retain) IBOutlet UITableView *tableView ;

-(IBAction)UploadOrder:(id)sender;

@end
