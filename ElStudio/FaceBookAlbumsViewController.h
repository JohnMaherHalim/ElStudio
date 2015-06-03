//
//  FaceBookAlbumsViewController.h
//  ElStudio
//
//  Created by John Maher on 6/2/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FaceBookAlbumsViewController : UIViewController <UICollectionViewDataSource>

@property (nonatomic,retain) NSString *AlbumId ;
@property (nonatomic ,retain) NSMutableArray *ImagesSources ;
@property (nonatomic,retain) NSMutableArray *selectedImages ;

@property(nonatomic ,retain) IBOutlet UICollectionView *collectionView ;

-(IBAction)DoneChoosingImages:(id)sender;

@end
