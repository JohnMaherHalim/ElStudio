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


@interface FaceBookAlbumsViewController ()

@end

@implementation FaceBookAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ImagesSources = [[NSMutableArray alloc]init];
    
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
