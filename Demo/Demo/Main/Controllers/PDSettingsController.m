//
//  PDSettingsController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/11/5.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDSettingsController.h"


@interface PDSettingsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation PDSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;

    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PDSettingsCellID"];
    tableView.rowHeight = PD_Fit(50);
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
//获取数据
-(void)loadData{
    
    self.dataArr = @[@{@"titleStr":@"清除缓存"},
                     ];
    [self.tableView reloadData];
    
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDSettingsCellID" forIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor getColor:COLOR_BORDER_BASE].CGColor;
    cell.layer.borderWidth = PD_Fit(0.5);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = PD_Font(15);
    cell.textLabel.text = self.dataArr[indexPath.row][@"titleStr"];
    cell.textLabel.textColor = [UIColor getColor:@"555555"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        NSString *cache = [self loadSystemCache];
        UILabel *cacheLab = [[UILabel alloc]init];
        cacheLab.font = PD_Font(15);
        cacheLab.textColor = [UIColor getColor:@"555555"];
        cacheLab.text = cache;
        [cacheLab sizeToFit];
        cell.accessoryView = cacheLab;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleStr = self.dataArr[indexPath.row][@"titleStr"];

    if ([titleStr containsString:@"清除缓存"]) {
        [self cleanSystemCache];
        [self.tableView reloadData];
        [[PDPublicTools sharedPublicTools]showMessage:@"清除缓存完成" duration:3];
    }
}


#pragma mark - 关于缓存
//读取缓存
-(NSString*)loadSystemCache{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    CGFloat size = [self folderSizeAtPath:cachePath];
    if (size == 0) {
        return @"No Cache";
    }
    NSString *message = size > 1 ? [NSString stringWithFormat:@"Cache %.2fM",size] : [NSString stringWithFormat:@"Cache%.2fKb", size*1024.0];
    return message;
}
//清除缓存
-(void)cleanSystemCache{
    [self cleanCaches:[NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject]];
    
}
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
@end
