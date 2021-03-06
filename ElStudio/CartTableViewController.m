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
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"

@interface CartTableViewController ()

@end

@implementation CartTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FTPUploadError = false ;
    
	self.tableView.allowsMultipleSelectionDuringEditing = NO ;
    
    filepaths = [[NSMutableArray alloc]init];
    MyproductsIds = [[NSArray alloc]init];
    
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
		
		//[[[[WholeOrder sharedManager]myOrder]OrderItems]removeObjectAtIndex:indexPath.row];
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
   
    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults] ;
    NSString *Phone = @"test"; //[defautls objectForKey:@"phone"];
    
    NSString *rawString = Phone;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([Phone isEqualToString:@""] || Phone == nil || trimmed.length == 0) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Phone Missing"
                                                              message:@"Plz Enter Your Phone First" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [myAlertView show];
    } else {
        [self MakeTheOrder];
    }
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%@", [alertView textFieldAtIndex:0].text);
    if (buttonIndex == 1) {
    UITextField *textfield = [alertView textFieldAtIndex:0];
    
    //NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults] ;
    NSString *Phone = textfield.text; //[defautls objectForKey:@"phone"];
    
    NSString *rawString = Phone;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([Phone isEqualToString:@""] || Phone == nil || trimmed.length == 0) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                              message:@"You didn't enter a phone number yet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [myAlertView show];
    } else {
        [self UpdatePhoneNumber:Phone];
    }
    }
    
}


-(void)UpdatePhoneNumber:(NSString*)PhoneNumber {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:[defaults objectForKey:@"UserID"] forKey:@"userId"];
    [parameters setObject:[defaults objectForKey:@"UserName"] forKey:@"name"];
    [parameters setObject:[defaults objectForKey:@"UserEmail"] forKey:@"email"];
    [parameters setObject:[defaults objectForKey:@"UserPassword"] forKey:@"password"];
    [parameters setObject:[defaults objectForKey:@"UserAddress"] forKey:@"address"];
    [parameters setObject:PhoneNumber forKey:@"phone"];
    NSLog(@"Update Json : %@",parameters);
    [SVProgressHUD show];
    
    [manager POST:@"http://ws.elstud.io/api/user/updateuserinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss] ;
        [self login:responseObject];
       // [self Send];
        [self MakeTheOrder];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Error getting data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show] ;
        [SVProgressHUD dismiss];
    }];

}

-(void)login:(id)responseObject {
    NSNumber *UserID = [responseObject objectForKey:@"userId"];
    NSString *UserEmail = [responseObject objectForKey:@"email"];
    NSString *userName = [responseObject objectForKey:@"name"];
    NSString *userAddress = [responseObject objectForKey:@"address"];
    NSString *userPassword = [responseObject objectForKey:@"password"];
    NSString *userPhone = [responseObject objectForKey:@"phone"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UserID forKey:@"UserID"];
    [defaults setObject:UserEmail forKey:@"UserEmail"];
    [defaults setObject:userName forKey:@"UserName"];
    [defaults setObject:userAddress forKey:@"UserAddress"];
    [defaults setObject:userPassword forKey:@"UserPassword"];
    [defaults setObject:userPhone forKey:@"UserPhone"];
    [defaults synchronize] ;
    //[self.navigationController popToRootViewControllerAnimated:YES] ;
}

-(void)MakeTheOrder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults] ;
    
    NSMutableArray *ProductIDs = [[NSMutableArray alloc]init];
    Order *myorder = [[WholeOrder sharedManager]myOrder];
    for (OrderItem *item in myorder.OrderItems) {
        [ProductIDs addObject:item.product.Product_id];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    NSNumber *userid = [defaults objectForKey:@"UserID"];
    [parameters setObject:userid forKey:@"userId"];
    [parameters setObject:[NSDate date] forKey:@"date"];
    [parameters setObject:ProductIDs forKey:@"productsIds"];
    [SVProgressHUD show];
    
    [manager POST:@"http://ws.elstud.io/api/order/makeorder" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString *orderId = [responseObject objectForKey:@"orderId"];
        NSArray *productsIds = [responseObject objectForKey:@"productsIds"];
        
        MyorderId = orderId ;
        MyproductsIds = productsIds ;
        [SVProgressHUD dismiss] ;
        [self Send:orderId andProductsIDs:productsIds];
        
       // [self login:responseObject];
       // [self Send];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Error getting data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show] ;
        [SVProgressHUD dismiss];
    }];

}


