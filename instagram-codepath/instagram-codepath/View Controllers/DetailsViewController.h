//
//  DetailsViewController.h
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@end

NS_ASSUME_NONNULL_END
