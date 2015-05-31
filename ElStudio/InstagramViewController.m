//
//  InstagramViewController.m
//  ElStudio
//
//  Created by John Maher on 5/31/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "InstagramViewController.h"

@interface InstagramViewController ()

@end

@implementation InstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)InstagramLogin:(id)sender {
    
    InstagramEngine *engine = [InstagramEngine sharedEngine];
    [engine getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        // media is an array of InstagramMedia objects
        InstagramMedia *img = [media objectAtIndex:0] ;
      //  [self.imageView setImage:img.]
        NSLog(@"Success") ;
    } failure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Failure") ;
    }];
    
  /*  IKLoginScope scope = IKLoginScopeRelationships | IKLoginScopeComments | IKLoginScopeLikes;
    
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizarionURLForScope:scope];
    NSLog(@"%@",authURL);
    [self.mWebView loadRequest:[NSURLRequest requestWithURL:authURL]];*/
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
