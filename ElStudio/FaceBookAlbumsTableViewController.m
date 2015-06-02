//
//  FaceBookAlbumsTableViewController.m
//  ElStudio
//
//  Created by John Maher on 6/2/15.
//  Copyright (c) 2015 John Maher. All rights reserved.
//

#import "FaceBookAlbumsTableViewController.h"
#import "FaceBookAlbumsViewController.h"

@interface FaceBookAlbumsTableViewController ()

@end

@implementation FaceBookAlbumsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Albums = [[NSMutableArray alloc]init];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/albums" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
           //  NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
             NSArray *albums = [result objectForKey:@"data"];
             for (NSDictionary *dict in albums) {
                 FaceBookAlbum *album = [[FaceBookAlbum alloc]init] ;
                 
                 NSString *albumid = [dict objectForKey:@"id"];
                 
                 [album setAlbumId:albumid];
                 [album setAlbumName:[dict objectForKey:@"name" ]];
                 [self.Albums addObject:album] ;
                 
                 NSLog(@"first %@",dict);
                 
             }
             
             [self.tableView reloadData]; 
         }
     }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.Albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FaceBookAlbum *album = [self.Albums objectAtIndex:indexPath.row] ;
    
    [cell.textLabel setText:album.AlbumName];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FaceBookAlbum *album = [self.Albums objectAtIndex:indexPath.row] ;
    globalAlbum = album.AlbumId ;
    [self performSegueWithIdentifier: @"GoToFaceBookAlbum" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToFaceBookAlbum"]){
        FaceBookAlbumsViewController *fbalbum = [segue destinationViewController];
        [fbalbum setAlbumId:globalAlbum]; 
    }
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
