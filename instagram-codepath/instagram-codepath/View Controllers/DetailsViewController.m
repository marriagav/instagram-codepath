//
//  DetailsViewController.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/28/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Format the profile picture
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.borderWidth = 0;
    self.profilePicture.clipsToBounds=YES;
    [self _setUpLabels];
}

- (void)_setUpLabels {
    self.caption.text = self.post[@"caption"];
    self.postImage.file = self.post[@"image"];
    self.user = self.post[@"author"];
    self.username.text = self.user.username;
//    Date Formatting
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d HH:mm y";
    NSDate *date = self.post.createdAt;
    NSString *dateString = [formatter stringFromDate:date];
    self.date.text=dateString;
//    Load the image
    [self.postImage loadInBackground];
    //  Set the profile picture
    self.profilePicture.file = self.user[@"profileImage"];
    if (self.profilePicture.file){
        [self.profilePicture loadInBackground];
    }
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
