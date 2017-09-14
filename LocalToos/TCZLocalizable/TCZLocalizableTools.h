//
//  TCZLocalizableTools.h
//  LocalToos
//
//  Created by WangSuyan on 2017/8/24.
//  Copyright © 2017年 WangSuyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCZLocalizableTools;

@protocol TCZLocalizableToolsDelegate <NSObject>

- (void)localizableToolsEndParse:(TCZLocalizableTools *)tool;
- (void)localizableToolsEndWrite:(TCZLocalizableTools *)tool;
- (void)localizableToolsError:(TCZLocalizableTools *)tool error:(NSError *)error;

@end

@interface TCZLocalizableTools : NSObject

@property (nonatomic, assign) id<TCZLocalizableToolsDelegate> delegate;


// 解析完成后，文件被存放的路径
@property (nonatomic, strong, readonly) NSArray *languagePaths;


/**
 初始化

 @param filePath 各国语言文件路径（必须为 csv 文件）
 @param lanCount 语言数
 @return TCZLocalizableTools
 */
- (instancetype)initWithSourceFilePath:(NSString *)filePath languageCount:(NSUInteger)lanCount;

/**
 初始化
 
 @param fileName 各国语言文件名（必须为 csv 文件）
 @param lanCount 语言数
 @return TCZLocalizableTools
 */
- (instancetype)initWithSourceFileName:(NSString *)fileName languageCount:(NSUInteger)lanCount;


/**
 解析调用这个方法
 */
- (void)beginParse;


/**
 解析完成后国际化文件被保存的目录

 @return 根目录
 */
+ (NSString *)saveLocalizableRootFilePath;

@end
