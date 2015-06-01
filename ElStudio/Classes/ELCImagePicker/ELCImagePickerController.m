//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ELCConsole.h"
#import "CurrentOrderManager.h"

@implementation ELCImagePickerController

//Using auto synthesizers

- (id)initImagePicker
{
    ELCAlbumPickerController *albumPicker = [[ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    
    self = [super initWithRootViewController:albumPicker];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
        self.returnsOriginalImage = YES;
        [albumPicker setParent:self];
        self.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{

    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.maximumImagesCount = 4;
        self.returnsImage = YES;
    }
    return self;
}

- (ELCAlbumPickerController *)albumPicker
{
    return self.viewControllers[0];
}

- (void)setMediaTypes:(NSArray *)mediaTypes
{
    self.albumPicker.mediaTypes = mediaTypes;
}

- (NSArray *)mediaTypes
{
    return self.albumPicker.mediaTypes;
}

- (void)cancelImagePicker
{
	if ([_imagePickerDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_imagePickerDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

/*- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    BOOL shouldSelect = previousCount < self.maximumImagesCount;
    if (!shouldSelect) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Only %d photos please!", nil), self.maximumImagesCount];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You can only send %d photos at a time.", nil), self.maximumImagesCount];
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Okay", nil), nil] show];
    }
    return shouldSelect;
}*/

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
   /* BOOL CheckBasic = previousCount < self.ProductBasicNumber;
    BOOL CheckAddOn = previousCount % self.ProductAddOnNumber ;
    if (!CheckBasic) {
        NSUInteger hi = self.ProductBasicNumber + 1;
        if (previousCount == hi) {
            NSString *title = @"Warning" ;// [NSString stringWithFormat:NSLocalizedString(@"Only %d photos please!", nil), self.maximumImagesCount];
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You can only send %d photos at a time.", nil), self.maximumImagesCount];
            [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Okay", nil), nil] show];
        } else if (CheckAddOn == 0) {
            NSString *title = @"Warning" ;// [NSString stringWithFormat:NSLocalizedString(@"Only %d photos please!", nil), self.maximumImagesCount];
            NSString *message = @"You are about to cross the product Add-On" ;
            [[[UIAlertView alloc] initWithTitle:title
                                        message:message
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:NSLocalizedString(@"Okay", nil), nil] show];
        }
    }*/
    
    NSInteger currentCount = previousCount + 1;
    
    if (currentCount < self.ProductBasicNumber) {
        
    } else if (currentCount == self.ProductBasicNumber) {
        UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Basic" message:@"Done Basic" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [msg show];
    } else {

        NSInteger IndexAfter = currentCount - self.ProductBasicNumber ;
        
        /*if (IndexAfter > self.ProductAddOnNumber) {
            IndexAfter = IndexAfter % self.ProductAddOnNumber ;
        }
        
        if (IndexAfter == self.ProductAddOnNumber) {
            UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"AddOn" message:@"Done AddOn" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [msg show];
        }*/
        
        if (IndexAfter % self.ProductAddOnNumber == 0) {
            UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"AddOn" message:@"Done AddOn" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [msg show];
        }
        
        
        
        /* NSInteger checkAddOn = currentCount %  self.ProductAddOnNumber;
        if (checkAddOn == 0) {
            UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"AddOn" message:@"Done AddOn" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [msg show];
        }*/
    }
    
    if (currentCount >= self.ProductBasicNumber) {
        [[[CurrentOrderManager sharedManager]curOrderItem]setBasicCheck:YES];
        
        NSInteger IndexAfter = currentCount - self.ProductBasicNumber ;
        NSInteger divided = IndexAfter/self.ProductAddOnNumber ;
        if (IndexAfter % self.ProductAddOnNumber != 0) {
            divided++ ;
        }
        [[[CurrentOrderManager sharedManager]curOrderItem]setAddOns:divided];
    }
    else {
         [[[CurrentOrderManager sharedManager]curOrderItem]setBasicCheck:NO];
        [[[CurrentOrderManager sharedManager]curOrderItem]setAddOns:0];
    }
    
    
    return YES;
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount;
{
    return YES;
}

- (void)selectedAssets:(NSArray *)assets
{
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	
	for(ELCAsset *elcasset in assets) {
        ALAsset *asset = elcasset.asset;
		id obj = [asset valueForProperty:ALAssetPropertyType];
		if (!obj) {
			continue;
		}
		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
		
		CLLocation* wgs84Location = [asset valueForProperty:ALAssetPropertyLocation];
		if (wgs84Location) {
			[workingDictionary setObject:wgs84Location forKey:ALAssetPropertyLocation];
		}
        
        [workingDictionary setObject:obj forKey:UIImagePickerControllerMediaType];

        //This method returns nil for assets from a shared photo stream that are not yet available locally. If the asset becomes available in the future, an ALAssetsLibraryChangedNotification notification is posted.
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];

        if(assetRep != nil) {
            if (_returnsImage) {
                CGImageRef imgRef = nil;
                //defaultRepresentation returns image as it appears in photo picker, rotated and sized,
                //so use UIImageOrientationUp when creating our image below.
                UIImageOrientation orientation = UIImageOrientationUp;
            
                if (_returnsOriginalImage) {
                    imgRef = [assetRep fullResolutionImage];
                    orientation = [assetRep orientation];
                } else {
                    imgRef = [assetRep fullScreenImage];
                }
                UIImage *img = [UIImage imageWithCGImage:imgRef
                                                   scale:1.0f
                                             orientation:orientation];
                [workingDictionary setObject:img forKey:UIImagePickerControllerOriginalImage];
            }

            [workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:UIImagePickerControllerReferenceURL];
            
            [returnArray addObject:workingDictionary];
        }
		
	}    
	if (_imagePickerDelegate != nil && [_imagePickerDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[_imagePickerDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:returnArray];
	} else {
        [self popToRootViewControllerAnimated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

- (BOOL)onOrder
{
    return [[ELCConsole mainConsole] onOrder];
}

- (void)setOnOrder:(BOOL)onOrder
{
    [[ELCConsole mainConsole] setOnOrder:onOrder];
}

@end
