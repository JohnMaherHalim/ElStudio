//
//  ShowImagesViewController.h
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRRequestsManager.h"


@interface ShowImagesViewController : UIViewController <UITableViewDataSource , UITableViewDelegate,GRRequestsManagerDelegate> {
    UIImage *imagetopass ;
	NSData *uploadData ; 
}

@property (retain) NSMutableArray *images ;
@property (retain) NSMutableArray *counts ;
@property (retain) NSMutableArray *scales ; 
@property (retain) IBOutlet UITableView *tableView ;
@property (nonatomic, strong) GRRequestsManager *requestsManager;
@property BOOL editbool ; 
@property int editnumberflag ; 


-(IBAction)uploadfile:(id)sender;
-(void)PlusOne:(NSInteger)index ;
-(void)MinusOne:(NSInteger)index ;
-(void)SaveImageScale:(NSNumber*)scale AtIndex:(NSInteger)index;

@end
