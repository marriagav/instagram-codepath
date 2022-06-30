//
//  ProfileViewController.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/29/22.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ProfileViewController

bool _isMoreDataLoadingP = false;
InfiniteScrollActivityView* _loadingMoreViewP;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set delegate and datasource of the tableview to self
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
//    Case when the profile view is accessed through the nav bar
    if (self.user == nil){
        self.user = PFUser.currentUser;
//        Can only change the profile picture if accessed throgh the nav bar
        [self _pictureGestureRecognizer];
    }
//    Fill tableview and set outlets
    [self refreshDataWithNPosts:20];
    [self setOutlets];
    // Initialize a UIRefreshControlBottom
    [self _initializeRefreshControlB];
}

- (void)setOutlets{
//    Set the outlets for the profile
    self.username.text = self.user.username;
//  Set the profile picture
    self.profileImage.file = self.user[@"profileImage"];
    if (self.profileImage.file){
        [self.profileImage loadInBackground];
    }
//    Format the profile picture
    [Algos formatPictureWithRoundedEdges:self.profileImage];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.postArray count]){
        [self loadMoreData];
    }
}

- (void)didTapImage:(UITapGestureRecognizer *)sender{
//    Creates and opens an UIImagePickerController when the user taps the user image
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Resize the image
    UIImage *resizedImage = [Algos imageWithImage:editedImage scaledToWidth: 414];
    
    self.profileImage.image = resizedImage;
    [self changeProfilePicture];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeProfilePicture{
//    Call to change the profile picture in the DB
    [self.user setObject:[Algos getPFFileFromImage:self.profileImage.image] forKey: @"profileImage"];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            [self refreshDataWithNPosts:20];
        }
    }];
}

- (void)_pictureGestureRecognizer{
//    Method to set up a tap gesture recognizer for the profile picture
    UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImage:)];
    [self.profileImage addGestureRecognizer:imageTapGestureRecognizer];
    [self.profileImage setUserInteractionEnabled:YES];
}

- (void)refreshDataWithNPosts:(int) numberOfPosts{
//    Updates tableview with numberOfPosts posts
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo: self.user];
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

- (void)_initializeRefreshControlB{
//    Initialices and inserts the refresh control
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    _loadingMoreViewP = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreViewP.hidden = true;
    [self.tableView addSubview:_loadingMoreViewP];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    Infinite scrolling
    if(!_isMoreDataLoadingP){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            _isMoreDataLoadingP = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            _loadingMoreViewP.frame = frame;
            [_loadingMoreViewP startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
    }
}

- (void)loadMoreData{
//    Add 20 more posts to tableview for infinite scrolling
    int postsToAdd = (int)[self.postArray count] + 20;
    [self refreshDataWithNPosts: postsToAdd];
    [_loadingMoreViewP stopAnimating];
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
//    get the post and assign it to the cell
    Post *post = self.postArray[indexPath.row];
    cell.post=post;
    return cell;
}

@end
