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
};

@end
