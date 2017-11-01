# coding=utf-8

import os
import re
import shutil

# 是否开启自动删除，开启后当检查到未用到的图，
# 将自动被删除。建议确认所有的图没用后开启
IS_OPEN_AUTO_DEL = False

# 将要解析的项目名称
DESPATH = "/Users/wangsuyan/desktop/project/ShopnFriends/ShopnFriends"

# 可能检查出错的图片，需要特别留意下
ERROR_DESPATH = "/Users/wangsuyan/Desktop/unUseImage/error.log"

# 解析结果存放的路径
WDESPATH = "/Users/wangsuyan/Desktop/unUseImage/image.log"

# 项目中没有用到的图片
IMAGE_WDESPATH = "/Users/wangsuyan/Desktop/unUseImage/images/"

# 目录黑名单，这个目录下所有的图片将被忽略
BLACK_DIR_LIST = [
                  DESPATH + '/ThirdPart', # Utils 下所有的文件将被忽略
                  ]

# 已知某些图片确实存在，比如像下面的图，脚本不会自动检查出，需要手动加入这个数组中
# NSString *name = [NSString stringWithFormat:@"loading_%d",i];
# UIImage *image = [UIImage imageNamed:name];
EXCEPT_IMAGES = [
                 'loading_',
                 'launch-guide'
                 ]

# 项目中所有的图
source_images = dict()
# 项目中所有使用到的图
use_images = set()
# 异常图片
err_images = set()

# 目录是否在黑名单中 BLACK_DIR_LIST
def isInBlackList(filePath):
    if os.path.isfile(filePath):
        return filename(filePath) in BLACK_DIR_LIST
    if filePath:
        return filePath in BLACK_DIR_LIST
    return False

# 是否为图片
def isimage(filePath):
    ext = os.path.splitext(filePath)[1]
    return ext == '.png' or ext == '.jpg' or ext == '.jpeg' or ext == '.gif'

# 是否为 APPIcon
def isappicon(filePath):
    return 'appiconset' in filePath

def filename(filePath):
    return os.path.split(filePath)[1]

def is_except_image(filePath):
    name = filename(filePath)
    for item in EXCEPT_IMAGES:
        if item in name:
            return True
    return False

def auto_remove_images():
    with open(WDESPATH, 'r') as f:
        for line in f.readlines():
            path = DESPATH + line.strip('\n')
            if not os.path.isdir(path):
                if 'Assets.xcassets' in line:
                    path = os.path.split(path)[0]
                    if os.path.exists(path):
                        shutil.rmtree(path)
                else:
                    os.remove(path)


def un_use_image(filePath):
    if re.search(r'\w@3x.(png|jpg|jpeg|gif)', filePath):
        return
    
    if re.search(r'\w(@2x){0,1}.(png|jpg|jpeg|gif)', filePath):
        exts = os.path.splitext(filePath)
        result = (filename(filePath).replace('@2x', '')).replace(exts[1],'')
        source_images[result] = filePath

def find_image_name(filePath):
    f = open(filePath)
    for index, line in enumerate(f):
        line = line.strip()
        regx = r'\[\s*UIImage\s+imageNamed\s*:\s*@"(.+?)"'
        matchs = re.findall(regx, line)
        if matchs:
            for item in matchs:
                use_images.add(item)
        else:
            err_matchs = re.findall(r'\[UIImage imageNamed:', line)
            if err_matchs:
                name = filename(filePath)
                for item in err_matchs:
                    err_images.add(str(index + 1) + ':' + name + '\n' + line + '\n')

def find_from_file(path):
    paths = os.listdir(path)
    for aCompent in paths:
        aPath = os.path.join(path, aCompent)
        if isInBlackList(aPath):
            print('在黑名单中，被自动忽略' + aPath)
            continue
        if os.path.isdir(aPath):
            find_from_file(aPath)
        elif os.path.isfile(aPath) and isimage(aPath) and not isappicon(aPath) and not is_except_image(aPath):
            un_use_image(aPath)
        elif os.path.isfile(aPath) and os.path.splitext(aPath)[1]=='.m':
            find_image_name(aPath)

if __name__ == '__main__':
    if os.path.exists(IMAGE_WDESPATH):
        shutil.rmtree(IMAGE_WDESPATH)

    os.makedirs(IMAGE_WDESPATH)

with open(WDESPATH, 'w') as wf:
    find_from_file(DESPATH)
    for item in set(source_images.keys()) - use_images:
        value = source_images[item]
        wf.write(value.replace(DESPATH, '') + '\n')
        ext = os.path.splitext(value)[1]
        shutil.copyfile(value, IMAGE_WDESPATH + item + ext)
        
        with open(ERROR_DESPATH, 'w') as ef:
            for item in err_images:
                ef.write(item)

if IS_OPEN_AUTO_DEL:
    auto_remove_images()
