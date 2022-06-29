//
//  PostCell.h
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Post.h"
#import "DateTools.h"

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

- (void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
