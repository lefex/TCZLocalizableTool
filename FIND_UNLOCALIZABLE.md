### 痛点

对于支持多语言的 APP 来说，国际化非常麻烦，而找出项目中未国际化的文字非常耗时（如果单纯的靠手动查找）。虽然可以使用 Xcode 自带的工具（Show not-localized strings）或者 Analyze 找出未国际化的文本，但是它们都不够灵活。如果能直接把项目中未国际化的文本导入到一个文件中，直接给产品，然后再使用 [TCZLocalizableTool](https://github.com/lefex/TCZLocalizableTool) ，岂不是事半功倍。下面这张图就是靠一个 Python 脚本获得的结果：
![result.png](http://upload-images.jianshu.io/upload_images/1664496-a775df9cfccb899f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 原理

本文主要使用 Python 脚本来查找未国际化的文本。主要思路：
- 给定一个项目地址
- 递归项目中的 `.m` 文件，找出汉语（这里可能有没考虑到的情况，需要读者自行修改源码）
- 写入文件中（可以按照自己的需求写入文件）

```
# coding=utf-8
# 这是一个查找项目中未国际化的脚本

import os
import re

# 汉语写入文件时需要
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

# 将要解析的项目名称 
DESPATH = "/Users/wangsuyan/Desktop/Kmart"

# 解析结果存放的路径
WDESPATH = "/Users/wangsuyan/Desktop/unlocalized.log"

#目录黑名单，这个目录下所有的文件将被忽略
BLACKDIRLIST = [
    DESPATH + '/Classes/Personal/PERSetting/PERAccount', # 多级目录
    DESPATH + '/Utils', # Utils 下所有的文件将被忽略
    'PREPhoneNumResetViewController.m', # 文件名直接写，将忽略这个文件 
]

# 输出分隔符
SEPREATE = ' <=> '

def isInBlackList(filePath):
    if os.path.isfile(filePath):
        return fileNameAtPath(filePath) in BLACKDIRLIST
    if filePath:
        return filePath in BLACKDIRLIST
    return False

def fileNameAtPath(filePath):
    return os.path.split(filePath)[1]

def isSignalNote(str):
    if '//' in str:
        return True
    if str.startswith('#pragma'):
        return True
    return False

def isLogMsg(str):
    if str.startswith('NSLog') or str.startswith('FLOG'):
        return True
    return False

def unlocalizedStrs(filePath):
    f = open(filePath)
    fileName = fileNameAtPath(filePath)
    isMutliNote = False
    isHaveWriteFileName = False
    for index, line in enumerate(f):
        #多行注释
        line = line.strip()
        if '/*' in line:
            isMutliNote = True
        if '*/' in line:
            isMutliNote = False
        if isMutliNote:
            continue

        #单行注释
        if isSignalNote(line):
            continue

        #打印信息
        if isLogMsg(line):
            continue

        matchList = re.findall(u'@"[\u4e00-\u9fff]+', line.decode('utf-8'))
        if matchList:
            if not isHaveWriteFileName:
                wf.write('\n' + fileName + '\n')
                isHaveWriteFileName = True

            for item in matchList:
                wf.write(str(index + 1) + ':' + item[2 : len(item)] + SEPREATE + line + '\n')

def findFromFile(path):
    paths = os.listdir(path)
    for aCompent in paths:
        aPath = os.path.join(path, aCompent)
        if isInBlackList(aPath):
            print('在黑名单中，被自动忽略' + aPath)
            continue
        if os.path.isdir(aPath):
            findFromFile(aPath)
        elif os.path.isfile(aPath) and os.path.splitext(aPath)[1]=='.m':
            unlocalizedStrs(aPath)

if __name__ == '__main__':
    wf = open(WDESPATH, 'w')
    findFromFile(DESPATH)
    wf.close()
```

### 使用
- 修改 DESPATH 路径为你项目的路径
- 直接在脚本所在的目录下，执行 `python unLocalizable.py`，这个的 `unLocalizable.py` 为脚本文件名。你可以在 [这里](https://github.com/lefex/TCZLocalizableTool/blob/master/LocalToos/TCZLocalizable/unLocalizable.py) 找到脚本文件。
