//
//  HomeViewController.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/27/22.
//

#import "HomeViewController.h"

@interface HomeViewController () <PostViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, PostCellDelegate>

@end

@implementation HomeViewController

bool _isMoreDataLoading = false;
InfiniteScrollActivityView* _loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //  Initiallize delegate and datasource of the tableview to self
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self refreshDataWithNPosts:20];
    // Initialize a UIRefreshControl
    [self _initializeRefreshControl];
    // Initialize a UIRefreshControlBottom
    [self _initializeRefreshControlB];
}

- (IBAction)logOutClick:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (error){
            NSLog(@"%@", error);
        }
        else{
            [self performSegueWithIdentifier:@"logoutSegue" sender:nil];
        }
    }];
}

- (void)refreshDataWithNPosts:(int) numberOfPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = numberOfPosts;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)_beginRefresh:(UIRefreshControl *)refreshControl {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postArray = (NSMutableArray *) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [refreshControl endRefreshing];
    }];
}


- (void)_initializeRefreshControl{
//    Initialices and inserts the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(_beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)_initializeRefreshControlB{
//    Initialices and inserts the refresh control
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    _loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreView.hidden = true;
    [self.tableView addSubview:_loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section{
//    return amount of tweets in the tweetArray
        return self.postArray.count;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath{
//    initialize cell (PostCell) to a reusable cell using the PostCell identifier
    PostCell *cell = [tableView
    dequeueReusableCellWithIdentifier: @"PostCell"];
//    get the tweet and assign it to the cell
    Post *post = self.postArray[indexPath.row];
    cell.post=post;
    cell.delegate = self;
    return cell;
}

- (void)didPost{
//    Gets called when the user presses the "tweet" button on the "ComposeViewController" view, this controller functions as a delegate of the former
    [self refreshDataWithNPosts:(int)self.postArray.count+1];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.postArray count]){
        [self loadMoreData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoading){
            // Calculate the position of one screen length before the bottom of the results
            int scrollViewContentHeight = self.tableView.contentSize.height;
            int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
                _isMoreDataLoading = true;
                
                // Update position of loadingMoreView, and start loading indicator
                CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
                _loadingMoreView.frame = frame;
                [_loadingMoreView startAnimating];
                
                // Code to load more results
                [self loadMoreData];
            }
    }
}

- (void)loadMoreData{
    int postsToAdd = (int)[self.postArray count] + 20;
    [self refreshDataWithNPosts: postsToAdd];
    [_loadingMoreView stopAnimating];
}

- (void)postCell:(PostCell *)postCell didTap:(PFUser *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *key = segue.identifier;

    void (^selectedCase)(void) = @{
        @"detailsSegue" : ^{
            //        Case when the segue is to the DetailsViewController (tweet cell is pressed)
            NSIndexPath *myIndexPath=self.tableView.indexPathForSelectedRow;
            //        The tweet will be passed through the segue
            Post *postToPass = self.postArray[myIndexPath.row];
            UINavigationController *navigationController = [segue destinationViewController];
            DetailsViewController *detailVC = (DetailsViewController*)navigationController.topViewController;
            detailVC.post = postToPass;
        },
        @"composePost" : ^{
    //        Case when the segue is to the ComposeViewController (post tweet button is pressed)
            UINavigationController *navigationController = [segue destinationViewController];
            PostViewController *composeController = (PostViewController*)navigationController.topViewController;
            //        Assign delegate of the destination vc
            composeController.delegate = self;
        },
        @"profileSegue" : ^{
    //        Case when the segue is to the profile view (profile picture is pressed)
            UINavigationController *navigationController = [segue destinationViewController];
            ProfileViewController *profileVC = (ProfileViewController*)navigationController.topViewController;
            PFUser *userToPass = sender;
            profileVC.user = userToPass;
        },
    }[key];

    if (selectedCase != nil)
        selectedCase();
    
}

@end
