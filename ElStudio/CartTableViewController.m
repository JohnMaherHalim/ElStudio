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
#import "UIDeviceHardware.h"

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
    
    NSInteger OrderTotalPrice = 0 ;
    for (OrderItem *item in orderItems) {
        OrderTotalPrice += item.ItemPrice ;
    }
    NSString *TotalPticeString = [NSString stringWithFormat:@"Total Price is : $ %ld",(long)OrderTotalPrice];
    [self.totalPrice setText:TotalPticeString] ; 
    
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
    
    
    NSString *ZipFileName = @"test3.zip" ;
    
    NSString *cacheDirectory 	= [self getChacheDirectoryPath];
    NSString *ImagesZipFile		= [cacheDirectory stringByAppendingPathComponent:ZipFileName];
    NSString *WebConfigtrial = [cacheDirectory stringByAppendingPathComponent:@"Web.config"];
    
    [[NSFileManager defaultManager]createFileAtPath:ImagesZipFile contents:nil attributes:nil];
    
    ZipFile *zipFile= [[ZipFile alloc] initWithFileName:ImagesZipFile mode:ZipFileModeCreate];
    int counter = 0 ;
    //int imagestosendcounter = 0 ;
    
    
    for (UIImage* img in OrderItemtobemodified.ProductImages) {
        NSNumber *thisimagescalea = [OrderItemtobemodified.ImagesScales objectAtIndex:counter] ;
        float thisimagescale = [thisimagescalea floatValue] ;
        UIImage *croppedimage = [self imageByCroppingImage:img toSize:CGSizeMake(img.size.width/thisimagescale, img.size.height/thisimagescale)];
        UIImage *modifiedimage = [self ModifyTheImage:croppedimage inHeightInches:2 andWidthInches:2];
        //NSData *pngData = UIImagePNGRepresentation(modifiedimage);
        NSData *jpgData = UIImageJPEGRepresentation(modifiedimage, 1);
        NSString *varstring = [NSString stringWithFormat:@"%d.jpg",counter];
        ZipWriteStream *stream= [zipFile writeFileInZipWithName:varstring compressionLevel:ZipCompressionLevelBest];
        //if (counter == 0) {
        [stream writeData:jpgData];
        [stream finishedWriting];
        //}
        counter++ ;
    }
    
    [zipFile close] ;
    
    
    NSString *OrderDirectory = @"ws.elstud.io/UserIDOrderID" ;
    NSString *ProductName = @"ws.elstud.io/UserIDOrderID/Product1" ;  //[NSString stringWithFormat:@"%@/%@",OrderDirectory, OrderItemtobemodified.ProductName];
    NSString *Images = [NSString stringWithFormat:@"%@/%@",ProductName,ZipFileName];
   // [self.requestsManager addRequestForDownloadFileAtRemotePath:@"ws.elstud.io/Web.config" toLocalPath:WebConfigtrial];
    //[self.requestsManager addRequestForCreateDirectoryAtPath:OrderDirectory];
    //[self.requestsManager addRequestForCreateDirectoryAtPath:ProductName];
    //[self.requestsManager addRequestForCreateDirectoryAtPath:Images];
    [self.requestsManager addRequestForUploadFileAtLocalPath:ImagesZipFile toRemotePath:Images];
    [self.requestsManager startProcessingRequests];
   
}

-(UIImage*)ModifyTheImage:(UIImage*)firstimg inHeightInches:(int)height andWidthInches:(int)width {
    UIImage *img = [[UIImage alloc]init];
    
   // int ppi = 326 ;
    int ppi = 72 ; 
    UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    NSString *currentDevice = [h platformString] ;
    
    /* if ([currentDevice isEqualToString:@"iPhone 4S"]) {
     ppi = 326 ;
     } else if ([currentDevice isEqualToString:@"iPhone 5 (GSM)"] || [currentDevice isEqualToString:@"iPhone 5 (GSM+CDMA)"]|| [currentDevice isEqualToString:@"iPhone 5c (GSM)"]|| [currentDevice isEqualToString:@"iPhone 5c (GSM+CDMA)"]|| [currentDevice isEqualToString:@"iPhone 5s (GSM)"]|| [currentDevice isEqualToString:@"iPhone 5s (GSM+CDMA)"]){
     ppi = 326 ;
     } else if ([currentDevice isEqualToString:@"iPhone 6"]) {
     ppi = 326 ;
     } else */
    if ([currentDevice isEqualToString:@"iPhone 6 Plus"]) {
        ppi = 401 ;
    }
    
    int HeightInPixels = height * ppi ;
    int WidthInPixels = width * ppi ;
    
    img = [self imageWithImage:firstimg scaledToSize:CGSizeMake(WidthInPixels, HeightInPixels)];
    
    
    
    return img ;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    double x = (image.size.width - size.width) / 2.0 ;
    double y = (image.size.height - size.height) / 2.0 ;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
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
