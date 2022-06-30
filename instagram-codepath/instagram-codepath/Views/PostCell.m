//
//  PostCell.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/27/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
    [self _pictureGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)setPost:(Post *)post {
//    Setter for the post
    _post = post;
    self.postCaption.text = post[@"caption"];
    self.postImage.file = post[@"image"];
    self.user = post[@"author"];
    self.username.text = self.user.username;
    self.date.text = self.post.createdAt.shortTimeAgoSinceNow;
    [self.postImage loadInBackground];
    if (self.user[@"profileImage"]){
        self.profilePicture.file = self.user[@"profileImage"];
        [self.profilePicture loadInBackground];
    }
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
//    Gets called when the user taps on the user profile
    [self.delegate postCell:self didTap:self.user];
}

- (void)_pictureGestureRecognizer{
//    Method to set up a tap gesture recognizer for the profile picture
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:YES];
}

@end
