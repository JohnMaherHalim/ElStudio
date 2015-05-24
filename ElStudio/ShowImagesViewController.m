//
//  ShowImagesViewController.m
//  ElStudio
//
//  Created by John Maher on 4/27/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "ShowImagesViewController.h"
#import "ShowImageTableViewCell.h"
#import "AffineImageViewController.h"
#import "CurrentOrderManager.h"
#import "WholeOrder.h"

@interface ShowImagesViewController ()

@end

@implementation ShowImagesViewController

@synthesize images,tableView ;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    uploadData = [[NSData alloc]init];
    //[self setEditing:YES];
    [self.tableView setEditing:YES];
	self.requestsManager = [[GRRequestsManager alloc] initWithHostname:@"ws.doctory.info"
																  user:@"doctorym"
															  password:@"toztoz1"];
	
	self.requestsManager.delegate = self;
	
    if (!self.counts) {
        self.counts = [[NSMutableArray alloc]init] ;
        for (UIImage *img in images) {
            NSNumber *initial = [NSNumber numberWithInt:1];
            [self.counts addObject:initial];
        }
    }
	
	if (!self.scales) {
		self.scales = [[NSMutableArray alloc]init] ;
		for (UIImage *img in images) {
			NSNumber *initial = [NSNumber numberWithInt:1];
			[self.scales addObject:initial];
		}
	}
	
	
   // images = [[NSMutableArray alloc]init] ;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [images count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ShowImageCell";
    
    ShowImageTableViewCell *cell = (ShowImageTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShowImageTableViewCell" owner:self options:nil];
        cell = (ShowImageTableViewCell *)[nib objectAtIndex:0];
    }
    cell.delegate = self ;
    cell.oneimg.image = [images objectAtIndex:indexPath.row];
    cell.index = indexPath.row ;
    NSNumber *cellcounter = [self.counts objectAtIndex:indexPath.row] ;
    [cell.counter setText:[cellcounter stringValue]];
	NSNumber *cellScale = [self.scales objectAtIndex:indexPath.row];
	[cell ModifyAccordingToSavedScale:cellScale]; 
    
    return cell;
}

-(void)modifyCountstoEditedOrder {
    if (self.editbool) {
        OrderItem *OrderItemtobemodified = [[[[WholeOrder sharedManager]myOrder]OrderItems]objectAtIndex:self.editnumberflag];
        OrderItemtobemodified.ImagesCounts = self.counts ;
        [[[[WholeOrder sharedManager]myOrder]OrderItems]replaceObjectAtIndex:self.editnumberflag withObject:OrderItemtobemodified];
        [[WholeOrder sharedManager]SaveMyOrder] ;
    }
}

-(void)PlusOne:(NSInteger)index {
    NSNumber *number = [self.counts objectAtIndex:index];
    int value = [number intValue];
    number = [NSNumber numberWithInt:value + 1];
    [self.counts replaceObjectAtIndex:index withObject:number];
    
    [self modifyCountstoEditedOrder] ;
    
    
}



-(void)MinusOne:(NSInteger)index  {
    NSNumber *number = [self.counts objectAtIndex:index];
    int value = [number intValue];
    number = [NSNumber numberWithInt:value - 1];
    [self.counts replaceObjectAtIndex:index withObject:number];
    
    [self modifyCountstoEditedOrder] ;
    
}

-(void)modifyScalestoEditedOrder {
    if (self.editbool) {
        OrderItem *OrderItemtobemodified = [[[[WholeOrder sharedManager]myOrder]OrderItems]objectAtIndex:self.editnumberflag];
        OrderItemtobemodified.ImagesScales = self.scales ;
        [[[[WholeOrder sharedManager]myOrder]OrderItems]replaceObjectAtIndex:self.editnumberflag withObject:OrderItemtobemodified];
        [[WholeOrder sharedManager]SaveMyOrder] ;
    }
}

-(void)SaveImageScale:(NSNumber*)scale AtIndex:(NSInteger)index {
	[self.scales replaceObjectAtIndex:index withObject:scale];
    [self modifyScalestoEditedOrder] ;
	//[self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    imagetopass = [[UIImage alloc]init];
    imagetopass = [images objectAtIndex:indexPath.row] ;
    
    [self performSegueWithIdentifier:@"GoToAffineImage"
                              sender:nil];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.editbool == false)
        [self EditFirstTime:sourceIndexPath.row ToDestination:destinationIndexPath.row];
    else
        [self MoveExistingImageFrom:sourceIndexPath.row toDestination:destinationIndexPath.row inOrderItemNumber:self.editnumberflag];
    
    [self.tableView reloadData] ; 
}

-(void)EditFirstTime:(NSInteger)index ToDestination:(NSInteger)Destindex{
    UIImage *stringToMove = [self.images objectAtIndex:index];
    [self.images removeObjectAtIndex:index];
    [self.images insertObject:stringToMove atIndex:Destindex];
    
    NSNumber *number = [self.counts objectAtIndex:index];
    [self.counts removeObjectAtIndex:index];
    [self.counts insertObject:number atIndex:Destindex] ;
	
	NSNumber *number1 = [self.scales objectAtIndex:index];
	[self.scales removeObjectAtIndex:index];
	[self.scales insertObject:number1 atIndex:Destindex] ;
}

