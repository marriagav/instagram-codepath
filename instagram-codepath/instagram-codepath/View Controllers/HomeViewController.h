//
//  HomeViewController.h
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/27/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "PostViewController.h"
#import "InfiniteScrollActivityView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (assign, nonatomic) BOOL isMoreDataLoading;
- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
