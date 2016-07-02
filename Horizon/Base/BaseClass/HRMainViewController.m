//
//  HRMainViewController.m
//  Horizon
//
//  Created by Hiro on 16/5/30.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRMainViewController.h"
#import "HRDiscoverViewController.h"
#import "HRCardManager.h"
#import "HREveryDayModel.h"
#import "HREveryDayTableViewCell.h"
#import "HRContentScrollView.h"
#import "HRContentView.h"
#import "HRrilegouleView.h"
#import "HRCustomView.h"
#import "HRImageContentView.h"
#import "KRVideoPlayerController.h"
#import "UIBarButtonItem+HRExtension.h"
//刷新
#import "CBStoreHouseRefreshControl.h"
#import "LrdOutputView.h"

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "LBClearCacheTool.h"
#import "LCLoadingHUD.h"
#define filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@interface SDWebImageManager  (cache)
- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url;
@end

@implementation SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return ([self.imageCache imageFromMemoryCacheForKey:key] != nil) ?  YES : NO;
}

@end

@interface HRMainViewController ()<LrdOutputViewDelegate,UITableViewDataSource,UITableViewDelegate>{
   UITableView *_tableView;
    int flag;
}
@property(nonatomic,retain)NSMutableDictionary *selectDic;

@property(nonatomic,retain)NSMutableArray *dateArray;

@property(nonatomic,strong) KRVideoPlayerController *videoController;

/**刷新*/
@property (nonatomic,strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;


//nav

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) LrdOutputView *outputView;

@property(nonatomic,strong)HRCardManager *transitionManager;

@end

@implementation HRMainViewController
#pragma mark ---------- 数据加载 -----------
//懒加载
- (NSMutableDictionary *)selectDic{
    
    if (!_selectDic) {
        
        _selectDic = [[NSMutableDictionary alloc]init];
        
    }
    return _selectDic;
}

- (NSMutableArray *)dateArray{
    
    if (!_dateArray) {
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}
//navigation button点击数组加载

#pragma mark ----------视频播放器-----------
- (KRVideoPlayerController *)videoController {
    
    if (_videoController == nil) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        
        
    }
    
    return _videoController;
}