-(void)MoveExistingImageFrom:(NSInteger)index toDestination:(NSInteger)DestIndex inOrderItemNumber:(int)number {
    OrderItem *OrderItemtobemodified = [[[[WholeOrder sharedManager]myOrder]OrderItems]objectAtIndex:number];
    UIImage *stringToMove = [OrderItemtobemodified.ProductImages objectAtIndex:index];
    [OrderItemtobemodified.ProductImages removeObjectAtIndex:index];
    [OrderItemtobemodified.ProductImages insertObject:stringToMove atIndex:DestIndex];
   // OrderItemtobemodified.ProductName = @"Product 1" ;
    NSNumber *counts = [OrderItemtobemodified.ImagesCounts objectAtIndex:index];
    [OrderItemtobemodified.ImagesCounts removeObjectAtIndex:index];
    [OrderItemtobemodified.ImagesCounts insertObject:counts atIndex:DestIndex];
	NSNumber *scale = [OrderItemtobemodified.ImagesScales objectAtIndex:index];
	[OrderItemtobemodified.ImagesScales removeObjectAtIndex:index];
	[OrderItemtobemodified.ImagesScales insertObject:scale atIndex:DestIndex];
	
    [[[[WholeOrder sharedManager]myOrder]OrderItems]replaceObjectAtIndex:number withObject:OrderItemtobemodified];
	[[WholeOrder sharedManager]SaveMyOrder] ;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(UIView* view in cell.subviews)
    {
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"])
        {
            // Creates a new subview the size of the entire cell
            UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
            // Adds the reorder control view to our new subview
            [movedReorderControl addSubview:view];
            // Adds our new subview to the cell
            [cell addSubview:movedReorderControl];
            // CGStuff to move it to the left
            CGSize moveLeft = CGSizeMake(movedReorderControl.frame.size.width - view.frame.size.width, movedReorderControl.frame.size.height - view.frame.size.height);
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
            // Performs the transform
            [movedReorderControl setTransform:transform];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToAffineImage"]) {
        AffineImageViewController *affine = [segue destinationViewController] ;
        //[showimgs setImages:imgarray];
        [affine setMyimage:imagetopass]; 
    } else if ([segue.identifier isEqualToString:@"GoToOrderItemThankYou"]) {
        [[CurrentOrderManager sharedManager]storeProductImages:images];
        [[CurrentOrderManager sharedManager]storeImagesCounts:self.counts];
		[[CurrentOrderManager sharedManager]storeScales:self.scales];
        OrderItem *orderitem = [[OrderItem alloc]init];
        orderitem.ProductName = [[[CurrentOrderManager sharedManager]curOrderItem]ProductName];
        orderitem.ProductImages = [[[CurrentOrderManager sharedManager]curOrderItem]ProductImages];
        orderitem.ImagesCounts = [[[CurrentOrderManager sharedManager]curOrderItem]ImagesCounts];
		orderitem.ImagesScales = [[[CurrentOrderManager sharedManager]curOrderItem]ImagesScales];
        [[WholeOrder sharedManager]addtoOrderItems:orderitem];
		[[WholeOrder sharedManager]SaveMyOrder]; 
    }
    
    
}


-(IBAction)uploadfile:(id)sender
{
	//UIImage *img = [images objectAtIndex:0];
	
	
	//Write the file
	
	[self.requestsManager addRequestForCreateDirectoryAtPath:@"ImagesTest/OrderNumTwo"];
	int counter = 0 ;
	
	NSMutableArray *normimages = [self returnaffinedimages];
	
	for (UIImage* img in normimages) {
		counter++ ;
		NSData *pngData = UIImagePNGRepresentation(img);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
		NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",counter]]; //Add the file name
		[pngData writeToFile:filePath atomically:YES];
		[self.requestsManager addRequestForUploadFileAtLocalPath:filePath toRemotePath:[NSString stringWithFormat:@"ImagesTest/OrderNumTwo/%d.png",counter]];
	}
	
	//[self.requestsManager addRequestForUploadFileAtLocalPath:filePath toRemotePath:@"ImagesTest/source.png"];
	
	[self.requestsManager startProcessingRequests];
	
	/*NSMutableArray *normimages = [self returnaffinedimages];
	ShowImagesViewController *myself = [[ShowImagesViewController alloc]init] ;
	[myself setImages:normimages];
	[self.navigationController pushViewController:myself animated:YES];*/
	
	
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteUploadRequest:(id<GRDataExchangeRequestProtocol>)request {
	NSLog(@"done");
}

-(NSMutableArray*)returnaffinedimages {
	
	NSMutableArray *affinedimages = [[NSMutableArray alloc]init] ;
	
	NSMutableArray *cells = [[NSMutableArray alloc] init];
	for (NSInteger j = 0; j < [tableView numberOfSections]; ++j)
	{
		for (NSInteger i = 0; i < [tableView numberOfRowsInSection:j]; ++i)
		{
			[cells addObject:[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
		}
	}
	
	for (ShowImageTableViewCell *cell in cells)
	{
		UIImage *myimg = [self imageWithView:cell.container];
		[affinedimages addObject:myimg];
		//UITextField *textField = [cell textField];
		//NSLog(@"%@"; [textField text]);
	}
	
	return affinedimages ;
}

- (UIImage *) imageWithView:(UIView *)view
{
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return img;
}



@end
