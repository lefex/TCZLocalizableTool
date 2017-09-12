//
//  TCZLocalizableTools.m
//  LocalToos
//
//  Created by WangSuyan on 2017/8/24.
//  Copyright © 2017年 WangSuyan. All rights reserved.
//

#import "TCZLocalizableTools.h"
#import "CHCSVParser.h"

@interface TCZLocalizableTools ()<CHCSVParserDelegate>

@property (nonatomic, strong) NSArray<NSMutableArray *> *paeseResults;
@property (nonatomic, strong) CHCSVParser *csvParser;
@property (nonatomic, assign) NSUInteger lanCount;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *mapDict;

@property (nonatomic, strong, readwrite) NSArray *languagePaths;

@end

@implementation TCZLocalizableTools

- (instancetype)initWithSourceFilePath:(NSString *)filePath languageCount:(NSUInteger)lanCount
{
    self = [super init];
    if (self) {
        _lanCount = lanCount;
        
        // 解析 key
        _mapDict = [NSMutableDictionary dictionary];
        NSDictionary *tempMapDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"source" ofType:@"strings"]];
        [tempMapDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [_mapDict setObject:key forKey:obj];
        }];
        
        CHCSVParser *parse = [[CHCSVParser alloc] initWithContentsOfCSVURL:[NSURL fileURLWithPath:filePath]];
        parse.delegate = self;
        _csvParser = parse;
        
    }
    return self;
}

- (instancetype)initWithSourceFileName:(NSString *)fileName languageCount:(NSUInteger)lanCount
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:(fileName.pathExtension.length > 0) ? nil : @"csv"];
    return [self initWithSourceFilePath:filePath languageCount:lanCount];
}

- (void)beginParse
{
    [self setUpdata];
    [_csvParser parse];
}

- (void)setUpdata
{
    _keys = [NSMutableArray array];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSUInteger i = 0; i < _lanCount; i++) {
        [temp addObject:[NSMutableArray array]];
    }
    _paeseResults = [temp copy];
}

#pragma mark - CHCSVParserDelegate
- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
    NSLog(@"ParserDidBeginDocument");
}

- (void)parserDidEndDocument:(CHCSVParser *)parser
{
    NSLog(@"ParserDidEndDocument");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(localizableToolsEndParse:)]) {
        [self.delegate localizableToolsEndParse:self];
    }
    
    @autoreleasepool {
        NSMutableArray *languagePaths = [NSMutableArray array];
        for (NSUInteger i = 0; i < _lanCount; i++) {
            
            NSArray *aLanguages = _paeseResults[i];
            NSMutableArray *temps = [NSMutableArray array];
            NSUInteger aLanCount = aLanguages.count;
            for (NSUInteger i = 0, max = _keys.count; i < max; i++) {
                if (i < aLanCount) {
                    
                    // 避免文本中还有逗号
                    NSString *aLanguage = [self removeInvalidStr:aLanguages[i]];
                    [temps addObject:[NSString stringWithFormat:@"\"%@\"=\"%@\";",_keys[i], aLanguage]];
                } else {
                    [temps addObject:[NSString stringWithFormat:@"\"%@\"=\"%@\";",_keys[i], @""]];
                }
            }
            
            NSString *csvFile = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"language_%@.csv", @(i)]];
            [[NSFileManager defaultManager] createFileAtPath:csvFile contents:nil attributes:nil];
            [languagePaths addObject:csvFile];
            
            CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:csvFile];
            for (NSUInteger i = 0, max = temps.count; i < max; i++) {
                [writer writeField:temps[i]];
                [writer finishLine];
            }
        }
        
        _languagePaths = [languagePaths copy];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(localizableToolsEndWrite:)]) {
            [self.delegate localizableToolsEndWrite:self];
        }
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    field = field ?: @"";
    
    if (fieldIndex == 0) {
        NSString *key = [_mapDict objectForKey:[self removeInvalidStr:field]];
        [_keys addObject:key ?: @""];
    }
    
    if (fieldIndex < _paeseResults.count) {
        [_paeseResults[fieldIndex] addObject:field];
    }
}

- (NSString *)removeInvalidStr:(NSString *)sourceStr
{
    NSMutableString *aLanguage = [[NSMutableString alloc] initWithString:sourceStr];
    if ([aLanguage containsString:@","] && [aLanguage hasPrefix:@"\""] && [aLanguage hasSuffix:@"\""]) {
        [aLanguage replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        [aLanguage deleteCharactersInRange:NSMakeRange(aLanguage.length-1, 1)];
    }
    return [aLanguage copy];
}


@end
