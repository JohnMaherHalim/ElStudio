//
//    Copyright (c) 2013 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IKCollectionViewController.h"
#import "InstagramKit.h"
#import "UIImageView+AFNetworking.h"
#import "IKCell.h"
#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "ShowImagesViewController.h"
#import "CurrentOrderManager.h"
//#import "IKLoginViewController.h"
//#import "IKMediaViewController.h"

@interface IKCollectionViewController ()
{
    NSMutableArray *mediaArray;
    __weak IBOutlet UITextField *textField;
}
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@end

@implementation IKCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        mediaArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedImages = [[NSMutableArray alloc]init] ;
    [self.collectionView setAllowsMultipleSelection:YES] ;
    
    [self loadMedia];
}

- (IBAction)reloadMedia
{
    self.currentPaginationInfo = nil;
    if (mediaArray) {
        [mediaArray removeAllObjects];
    }

    [self loadMedia];
}

- (void)loadMedia
{
    [textField resignFirstResponder];
    textField.text = @"";

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [defaults objectForKey:@"instatoken"];
    [[InstagramEngine sharedEngine] setAccessToken:accesstoken];
    InstagramEngine *sharedEngine = [InstagramEngine sharedEngine];
    
    
    if (sharedEngine.accessToken)
    {
    //    [self testLoadSelfFeed];
//        [self testLoadSelfLikedMedia];
        [self getSelfUserDetails];
    
    }
    else
    {
        [self testLoadPopularMedia];
    }
    
   // [self testLoadSelfFeed];
}

- (IBAction)searchMedia
{
    self.currentPaginationInfo = nil;
    if (mediaArray) {
        [mediaArray removeAllObjects];
    }
    [textField resignFirstResponder];

    if ([textField.text length]) {
        [self testGetMediaFromTag:textField.text];
//        [self testSearchUsersWithString:textField.text];
    }
}


- (void)testLoadPopularMedia
{
    [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        [mediaArray removeAllObjects];
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Load Popular Media Failed");
    }];

}

- (void)getSelfUserDetails
{
    [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser *userDetail) {
        NSLog(@"%@",userDetail);
        //NSLog(@"%@",userDetail.Id);
        [self testLoadMediaForUser:userDetail] ;
    } failure:^(NSError *error, NSInteger statusCode) {
        
    }];
}


- (void)testLoadSelfFeed
{
    [[InstagramEngine sharedEngine] getSelfFeedWithCount:15 maxId:self.currentPaginationInfo.nextMaxId success:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        
        [mediaArray addObjectsFromArray:media];
        
        [self reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Request Self Feed Failed");
    }];
}


- (void)testLoadSelfLikedMedia
{
    [[InstagramEngine sharedEngine] getMediaLikedBySelfWithCount:15 maxId:self.currentPaginationInfo.nextMaxId success:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        
        [mediaArray addObjectsFromArray:media];
        
        [self reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Request Self Liked Media Failed");
        
    }];
}


- (void)testSearchUsersWithString:(NSString *)string
{
    [[InstagramEngine sharedEngine] searchUsersWithString:string withSuccess:^(NSArray *users, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"%ld users found", (long)users.count);
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"user search failed");
    }];
}

- (void)testGetMediaFromTag:(NSString *)tag
{
    [[InstagramEngine sharedEngine] getMediaWithTagName:tag count:15 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Search Media Failed");
    }];
}

- (void)testLoadMediaForUser:(InstagramUser *)user
{
    [[InstagramEngine sharedEngine] getMediaForUser:user.Id count:15 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *feed, InstagramPaginationInfo *paginationInfo) {

        if (paginationInfo) {
            self.currentPaginationInfo = paginationInfo;
        }
        
        [mediaArray addObjectsFromArray:feed];
        [self reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Loading User media failed");
    }];
}

- (void)testPaginationRequest:(InstagramPaginationInfo *)pInfo
{
    [[InstagramEngine sharedEngine] getPaginatedItemsForInfo:self.currentPaginationInfo
                                                 withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"%ld more media in Pagination",(unsigned long)media.count);
        self.currentPaginationInfo = paginationInfo;
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
    }
                                                     failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Pagination Failed");
    }];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.media.detail"]) {
        IKMediaViewController *mvc = (IKMediaViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
        InstagramMedia *media = mediaArray[selectedIndexPath.item];
        mvc.media = media;
    }
    if ([segue.identifier isEqualToString:@"segue.login"]) {
        UINavigationController *loginNavigationVC = (UINavigationController *)segue.destinationViewController;
        IKLoginViewController *loginVc = loginNavigationVC.viewControllers[0];
        loginVc.collectionViewController = self;
    }
}*/

