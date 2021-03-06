//
//  CartTableViewController.h
//  ElStudio
//
//  Created by John Maher on 5/14/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WholeOrder.h"
#import "GRRequestsManager.h"

@interface CartTableViewController : UITableViewController<GRRequestsManagerDelegate,UIAlertViewDelegate> {
    NSMutableArray *orderItems ;
    NSInteger globalindex ;
    BOOL FTPUploadError ;
    
    NSMutableArray *filepaths ;
    NSString *MyorderId ;
    NSArray *MyproductsIds ;
}

@property (nonatomic , retain) IBOutlet UITableView *tableView ;
@property (nonatomic, strong) GRRequestsManager *requestsManager;
@property (nonatomic , retain) IBOutlet UILabel *totalPrice ;
@property (nonatomic ,retain) UITextField *PhoneNumberField ; 

-(IBAction)UploadOrder:(id)sender;

@end
