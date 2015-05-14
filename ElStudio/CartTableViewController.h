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
}

@property (nonatomic , retain) IBOutlet UITableView *tableView ; 

@end
