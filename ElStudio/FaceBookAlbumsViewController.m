//
//  FaceBookAlbumsViewController.m
//  ElStudio
//
//  Created by John Maher on 6/2/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "FaceBookAlbumsViewController.h"
#import "IKCell.h"
#import "UIImageView+AFNetworking.h"
#import "CurrentOrderManager.h"
#import "ShowImagesViewController.h"


@interface FaceBookAlbumsViewController ()

@end

@implementation FaceBookAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ImagesSources = [[NSMutableArray alloc]init];
    self.selectedImages = [[NSMutableArray alloc]init];
    [self.collectionView setAllowsMultipleSelection:YES] ;
    
    NSString *CertainAlbum = [NSString stringWithFormat:@"/%@/photos",self.AlbumId];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:CertainAlbum parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             NSArray *albums = [result objectForKey:@"data"];
             for (NSDictionary *dict in albums) {
                 
                 NSLog(@"first %@",dict);
                 
                 [self.ImagesSources addObject:[dict objectForKey:@"source"]];
                 
             }

             [self.collectionView reloadData];
             NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
         }
     }];


    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.ImagesSources count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    
    if (self.ImagesSources.count >= indexPath.row+1) {
        /*InstagramMedia *media = mediaArray[indexPath.row];
        [cell.imageView setImageWithURL:media.thumbnailURL];*/
        NSString *imageURLstring = [self.ImagesSources objectAtIndex:indexPath.row];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageURLstring] ];
        
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
    
    //InstagramMedia *media = mediaArray[indexPath.row];
    NSString *imagelinkstring = [self.ImagesSources objectAtIndex:indexPath.row];
    NSURL *imagelink = [NSURL URLWithString:imagelinkstring];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imagelink]];
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
    NSString *imagelinkstring = [self.ImagesSources objectAtIndex:indexPath.row];
    NSURL *imagelink = [NSURL URLWithString:imagelinkstring];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imagelink]];
   // [self.selectedImages addObject:image];
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

-(IBAction)DoneChoosingImages:(id)sender {
    BOOL BasicFlag = [[[CurrentOrderManager sharedManager]curOrderItem]BasicCheck];
    
    if (BasicFlag) {
        [self performSegueWithIdentifier:@"FromFaceBookToShowImages"
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
    if ([segue.identifier isEqualToString:@"FromFaceBookToShowImages"]) {
        ShowImagesViewController *showimgs = [segue destinationViewController] ;
        [showimgs setImages:self.selectedImages];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