- (void)jsonSelection{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *date = [NSDate date];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *url = [NSString stringWithFormat:kEveryDay,dateString];
    
    [LORequestManger GET:url success:^(id response) {
        
        NSDictionary *Dic = (NSDictionary *)response;
        
        NSArray *array = Dic[@"dailyList"];
        
        for (NSDictionary *dic in array) {
            
            NSMutableArray *selectArray = [NSMutableArray array];
            
            NSArray *arr = dic[@"videoList"];
            NSMutableArray *arrayResult  = [[NSMutableArray alloc]init];
            for (NSDictionary *dic2 in arr) {
                if (![[dic2 objectForKey:@"category"]isEqualToString:@"动画"]) {
                    [arrayResult addObject:dic2];
                }
            }
            for (NSDictionary *dic1 in arrayResult) {
                
                HREveryDayModel *model = [[HREveryDayModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic1];
                
                model.collectionCount = dic1[@"consumption"][@"collectionCount"];
                model.replyCount = dic1[@"consumption"][@"replyCount"];
                model.shareCount = dic1[@"consumption"][@"shareCount"];
                
                [selectArray addObject:model];
            }
            NSString *date = [[dic[@"date"] stringValue] substringToIndex:10];
            
            [self.selectDic setValue:selectArray forKey:date];
        }
        
        NSComparisonResult (^priceBlock)(NSString *, NSString *) = ^(NSString *string1, NSString *string2){
            
            NSInteger number1 = [string1 integerValue];
            NSInteger number2 = [string2 integerValue];
            
            if (number1 > number2) {
                return NSOrderedAscending;
            }else if(number1 < number2){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
            
        };
        
        self.dateArray = [[[self.selectDic allKeys] sortedArrayUsingComparator:priceBlock]mutableCopy];
        
        NSLog(@"%ld",[self.dateArray count]);
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark ----------------- 加载页面 ----------------


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"每日·精选";
    [self setnavigationBar];
    flag =0;
    
    //刷新
    _storeHouseRefreshControl =[[CBStoreHouseRefreshControl alloc]init];
    [self slidedownRefresh];
    //tableview
    [self setTableView];
    
    //数据请求
    [self jsonSelection];
    
    [_tableView registerClass:[HREveryDayTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    [self sendNoti];
}

- (void)dismissKeyHUD {
    
    [LCLoadingHUD hideInKeyWindow];
}
- (void)sendNoti {
  
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {//判断系统是否支持本地通知
       
        notification.fireDate = [NSDate dateWithTimeIntervalSince1970:12*60*60];//本次开启立即执行的周期
        
        notification.repeatInterval=kCFCalendarUnitWeekday;//循环通知的周期
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=@"🈶新内容了，快来看看吧";//弹出的提示信息
        notification.applicationIconBadgeNumber=0; //应用程序的右上角小数字
        notification.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音
        notification.hasAction = NO;
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
        
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    [self.videoController dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -----------------下拉刷新----------------
-(void)slidedownRefresh {
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:_tableView target:self refreshAction:@selector(refreshTriggered) plist:@"storehouse"];
}

- (void)refreshTriggered
{
    [self jsonSelection];
    [self.storeHouseRefreshControl finishingLoading];
    [_tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark -------rightnavigationBar-----------------
-(void)setnavigationBar {
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImag:@"MainTagSubIconClick" target:self action:@selector(rightTagButtonClick)];
    self.navigationItem.leftBarButtonItem =[UIBarButtonItem itemWithImage:@"contenttoolbar_hd_back" highImag:@"contenttoolbar_hd_back_light" target:self action:@selector(leftTagButtonClick)];
    //nav
 
    LrdCellModel *one = [[LrdCellModel alloc] initWithTitle:@"清除缓存" imageName:@"item_clean"];
    LrdCellModel *two = [[LrdCellModel alloc] initWithTitle:@"分享" imageName:@"item_share"];
    LrdCellModel *three = [[LrdCellModel alloc] initWithTitle:@"关于" imageName:@"item_about"];
    LrdCellModel *four = [[LrdCellModel alloc] initWithTitle:@"声明" imageName:@"item_protest"];
    
    self.dataArr = @[one, two, three,four];

}
-(void)leftTagButtonClick {
    if (flag == 0) {
        //第一次判断
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
            
            [LCLoadingHUD showLoading:@"从屏幕左边缘向右滑动试试"];
            //
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(toSecondView) userInfo:nil repeats:NO];
        }else{
            HRDiscoverViewController *disVC =[[HRDiscoverViewController alloc]init];
            [self presentViewController:disVC animated:YES completion:nil];
        }
        
        
    }else{
    
            [_rilegoule removeFromSuperview];
            flag=0;
        
        
    }
    
     }
-(void)toSecondView{
    HRDiscoverViewController *disVC =[[HRDiscoverViewController alloc]init];
    [self presentViewController:disVC animated:YES completion:nil];
    [self dismissKeyHUD];
}
-(void)rightTagButtonClick {
    
    CGFloat x =_tableView.width-10;
    CGFloat y = 64;
    _outputView = [[LrdOutputView alloc] initWithDataArray:self.dataArr origin:CGPointMake(x, y) width:125 height:44 direction:kLrdOutputViewDirectionRight];
    
    _outputView.delegate = self;
    _outputView.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        _outputView = nil;
    };
    [_outputView pop];
    
}
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
               NSString *fileSize = [LBClearCacheTool getCacheSizeWithFilePath:filePath];
            //清除缓存
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否清除缓存(%@)？",fileSize] delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确定", nil];
            alertView.tag = 1011;
            [alertView show];
        }
            break;
        case 1:
        {
           [self shareMethod];
        }
            break;
        case 2:
        {
            [self alertMessageWithTitle:@"关于Horizon Video" Message:@"V1.0 Copyright © Hiro"];
        }
            break;
        case 3:
        {
            [self alertMessageWithTitle:@"声明" Message:@"Horizon Video所提供的视频内容均来自第三方网站，视频内容所有版权归视频作者和第三方网站所有，Horizon Video不对其承担任何法律责任。"];
        }
            break;
        default:
            break;
    }

    
}
#pragma mark - 清理缓存
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && alertView.tag == 1011) {
        [self clearCache];
        
    }
}

-(void) clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)
                                              withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"缓存清理成功！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}


