//
//  TCZMainViewController.m
//  LocalToos
//
//  Created by WangSuyan on 2017/8/24.
//  Copyright © 2017年 WangSuyan. All rights reserved.
//

#import "TCZMainViewController.h"
#import "CHCSVParser.h"
#import "TCZLocalizableTools.h"
#import "TCZPriviewViewController.h"
#import "TCZInfoViewController.h"

static const NSUInteger kLanCount = 8;
static NSString* const kCellId = @"ID";

static NSString* const kAllLanguageName = @"8-1.csv";

@interface TCZMainViewController ()<UITableViewDataSource, UITableViewDelegate, TCZLocalizableToolsDelegate>

@property (nonatomic, strong) TCZLocalizableTools *localizableTool;
@property (nonatomic, strong) UITableView *tableView;

@end



@implementation TCZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TCZLocalizableTools";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始解析" style:UIBarButtonItemStylePlain target:self action:@selector(beginParseAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❓" style:UIBarButtonItemStylePlain target:self action:@selector(infoAction)];

    
    [self createUI];
}


- (void)beginParseAction:(id)sender {
    self.title = @"正在解析...";
    _localizableTool = [[TCZLocalizableTools alloc] initWithSourceFileName:kAllLanguageName languageCount:kLanCount];
    _localizableTool.delegate = self;
    [_localizableTool beginParse];
}

- (void)infoAction
{
    TCZInfoViewController *infoVC = [TCZInfoViewController new];
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark - TCZLocalizableToolsDelegate
- (void)localizableToolsEndWrite:(TCZLocalizableTools *)tool
{
    self.title = @"解析成功";
    
    [self.tableView reloadData];
}

- (void)localizableToolsEndParse:(TCZLocalizableTools *)tool
{
    self.title = @"解析完成，正在写入文件...";
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _localizableTool.languagePaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    NSString *name = [[_localizableTool.languagePaths objectAtIndex:indexPath.row] lastPathComponent];
    cell.textLabel.text = name ?: @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TCZPriviewViewController *priviewVC = [[TCZPriviewViewController alloc] initWithFilePath:_localizableTool.languagePaths[indexPath.row]];
    [self.navigationController pushViewController:priviewVC animated:YES];
}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:_tableView];
}


@end
