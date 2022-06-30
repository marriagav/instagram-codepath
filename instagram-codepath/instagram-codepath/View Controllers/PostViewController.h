//
//  PostViewController.h
//  instagram-codepath
//  The view controller of the post view 
//  Created by Miguel Arriaga Velasco on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Algos.h"
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostViewControllerDelegate

- (void)didPost;

@end

@interface PostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postCaption;
@property (nonatomic, weak) id<PostViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *typeHere;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

NS_ASSUME_NONNULL_END
