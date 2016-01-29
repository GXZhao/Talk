//
//  XYEditMyProfileViewController.m
//  网络教育平台
//
//  Created by tarena on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "XYEditMyProfileViewController.h"
#import "XYXMPPTool.h"
#import "XYUserinfo.h"


@interface XYEditMyProfileViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *userNickNameLabel;

@end

@implementation XYEditMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.myProfile.photo) {
        self.headImage.image = [UIImage imageWithData:self.myProfile.photo];
    } else {
        self.headImage.image = [UIImage imageNamed:@"微信"];
    }
    self.userNickNameLabel.text = self.myProfile.nickname;
    self.headImage.userInteractionEnabled = YES;
    [self.headImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap)]];
}

- (void) headImageTap {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];

}

#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        MYLog(@"取消");
    }else if (buttonIndex == 1) {
        MYLog(@"相册");
        UIImagePickerController *pc = [[UIImagePickerController alloc]init];
        pc.allowsEditing = YES;
        pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pc.delegate = self;
        [self presentViewController:pc animated:YES completion:nil];
    }else {
        MYLog(@"相机");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pc = [[UIImagePickerController alloc]init];
            pc.allowsEditing = YES;
            pc.sourceType = UIImagePickerControllerSourceTypeCamera;
            pc.delegate = self;
            [self presentViewController:pc animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headImage.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sureBtn:(id)sender {
    self.myProfile.photo = UIImagePNGRepresentation(self.headImage.image);
    self.myProfile.nickname = self.userNickNameLabel.text;
    [[XYXMPPTool sharedXYXMPPTool].xmppvCard updateMyvCardTemp:self.myProfile];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)notSureBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//退出登录
- (IBAction)logout:(id)sender {
    [[XYUserinfo sharedXYUserinfo] saveXYUserInfoToSandBox];
    [[XYXMPPTool sharedXYXMPPTool] sendOffLine];
    [XYUserinfo sharedXYUserinfo].jidStr = nil;
    if ([XYUserinfo sharedXYUserinfo].sinaLogin) {
        [XYUserinfo sharedXYUserinfo].sinaLogin = NO;
        [XYUserinfo sharedXYUserinfo].userName = nil;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    UIViewController *vc = storyboard.instantiateInitialViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

}
@end
