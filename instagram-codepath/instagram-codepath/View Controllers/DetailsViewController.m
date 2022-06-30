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
    [Algos formatPictureWithRoundedEdges: self.profilePicture];
    [self _setUpLabels];
}

- (void)_setUpLabels {
    self.caption.text = self.post[@"caption"];
    self.postImage.file = self.post[@"image"];
    self.user = self.post[@"author"];
    self.username.text = self.user.username;
//    Date Formatting
    self.date.text = [Algos dateToString:self.post.createdAt];
//    Load the image
    [self.postImage loadInBackground];
    //  Set the profile picture
    self.profilePicture.file = self.user[@"profileImage"];
    if (self.profilePicture.file){
        [self.profilePicture loadInBackground];
    }
}

@end
