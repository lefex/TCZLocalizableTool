//
//  TCZInfoViewController.m
//  LocalToos
//
//  Created by WangSuyan on 2017/8/24.
//  Copyright © 2017年 WangSuyan. All rights reserved.
//

#import "TCZInfoViewController.h"

@interface TCZInfoViewController ()

@end

@implementation TCZInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"使用说明";
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - 40)];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.text = @"1. source.strings 是已国际化好的文件，比如当前您只有汉语国际化文件，那么就使用汉语国际化文件作为 source.strings，名字必须为 source.strings；\n\n2. 将要解析的文件（所有国际化后的文件），必须为 csv 文件，一般 World，Numbers 都支持把 excel 文件导出为 csv 文件；\n\n3. 完成解析后，可以导出 ipa 包，找到对应的文件，直接复制到自己项目中即可。";
    infoLabel.font = [UIFont systemFontOfSize:18];
    infoLabel.numberOfLines = 0;
    [self.view addSubview:infoLabel];
}


@end
