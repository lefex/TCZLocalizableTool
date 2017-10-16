# coding=utf-8 

import os
import re

# 将要解析的项目名称 
DESPATH = "/Users/wangsuyan/desktop/project/LGSKmart/LGSKmart/Resource/Localizations"

def filename(filePath):
    return os.path.split(filePath)[1]

def pragram_error(filePath):
    f = open(filePath)
    isMutliNote = False
    fname = filePath.replace(DESPATH, '')
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

        regx = r'^".*s?"\s*=\s*".*?";$'
        matchs = re.findall(regx, line)
        if not matchs:
            result = fname + ':line[' + str(index) + '] : ' + line
            print(filePath)
            print(result)


def find_from_file(path):
    paths = os.listdir(path)
    for aCompent in paths:
        aPath = os.path.join(path, aCompent)
        if os.path.isdir(aPath):
            find_from_file(aPath)
        elif os.path.isfile(aPath) and os.path.splitext(aPath)[1]=='.strings':
            pragram_error(aPath)

if __name__ == '__main__':
    find_from_file(DESPATH)