-(void)alertMessageWithTitle:(NSString*)title Message:(NSString*)message{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //创建一个action
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -分享
-(void)shareMethod {
   
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"Share image.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"快到App Store下载Horizon Video吧!"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}


#pragma mark - TableView
-(void)setTableView {
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.contentInset =UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    _tableView.delegate=self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.dateArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.selectDic[self.dateArray[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HREveryDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

// 头标题

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 20.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = YES;
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake((self.view.frame.size.width-90)/2, 0.0, 100.0, 20.0);
    
  NSString *string = self.dateArray[section];
    long long int date1 = (long long int)[string intValue];
     NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"MM月dd日"];
     NSString *dateString1 = [dateFormatter stringFromDate:date2];
    
        NSString *dateString =[NSString stringWithFormat:@"更新于%@",dateString1];
        headerLabel.text = dateString;
    
    
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

//添加每个cell出现时的3D动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(HREveryDayTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HREveryDayModel *model = self.selectDic[self.dateArray[indexPath.section]][indexPath.row];
    
    if (![[SDWebImageManager sharedManager] memoryCachedImageExistsForURL:[NSURL URLWithString:model.coverForDetail]]) {
        
        CATransform3D rotation;//3D旋转
        
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        //        rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        //逆时针旋转
        
        rotation = CATransform3DScale(rotation, 0.9, .9, 1);
        
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        
        [UIView beginAnimations:@"rotation" context:NULL];
        //旋转时间
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    }
    
    [cell cellOffset];
    cell.model = model;
}


#pragma mark ---------- 单元格代理方法 ----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    flag =1;
    [self showImageAtIndexPath:indexPath];
    
    
}


#pragma mark --------- 设置待播放界面 ----------

- (void)showImageAtIndexPath:(NSIndexPath *)indexPath{
    
    _array = _selectDic[_dateArray[indexPath.section]];
    _currentIndexPath = indexPath;
    
    HREveryDayTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell convertRect:cell.bounds toView:nil];
    CGFloat y = rect.origin.y;
    
    _rilegoule = [[HRrilegouleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) imageArray:_array index:indexPath.row];
    _rilegoule.offsetY = y;
    _rilegoule.animationTrans = cell.picture.transform;
    _rilegoule.animationView.picture.image = cell.picture.image;
    
    _rilegoule.scrollView.delegate = self;
    
    [[_tableView superview] addSubview:_rilegoule];
    //添加轻扫手势
    UISwipeGestureRecognizer *Swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    
    _rilegoule.contentView.userInteractionEnabled = YES;
    
    Swipe.direction = UISwipeGestureRecognizerDirectionUp;
    
    [_rilegoule.contentView addGestureRecognizer:Swipe];
    
    //添加点击播放手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [_rilegoule.scrollView addGestureRecognizer:tap];
    [_rilegoule aminmationShow];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //刷新
    [self.storeHouseRefreshControl scrollViewDidScroll];
    
    
    
    
    if ([scrollView isEqual:_rilegoule.scrollView]) {
        
        for (HRImageContentView *subView in scrollView.subviews) {
            
            if ([subView respondsToSelector:@selector(imageOffset)] ) {
                [subView imageOffset];
            }
        }
        
        CGFloat x = _rilegoule.scrollView.contentOffset.x;
        
        CGFloat off = ABS( ((int)x % (int)kWidth) - kWidth/2) /(kWidth/2) + .2;
        
        [UIView animateWithDuration:1.0 animations:^{
            _rilegoule.playView.alpha = off;
            _rilegoule.contentView.titleLabel.alpha = off + 0.3;
            _rilegoule.contentView.littleLabel.alpha = off + 0.3;
            _rilegoule.contentView.lineView.alpha = off + 0.3;
            _rilegoule.contentView.descripLabel.alpha = off + 0.3;
            _rilegoule.contentView.collectionCustom.alpha = off + 0.3;
            _rilegoule.contentView.shareCustom.alpha = off + 0.3;
            _rilegoule.contentView.cacheCustom.alpha = off + 0.3;
            _rilegoule.contentView.replyCustom.alpha = off + 0.3;
            
        }];
        
    } else {
        
        NSArray<HREveryDayTableViewCell *> *array = [_tableView visibleCells];
        
        [array enumerateObjectsUsingBlock:^(HREveryDayTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj cellOffset];
        }];
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_rilegoule.scrollView]) {
        
        int index = floor((_rilegoule.scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
        
        _rilegoule.scrollView.currentIndex = index;
        
        self.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:self.currentIndexPath.section];
        
        [_tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
        
        [_tableView setNeedsDisplay];
        HREveryDayTableViewCell *cell = [_tableView cellForRowAtIndexPath:self.currentIndexPath];
        
        [cell cellOffset];
        
        CGRect rect = [cell convertRect:cell.bounds toView:nil];
        _rilegoule.animationTrans = cell.picture.transform;
        _rilegoule.offsetY = rect.origin.y;
        
        HREveryDayModel *model = _array[index];
        
        [_rilegoule.contentView setData:model];
        
        [_rilegoule.animationView.picture setImageWithURL:[NSURL URLWithString: model.coverForDetail]];
        
    }
}

#pragma mark -------------- 平移手势触发事件 -----------

- (void)panAction:(UISwipeGestureRecognizer *)swipe{
    
    [_rilegoule animationDismissUsingCompeteBlock:^{
        
        _rilegoule = nil;
    }];
}

#pragma mark -------------- 点击手势触发事件 -----------

- (void)tapAction{
    HREveryDayModel *model = [_array objectAtIndex:self.currentIndexPath.row];
    
    
    [self.videoController showInWindow];
    self.videoController.contentURL =[NSURL URLWithString:model.playUrl];
    
    
    
    
}












@end
