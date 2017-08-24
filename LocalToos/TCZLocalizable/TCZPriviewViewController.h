//
//  TCZPriviewViewController.h
//  LocalToos
//
//  Created by WangSuyan on 2017/8/24.
//  Copyright © 2017年 WangSuyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuickLook/QuickLook.h>

@interface TCZPriviewViewController : UIViewController

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) QLPreviewController *qlPreviewViewController;

- (instancetype)initWithFilePath:(NSString *)filePath;

- (void)reloadData;

@end