-(void)Send:(NSString*)orderId andProductsIDs:(NSArray*)productsIds {
  //  OrderItem *OrderItemtobemodified = [[[[WholeOrder sharedManager]myOrder]OrderItems]objectAtIndex:0];
    
    [SVProgressHUD show];
    
    NSString *OrderDirectory = [NSString stringWithFormat:@"ws.elstud.io/orders/%@",orderId]; //@"ws.elstud.io/UserIDOrderID" ;
    [self.requestsManager addRequestForCreateDirectoryAtPath:OrderDirectory];
    
    NSMutableArray *OrderItems = [[[WholeOrder sharedManager]myOrder]OrderItems];
    NSInteger count = 0 ;
    for (OrderItem *OrderItemtobemodified in OrderItems) {
        NSString *ProductID = [productsIds objectAtIndex:count];
        
        NSString *ZipFileName = [NSString stringWithFormat:@"%@.zip",ProductID]; //@"test3.zip" ;
        
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
            NSString *varstring = [NSString stringWithFormat:@"%@-%d.jpg",ProductID, counter];
            ZipWriteStream *stream= [zipFile writeFileInZipWithName:varstring compressionLevel:ZipCompressionLevelBest];
            //if (counter == 0) {
            [stream writeData:jpgData];
            [stream finishedWriting];
            //}
            counter++ ;
        }
        
        [zipFile close] ;
        
        
        
        
       // NSString *ProductName = @"ws.elstud.io/UserIDOrderID/Product1" ;  //[NSString stringWithFormat:@"%@/%@",OrderDirectory, OrderItemtobemodified.ProductName];
        NSString *Images = [NSString stringWithFormat:@"%@/%@",OrderDirectory,ZipFileName];
        NSString *WholeLink = [NSString stringWithFormat:@"ftp://elstud.io/%@",Images];
        
        [filepaths addObject:WholeLink];
        // [self.requestsManager addRequestForDownloadFileAtRemotePath:@"ws.elstud.io/Web.config" toLocalPath:WebConfigtrial];
        
        //[self.requestsManager addRequestForCreateDirectoryAtPath:ProductName];
        //[self.requestsManager addRequestForCreateDirectoryAtPath:Images];
        [self.requestsManager addRequestForUploadFileAtLocalPath:ImagesZipFile toRemotePath:Images];
        
        count++;
    }
    
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
    FTPUploadError = true ;
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteDownloadRequest:(id<GRDataExchangeRequestProtocol>)request {
    NSLog(@"Download Success") ; 
}



- (void)requestsManagerDidCompleteQueue:(id<GRRequestsManagerProtocol>)requestsManager {
    //NSLog(@"Queue done") ;
    [SVProgressHUD dismiss];
    if (!FTPUploadError)
        [self UpdateFilePaths:filepaths];
    
}

-(void)UpdateFilePaths:(NSMutableArray*)paths {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:MyorderId forKey:@"orderId"];
    [parameters setObject:MyproductsIds forKey:@"productsIds"];
    [parameters setObject:paths forKey:@"folderPaths"];
    NSLog(@"Update Json : %@",parameters);
    [SVProgressHUD show];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"http://ws.elstud.io/api/order/updatefolderpaths" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [SVProgressHUD dismiss] ;
        if (FTPUploadError) {
            UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Sorry, an error has occured while sending" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [msg show];
        } else {
            UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your images have been sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [msg show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Error sending data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show] ;
        [SVProgressHUD dismiss];
    }];

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
