//
//  NTESContactAddFriendViewController.m
//  NIM
//
//  Created by chris on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESContactAddFriendViewController.h"
#import "NIMCommonTableDelegate.h"
#import "NIMCommonTableData.h"
#import "UIView+Toast.h"

#import "NTESPersonalCardViewController.h"
#import "NTESAddFriendsMessageViewController.h"

#import "PSPersonCardViewController.h"

@interface NTESContactAddFriendViewController ()

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,assign) NSInteger               inputLimit;


@end

@implementation NTESContactAddFriendViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
   
    __weak typeof(self) wself = self;
    [self buildData];
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
}


- (void)buildData{
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title         : @"请输入手机号码",
                                      CellClass     : @"NTESTextSettingCell",
                                      RowHeight     : @(44),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *phone = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (phone.length) {
        phone= [phone lowercaseString];
       // [self IMaddFriend:phone];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *phone = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (phone.length) {
        phone= [phone lowercaseString];
        [self IMaddFriend:phone];
    }
}

-(void)IMaddFriend:(NSString*)phone{
    NSString*url=[NSString stringWithFormat:@"%@%@?phoneNumber=%@",ChatServerUrl,URL_get_im_customerInfo,phone];
    NSString *access_token =help_userManager.oathInfo.access_token;
    NSString *token = NSStringFormat(@"Bearer %@",access_token);
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        if (ValidDict(responseObject)) {
            NSString *userId = [responseObject[@"account"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString*nickName=responseObject[@"nickname"];
            NSString*avatar=responseObject[@"avatar"];
            NSString*curUserName=responseObject[@"curUserName"];
            if (userId.length) {
                userId = [userId lowercaseString];
                [self addFriendWithUserID:userId withPhone:phone withNickName:nickName withAvatar:avatar withCurUserName:curUserName];
            }
        } else {
            [PSAlertView showWithTitle:@"该用户不存在" message:@"请检查你输入的手机号码是否正确" messageAlignment:NSTextAlignmentCenter image:nil handler:^(PSAlertView *alertView, NSInteger buttonIndex) {
                
            } buttonTitles:@"确定", nil];
        }
    } failure:^(NSError *error) {
        [PSAlertView showWithTitle:@"该用户不存在" message:@"请检查你输入的手机号码是否正确" messageAlignment:NSTextAlignmentCenter image:nil handler:^(PSAlertView *alertView, NSInteger buttonIndex) {
            
        } buttonTitles:@"确定", nil];

    }];
}



#pragma mark - Private
- (void)addFriendWithUserID:(NSString *)userId withPhone:(NSString*)phone withNickName:(NSString*)nickName withAvatar:(NSString*)avatar withCurUserName:(NSString*)curUserName{
    __weak typeof(self) wself = self;
    [[PSLoadingView sharedInstance] show];
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
        [[PSLoadingView sharedInstance]dismiss];
        if (users.count) {
//            NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:userId withPhone:phone];
//            [wself.navigationController pushViewController:vc animated:YES];
            PSPersonCardViewController*vc=[[PSPersonCardViewController alloc]initWithUserId:userId withPhone:phone withNickName:nickName withAvatar:avatar withCurUserName:curUserName];
            [wself.navigationController pushViewController:vc animated:YES];

        }else{
            if (wself) {
                [PSAlertView showWithTitle:@"该用户不存在" message:@"请检查你输入的手机号码是否正确" messageAlignment:NSTextAlignmentCenter image:nil handler:^(PSAlertView *alertView, NSInteger buttonIndex) {
                    
                } buttonTitles:@"确定", nil];
            }
        }
    }];
}


@end
