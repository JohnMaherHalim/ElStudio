//
//  CartTableViewController.m
//  ElStudio
//
//  Created by John Maher on 5/14/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "CartTableViewController.h"
#import "ShowImagesViewController.h"
#import "ZipFile.h"
#import "ZipWriteStream.h"

@interface CartTableViewController ()

@end

@implementation CartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.tableView.allowsMultipleSelectionDuringEditing = NO ;
    
    self.requestsManager = [[GRRequestsManager alloc] initWithHostname:@"ws.elstud.io"
                                                                  user:@"elstudioproject"
                                                              password:@"7Qrs54msdoe355"];
    
   /* self.requestsManager = [[GRRequestsManager alloc] initWithHostname:@"tarawah.com"
                                                                  user:@"minafaye"
                                                              password:@"doctorypass"];*/
    
    self.requestsManager.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    
    orderItems = [[NSMutableArray alloc]init];
    
    orderItems = [[[WholeOrder sharedManager]myOrder]OrderItems];
    
    [self.tableView reloadData] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [orderItems count] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
   // [cell.textLabel setText:[products objectAtIndex:indexPath.row]];
    
    OrderItem *orderitem = [orderItems objectAtIndex:indexPath.row] ;
    [cell.textLabel setText:orderitem.ProductName];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    globalindex = indexPath.row ;
    [self performSegueWithIdentifier: @"GoToModifyExistingItem" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToModifyExistingItem"]){
        ShowImagesViewController *images = [segue destinationViewController];
        int myInt = (int) globalindex;
        [images setEditnumberflag:myInt] ;
        [images setEditbool:true]; 
        OrderItem *orderitem = [[[[WholeOrder sharedManager]myOrder]OrderItems]objectAtIndex:globalindex];
        [images setImages:orderitem.ProductImages];
        [images setCounts:orderitem.ImagesCounts];
		[images setScales:orderitem.ImagesScales]; 
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return YES if you want the specified item to be editable.
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[orderItems removeObjectAtIndex:indexPath.row];
		[self.tableView reloadData] ;
		
		[[[[WholeOrder sharedManager]myOrder]OrderItems]removeObjectAtIndex:indexPath.row];
		[[WholeOrder sharedManager]SaveMyOrder] ;
		//NSLog(@"Hi") ;
		//add code here for when you hit delete
	}
}

- (NSString *)getChacheDirectoryPath	{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(IBAction)UploadOrder:(id)sender {
    OrderItem *OrderItemtobemodified = [[[[WholeOrder sharedManager]myOrder]OrderItems]objectAtIndex:0];
    
    NSString *cacheDirectory 	= [self getChacheDirectoryPath];
    NSString *ImagesZipFile		= [cacheDirectory stringByAppendingPathComponent:@"test.zip"];
    NSString *WebConfigtrial = [cacheDirectory stringByAppendingPathComponent:@"Web.config"];
    
    [[NSFileManager defaultManager]createFileAtPath:ImagesZipFile contents:nil attributes:nil];
    
    ZipFile *zipFile= [[ZipFile alloc] initWithFileName:ImagesZipFile mode:ZipFileModeCreate];
    int counter = 0 ;
    
    for (UIImage* img in OrderItemtobemodified.ProductImages) {
        NSData *pngData = UIImagePNGRepresentation(img);
        NSString *varstring = [NSString stringWithFormat:@"%d.png",counter];
        ZipWriteStream *stream= [zipFile writeFileInZipWithName:varstring compressionLevel:ZipCompressionLevelBest];
        [stream writeData:pngData];
        [stream finishedWriting];
    }
    
    NSString *OrderDirectory = @"ws.elstud.io/UserIDOrderID" ;
    NSString *ProductName = @"ws.elstud.io/UserIDOrderID/Product1" ;  //[NSString stringWithFormat:@"%@/%@",OrderDirectory, OrderItemtobemodified.ProductName];
    NSString *Images = [NSString stringWithFormat:@"%@/test.zip",ProductName];
   // [self.requestsManager addRequestForDownloadFileAtRemotePath:@"ws.elstud.io/Web.config" toLocalPath:WebConfigtrial];
    [self.requestsManager addRequestForCreateDirectoryAtPath:OrderDirectory];
    [self.requestsManager addRequestForCreateDirectoryAtPath:ProductName];
    //[self.requestsManager addRequestForCreateDirectoryAtPath:Images];
    [self.requestsManager addRequestForUploadFileAtLocalPath:ImagesZipFile toRemotePath:Images];
    [self.requestsManager startProcessingRequests];
   
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteUploadRequest:(id<GRDataExchangeRequestProtocol>)request {
    NSLog(@"done");
}


- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailWritingFileAtPath:(NSString *)path forRequest:(id<GRDataExchangeRequestProtocol>)request error:(NSError *)error {
    NSLog(@"error") ;
}

/**
 @brief Called to notify the delegate that a given request failed.
 @param requestsManager The requests manager.
 @param request The request.
 @param error The error reporterd.
 */
- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailRequest:(id<GRRequestProtocol>)request withError:(NSError *)error {
    NSLog(@"error") ;
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteDownloadRequest:(id<GRDataExchangeRequestProtocol>)request {
    NSLog(@"Download Success") ; 
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
