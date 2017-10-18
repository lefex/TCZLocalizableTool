# coding=utf-8 

import os
import re

# 将要解析的项目名称 
DESPATH = "/Users/wangsuyan/desktop/project/LGSKmart/LGSKmart/Resource/Localizations"

ERROR_DESPATH = "/Users/wangsuyan/Desktop/checkLocalizable.log"

MAIN_LOCALIZABLE_FILE = "/zh-Hans.lproj/Localizable.strings"

_result = {}

def filename(filePath):
    return os.path.split(filePath)[1]

def pragram_error(filePath):
    if '/Base.lproj/Localizable.strings' in filePath:
        return
    print(filePath)
    f = open(filePath)
    isMutliNote = False
    fname = filePath.replace(DESPATH, '')
    _list = set()
    for index, line in enumerate(f):
        line = line.strip()

        if '/*' in line:
            isMutliNote = True
        if '*/' in line:
            isMutliNote = False
        if isMutliNote:
            continue

        if len(line) == 0 or line == '*/':
            continue

        if re.findall(r'^/+', line):
            continue

        regx = r'^"(.*s?)"\s*=\s*".*?";$'
        matchs = re.findall(regx, line)
        if matchs:
            for item in matchs:
                _list.add(item)
    _result[fname] = _list


def find_from_file(path):
    paths = os.listdir(path)
    for aCompent in paths:
        aPath = os.path.join(path, aCompent)
        if os.path.isdir(aPath):
            find_from_file(aPath)
        elif os.path.isfile(aPath) and os.path.splitext(aPath)[1]=='.strings':
            pragram_error(aPath)

def parse_result():
    fValues = _result[MAIN_LOCALIZABLE_FILE]
    ef = open(ERROR_DESPATH, 'w')
    for k, v in _result.items():
        if k == MAIN_LOCALIZABLE_FILE:
            continue
        result = fValues - v

        ef.write(k + '\n')
        for item in result:
            ef.write(item + '\n')
        ef.write('\n')
    ef.close()


if __name__ == '__main__':
    find_from_file(DESPATH)
    parse_result()