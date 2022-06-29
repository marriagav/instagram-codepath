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
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.borderWidth = 0;
    self.profilePicture.clipsToBounds=YES;
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
    self.profilePicture.file = self.user[@"profileImage"];
    self.date.text = self.post.createdAt.shortTimeAgoSinceNow;
    [self.postImage loadInBackground];
    if (self.profilePicture.file){
        [self.profilePicture loadInBackground];
    }
};

@end
