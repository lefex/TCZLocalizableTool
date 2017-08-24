//
//  TCZPriviewViewController.m
//  LocalToos
//
//  Created by WangSuyan on 2017/8/24.
//  Copyright © 2017年 WangSuyan. All rights reserved.
//

#import "TCZPriviewViewController.h"

@interface TCZPriviewViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>


@end

@implementation TCZPriviewViewController

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self.filePath = filePath;
        [self _createPreviewViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.filePath lastPathComponent];
}

- (void)_createPreviewViewController
{
    if (!_qlPreviewViewController) {
        _qlPreviewViewController = [[QLPreviewController alloc] init];
        _qlPreviewViewController.dataSource = self;
        _qlPreviewViewController.delegate = self;
        if (self.navigationController.navigationBar.translucent) {
            _qlPreviewViewController.view.frame = self.view.bounds;
        } else {
            _qlPreviewViewController.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
        }
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_qlPreviewViewController.view];
        [self addChildViewController:_qlPreviewViewController];
    }
}

- (void)reloadData
{
    [_qlPreviewViewController reloadData];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL *fileUrl;
    if (_filePath) {
        fileUrl = [NSURL fileURLWithPath:_filePath];
    }
    return fileUrl;
}

@end
