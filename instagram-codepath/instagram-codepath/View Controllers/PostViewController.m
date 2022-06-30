//
//  PostViewController.m
//  instagram-codepath
//
//  Created by Miguel Arriaga Velasco on 6/27/22.
//

#import "PostViewController.h"

@interface PostViewController ()  <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pictureGestureRecognizer:self.postImage];
    //    Format the typing area
    self.postCaption.layer.borderWidth = 0.5f;
    self.postCaption.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.postCaption.delegate=self;
}

- (void)didTapImage:(UITapGestureRecognizer *)sender{
//    Gets called when the user taps on the image placeholder, creating and opening an UIImagePickerController
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

- (void)textViewDidChange:(UITextView *)textView{
//    If the text changes the placeholder dissapears
    self.typeHere.hidden=(textView.text.length>0);
}

- (void)pictureGestureRecognizer:(UIImageView *)image{
    //Method to set up a tap gesture recognizer for an image
    UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImage:)];
    [image addGestureRecognizer:imageTapGestureRecognizer];
    [image setUserInteractionEnabled:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Resize the image
    UIImage *resizedImage = [Algos imageWithImage:editedImage scaledToWidth: 414];
    
    self.postImage.image = resizedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postImage:(id)sender {
//    Makes the call to post the image to the db
//    Shows progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    Dissables sharebutton so that the user cant spam it
    self.shareButton.enabled = false;
//    Makes call
    [Post postUserImage:self.postImage.image withCaption:self.postCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error){
                NSLog(@"%@", error);
            }
            else{
//                Calls the didPost method from the delegate and dissmisses the view controller
                [self.delegate didPost];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
//        hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    ];
}

@end
