//
//  DetailLifeCircleViewController.m
//  GKHelpOutApp
//
//  Created by kky on 2019/4/23.
//  Copyright © 2019年 kky. All rights reserved.
//

#import "DetailLifeCircleViewController.h"
#import "LifeCircleViewController.h"
#import "TLMoment.h"
#import "DetailLifeCircleCell.h"
#import "TLDetailCircleHeaderCell.h"
#import "LifeDetailCircleLogic.h"
#import "XHInputView.h"
#import <IQKeyboardManager.h>

@interface DetailLifeCircleViewController ()<UITableViewDelegate,UITableViewDataSource,XHInputViewDelagete>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *shareButton;
@property(nonatomic,strong)UIButton *commentButton;
@property(nonatomic,strong)UIButton *likeButton;
@property(nonatomic,strong)LifeDetailCircleLogic *logic;


@end

@implementation DetailLifeCircleViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logic = [[LifeDetailCircleLogic alloc] init];
    TLMoment *monent = _datalist[0];
    self.logic.circleoffriendsId = monent.id;
    self.title = @"朋友圈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self stepUI];
    [self stepData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
#pragma mark - Delegate
//MARK:UITableViewDelegate&UITableViewSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailLifeCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailLifeCircleCell"];
    cell.moment = _datalist[0];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TLDetailCircleHeaderCell *headView = [[TLDetailCircleHeaderCell alloc] init];
    headView.moment = _datalist[0];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    TLMoment *monent = _datalist[0];
    return monent.detail.detailFrame.height+120; //84
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLMoment *monent = _datalist[0];
    return monent.detail.detailFrame.heightText+75;
}

#pragma mark - Private Methods
- (void)stepData {
    [self.logic requestLifeCircleDetailCompleted:^(id data) {
        
    } failed:^(NSError *error) {
        
    }];
}
- (void)stepUI{
    
    @weakify(self);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-14);
        make.top.mas_equalTo(-20);
    }];
    [self.tableView registerClass:[DetailLifeCircleCell class] forCellReuseIdentifier:@"DetailLifeCircleCell"];
    
    self.bottomView = self.view.addView(100).backgroundColor(UIColorFromRGB(233, 233, 233)).masonry(^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.bottom.right.mas_equalTo(self.view);
    })
    .view;
    
    UIView *line1 = self.bottomView.addView(101).backgroundColor(UIColorFromRGB(153, 153, 153))
    .masonry(^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(KScreenWidth/3);
    })
    .view;
    
    UIView *line2 = self.bottomView.addView(101).backgroundColor(UIColorFromRGB(153, 153, 153))
    .masonry(^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo((KScreenWidth/3)*2);
    })
    .view;
    
    self.shareButton = self.bottomView.addButton(102).image(IMAGE_NAMED(@"分享icon")).title(@"分享")
    .titleColor(CFontColor4).titleFont(FontOfSize(12)).titleEdgeInsets(UIEdgeInsetsMake(0,10, 0, 0))
    .masonry(^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(((KScreenWidth/3)-60)/2);
    })
    .view;
    
    self.commentButton = self.bottomView.addButton(103).image(IMAGE_NAMED(@"评论icon")).title(@"评论")
    .titleColor(CFontColor4).titleFont(FontOfSize(12)).titleEdgeInsets(UIEdgeInsetsMake(0,10, 0, 0)).eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
        @strongify(self);
        [self clickComment];
    })
    .masonry(^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(self.bottomView);

    })
    .view;
    
    self.likeButton = self.bottomView.addButton(104)
    .image(IMAGE_NAMED(@"未点赞icon"))
    .title(@"23")
    .titleColor(CFontColor4)
    .titleFont(FontOfSize(12))
    .titleEdgeInsets(UIEdgeInsetsMake(0,10, 0, 0))
    .eventBlock(UIControlEventTouchUpInside, ^(UIButton *sender) {
        @strongify(self);
        [self postPraiseData];
    })
    .masonry(^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-((KScreenWidth/3)-60)/2);
    })
    .view;
}
#pragma mark - TouchEvent
//评论
-(void)postCommentData:(NSString *)content{
    self.logic.content = content;
    [self.logic requestLifeCircleDetailCommentCompleted:^(id data) {
        
    } failed:^(NSError *error) {
        
    }];
}
//点赞
-(void)postPraiseData{
    [self.logic requestLifeCircleDetailPraiseCompleted:^(id data) {
        
    } failed:^(NSError *error) {
        
    }];
}

-(void)clickComment{
    [self showXHInputViewWithStyle:InputViewStyleDefault];
}

-(void)showXHInputViewWithStyle:(InputViewStyle)style{
    
    [XHInputView showWithStyle:style configurationBlock:^(XHInputView *inputView) {

        inputView.delegate = self;
        inputView.placeholder = @"千头万绪,落笔评论一句...";
        inputView.maxCount = 100;
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {
        if(text.length){
            NSLog(@"输入的信息为:%@",text);
//            _textLab.text = text;
            [self postCommentData:text];
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-请输入要评论的的内容");
            [PSTipsView showTips:@"请输入要评论的的内容"];
            return NO;//return NO,不收键盘
        }
    }];
    
}

#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    
}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
    /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark - Setting&Getting
- (UITableView *)tableView {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.tableFooterView = [UIView new];
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}
    

@end
