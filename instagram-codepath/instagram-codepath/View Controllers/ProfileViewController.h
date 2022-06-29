//
//  ProfileViewController.h
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/29/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "InfiniteScrollActivityView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) PFUser *user;

- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
