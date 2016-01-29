//
//  FourthScreenTableViewController.m
//  网络教学平台
//
//  Created by tarena on 15/12/29.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "FourthScreenTableViewController.h"
//#import "LoginViewController.h"
#import "XMPPvCardTemp.h"
#import "XYXMPPTool.h"
#import "XYUserInfo.h"
#import "XYEditMyProfileViewController.h"
//#import "UIImageView+KRRoundImage.h"

@interface FourthScreenTableViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@end

@implementation FourthScreenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myProfile = [XYXMPPTool sharedXYXMPPTool].xmppvCard.myvCardTemp;
    if (self.myProfile.photo) {
        self.headImageView.image = [UIImage imageWithData:self.myProfile.photo];
    }else {
        self.headImageView.image = [UIImage imageNamed:@"微博"];
    }
//    [self.headImageView setRoundLater];
//    self.userNameLabel.text = [XYUserinfo sharedXYUserinfo].userName;
    self.userNickNameLabel.text = self.myProfile.nickname;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[XYEditMyProfileViewController class]]) {
        XYEditMyProfileViewController *editVc = (XYEditMyProfileViewController *)destVc;
        editVc.myProfile = [XYXMPPTool sharedXYXMPPTool].xmppvCard.myvCardTemp;
    }
}























@end
