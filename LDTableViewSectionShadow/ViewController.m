//
//  ViewController.m
//  LDTableViewSectionShadow
//
//  Created by 李洞洞 on 2020/8/13.
//  Copyright © 2020 李洞洞. All rights reserved.
//

#import "ViewController.h"
#import "LDHeaderView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
 
    UITableView *_provinceTableView;
    NSDictionary *_provinceDic;
    NSArray *_provinceArray;
    NSMutableArray *_isExpandArray;//记录section是否展开
}
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
#if 1 //其他测试

    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSInteger  value = nil;
    NSString * value2 = nil;
    dict[@"key"] = @(value);
    NSLog(@"%@",dict);
    NSLog(@"%@",dict[value2]);
    NSLog(@"啦啦啦");
    
    NSLog(@"贮藏后...");
#endif
    
#if 0
    _isExpandArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:250 / 255.0 blue:253 / 255.0 alpha:1];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"城市列表";
    [self getProvinceDataFromList];
    [self initProvinceTableView];
#endif
}

- (void)getProvinceDataFromList{
    NSString *dataList = [[NSBundle mainBundle]pathForResource:@"ProvinceData" ofType:@"plist"];
    _provinceDic = [[NSDictionary alloc]initWithContentsOfFile:dataList];
    _provinceArray = [_provinceDic allKeys];
    for (NSInteger i = 0; i < _provinceArray.count; i++) {
        [_isExpandArray addObject:@"0"];//0:没展开 1:展开
    }
    NSLog(@"城市列表:%@",_provinceDic);
}

- (void)initProvinceTableView{
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 30, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 100) style:UITableViewStylePlain];
    _provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_provinceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    _provinceTableView.showsVerticalScrollIndicator = NO;
    _provinceTableView.delegate = self;
    _provinceTableView.dataSource = self;
    //_provinceTableView.estimatedRowHeight = 50;
    _provinceTableView.estimatedRowHeight = 0;
    _provinceTableView.estimatedSectionFooterHeight = 0;
    _provinceTableView.estimatedSectionHeaderHeight = 0;
    
    [self.view addSubview:_provinceTableView];
}

#pragma -- mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _provinceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_isExpandArray[section]isEqualToString:@"1"]) {
        NSString *keyProvince = _provinceArray[section];
        NSArray *cityArray = [_provinceDic objectForKey:keyProvince];
        return  cityArray.count;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LDHeaderView * headerView = [[LDHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    headerView.nameLabel.text = _provinceArray[section];
    if ([_isExpandArray[section] isEqualToString:@"0"]) {
        //未展开
        headerView.directionImv.image = [UIImage imageNamed:@"caret"];
        [self setupCircularOrShadow:headerView withBottomLeftRight:NO topLeftRight:NO all:YES];
    }else{
        //展开
        headerView.directionImv.image = [UIImage imageNamed:@"caret_open"];
        [self setupCircularOrShadow:headerView withBottomLeftRight:NO topLeftRight:YES all:NO];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [headerView addGestureRecognizer:tap];
    headerView.tag = section;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    return view;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSString *keyOfProvince = _provinceArray[indexPath.section];
    NSArray *cityArray = [_provinceDic objectForKey:keyOfProvince];
    cell.textLabel.text = cityArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    if (rowNum == 1) {
        [self setupCircularOrShadow:cell withBottomLeftRight:YES topLeftRight:NO all:NO];
    }else {
        if (indexPath.row == 0) {

            [self setupCircularOrShadow:cell withBottomLeftRight:NO topLeftRight:NO all:NO];

        }else if (indexPath.row == rowNum - 1) {

            [self setupCircularOrShadow:cell withBottomLeftRight:YES topLeftRight:NO all:NO];

        }else {

            [self setupCircularOrShadow:cell withBottomLeftRight:NO topLeftRight:NO all:NO];
            
        }
    }
}
/// Description
/// @param cell cell
/// @param bottom 左下 右下切圆角
/// @param top 左上 右上切圆角
/// @param all 四周切圆角
- (void)setupCircularOrShadow:(UIView *)cell withBottomLeftRight:(BOOL)bottom  topLeftRight:(BOOL)top  all:(BOOL)all
{
    // 圆角角度
       CGFloat radius = 10.f;
       // 设置cell 背景色为透明
       cell.backgroundColor = UIColor.clearColor;
       // 创建两个layer
       CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
       CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
       // 获取显示区域大小
       CGRect bounds = CGRectZero;
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            bounds = CGRectInset(cell.bounds, [UIScreen mainScreen].bounds.size.width/375, -1);
        }else{
            bounds = CGRectInset(CGRectMake(0, 5, 375 - 40, 45), [UIScreen mainScreen].bounds.size.width/375, -1);
        }
       // cell的backgroundView
       UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
       normalBgView.clipsToBounds = YES;
       // 贝塞尔曲线
       UIBezierPath *bezierPath = nil;
       if (bottom) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, -5, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
        }else if (top){
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
                   normalBgView.clipsToBounds = YES;
        }else if (all){
            // 一组只有一行（四个角全部为圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
            normalBgView.clipsToBounds = NO;
        }else{  //不切圆角
             bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
        // 阴影
        normalLayer.shadowColor = [UIColor blackColor].CGColor;
        normalLayer.shadowOpacity = 0.2;
        normalLayer.shadowOffset = CGSizeMake(0, 0);
        normalLayer.path = bezierPath.CGPath;
        normalLayer.shadowPath = bezierPath.CGPath;
        // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
        normalLayer.path = bezierPath.CGPath;
        selectLayer.path = bezierPath.CGPath;
        // 设置填充颜色
        normalLayer.fillColor = [UIColor whiteColor].CGColor;
        // 添加图层到nomarBgView中
        [normalBgView.layer insertSublayer:normalLayer atIndex:0];
        normalBgView.backgroundColor = UIColor.clearColor;
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell * tcell = (UITableViewCell *)cell;
            tcell.backgroundView = normalBgView;
        }else{
            [cell.layer insertSublayer:normalLayer atIndex:0];
            if (all) {
                cell.clipsToBounds = NO;
            }else{
                cell.clipsToBounds = YES;
            }
            cell.backgroundColor = UIColor.clearColor;
        }
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    if ([_isExpandArray[tap.view.tag] isEqualToString:@"0"]) {
        [_isExpandArray replaceObjectAtIndex:tap.view.tag withObject:@"1"];
    }else{
        [_isExpandArray replaceObjectAtIndex:tap.view.tag withObject:@"0"];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:tap.view.tag];
    [_provinceTableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end