#pragma mark - UICollectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mediaArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    
    if (mediaArray.count >= indexPath.row+1) {
        InstagramMedia *media = mediaArray[indexPath.row];
        [cell.imageView setImageWithURL:media.thumbnailURL];
    }
    else
        [cell.imageView setImage:nil];
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0.75 alpha:1];
    cell.selectedBackgroundView = myBackView;
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
    
    InstagramMedia *media = mediaArray[indexPath.row];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:media.thumbnailURL]];
    [self.selectedImages addObject:image];
    
    NSInteger currentCount = [self.selectedImages count];
    Product *prod = [[[CurrentOrderManager sharedManager]curOrderItem]product];
    NSInteger ProductBasicNumber = 3;//[prod.Product_basicNumber integerValue] ;
    NSInteger ProductAddOnNumber = 2;//[prod.Product_addonNumber integerValue];
    
    if (currentCount < ProductBasicNumber) {
        
    } else if (currentCount == ProductBasicNumber) {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Basic" message:@"Done Basic" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show];
    } else {
        
        NSInteger IndexAfter = currentCount - ProductBasicNumber ;
        NSInteger check = currentCount % ProductAddOnNumber ;
        
       /* if (IndexAfter > ProductAddOnNumber) {
            IndexAfter = IndexAfter % ProductAddOnNumber ;
        }
        
        if (IndexAfter == ProductAddOnNumber) {
            UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"AddOn" message:@"Done AddOn" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [msg show];
            
        }*/
        
        if (IndexAfter % ProductAddOnNumber == 0) {
            UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"AddOn" message:@"Done AddOn" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [msg show];
        }
        
        
        
        
        /* NSInteger checkAddOn = currentCount %  self.ProductAddOnNumber;
         if (checkAddOn == 0) {
         UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"AddOn" message:@"Done AddOn" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
         [msg show];
         }*/
    }
    
    [[CurrentOrderManager sharedManager]refreshOrderWithNumberOfImages:[self.selectedImages count]];
   // NSLog(@"Click");
    
   // [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    InstagramMedia *media = mediaArray[indexPath.row];
//    [self testLoadMediaForUser:media.user];
    
   /* if (self.currentPaginationInfo)
    {
//  Paginate on navigating to detail
//either
//        [self loadMedia];
//or
//        [self testPaginationRequest:self.currentPaginationInfo];
    }*/
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    InstagramMedia *media = mediaArray[indexPath.row];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:media.thumbnailURL]];
    NSData *checkImageData = UIImagePNGRepresentation(image);
    
    for (UIImage *img in self.selectedImages) {
        NSData *propertyImageData = UIImagePNGRepresentation(img);
        if ([checkImageData isEqualToData:propertyImageData]) {
            //do sth
            [self.selectedImages removeObject:img];
            break; 
        }
    }
    
    [[CurrentOrderManager sharedManager]refreshOrderWithNumberOfImages:[self.selectedImages count]];
    
}


-(void)refreshCurrentOrderData {
    NSInteger currentCount = [self.selectedImages count];
    Product *prod = [[[CurrentOrderManager sharedManager]curOrderItem]product];
    NSInteger ProductBasicNumber = 3;//[prod.Product_basicNumber integerValue] ;
    NSInteger ProductAddOnNumber = 2;//[prod.Product_addonNumber integerValue];
    if (currentCount >= ProductBasicNumber) {
        [[[CurrentOrderManager sharedManager]curOrderItem]setBasicCheck:YES];
        
        NSInteger IndexAfter = currentCount - ProductBasicNumber ;
        NSInteger divided = IndexAfter/ProductAddOnNumber ;
        if (IndexAfter % ProductAddOnNumber != 0) {
            divided++ ;
        }
        [[[CurrentOrderManager sharedManager]curOrderItem]setAddOns:divided];
    }
    else {
        [[[CurrentOrderManager sharedManager]curOrderItem]setBasicCheck:NO];
        [[[CurrentOrderManager sharedManager]curOrderItem]setAddOns:0];
    }

}

-(IBAction)DoneChoosingImages:(id)sender {
    BOOL BasicFlag = [[[CurrentOrderManager sharedManager]curOrderItem]BasicCheck];
    
    if (BasicFlag) {
        [self performSegueWithIdentifier:@"InstaToShowImages"
                                  sender:nil];
    } else {
        Product *myprod = [[[CurrentOrderManager sharedManager]curOrderItem]product];
        NSString *msgtext = [NSString stringWithFormat:@"Choosing this product, you should choose at least %@ photos in order to complete your order",myprod.Product_basicNumber];
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Not enough images" message:msgtext  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show] ;
    }
    //[self performSegueWithIdentifier:@"InstaToShowImages" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InstaToShowImages"]) {
        ShowImagesViewController *showimgs = [segue destinationViewController] ;
        [showimgs setImages:self.selectedImages];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [self collectionView].bounds.size.width / 3 - 1;
    return CGSizeMake(width, width);
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)tField
{
    if (tField.text.length) {
        [self searchMedia];
    }
    [tField resignFirstResponder];

    return YES;
}

@end
