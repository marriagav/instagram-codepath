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
    [self _setUpLabels];
}

- (void)_setUpLabels {
    self.caption.text = self.post[@"caption"];
    self.postImage.file = self.post[@"image"];
    self.user = self.post[@"author"];
    self.username.text = self.user.username;
    [self.postImage loadInBackground];
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
