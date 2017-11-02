
## 目录
* [如何把国际化时需要3天的工作量缩短到10分钟](#如何把国际化时需要3天的工作量缩短到10分钟)
* [如何1秒找出国际化文件(en.lproj/Localizable.strings)语法错误](#如何1秒找出国际化文件(en.lproj/Localizable.strings)语法错误)
* [找出项目中未国际化的文本](#找出项目中未国际化的文本)
* [更人性化的找出 iOS 中未使用的图](#更人性化的找出 iOS 中未使用的图)
* [如何找出国际化文件(xxxx.strings)中未国际化的文件](#如何找出国际化文件(xxxx.strings)中未国际化的文件)

## 如何把国际化时需要3天的工作量缩短到10分钟

#### 1.使用前必读
- 1. source.strings 是已国际化好的文件，比如当前您只有汉语国际化文件，那么就使用汉语国际化文件作为 source.strings，名字必须为 source.strings；
- 2. 将要解析的文件（所有国际化后的文件），必须为 csv 文件，一般 World，Numbers （建议使用 Numbers）都支持把 excel 文件导出为 csv 文件；命名为：languages.csv 
- 3. 完成解析后，可以导出 ipa 包或者直接从沙盒中读取文件，找到对应的文件，直接复制到自己项目中即可；
- 4. 解析失败的会标记为：❌❌。

#### 2.痛点
如果 APP 要求国际化，其实添加国际化文字是很头痛的一件事。对于一个大型 
APP 来说，更是麻烦，而且工作量很大。通常替换国际化文字时，产品会给我们一个 Excel 表：

![excel.png](http://upload-images.jianshu.io/upload_images/1664496-bcd911a268c2c574.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们需要做的事，就是把 Excel 表中的文字，添加到下面各个文件中：

![locailzable.png](http://upload-images.jianshu.io/upload_images/1664496-c612ff30b7cb26f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果有 2000 条翻译，有 8 国语言需要添加，可想工作量有多大。

#### 3.解决办法
我们目前手里只有汉语国际化文件，这里称为 `source.strings` 文件，还有一份全部翻译好的文件，这里称为 `language.xlxs`。

`source.strings` 文件中的内容如下：

```
"5-6_event" = "您已忽略了该事件";
"5-6_customer" = "账号已被封停";
"5-6_version" = "请更新版本后再申请提现";
"5-6_update" = "您的当前版本过低，请立即升级";
```

`language.xlxs` 文件中的内容如下：

![屏幕快照 2017-08-24 下午2.14.14.png](http://upload-images.jianshu.io/upload_images/1664496-dae9f3040de68c75.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们想做的就是把 `language.xlxs` 文件的内容转换成类似：
```
"5-6_event" = "You have missed this event";
"5-6_customer" = "account stop，please contact Customer Services";
"5-6_version" = "Please update new version before submitting withdrawal application";
"5-6_update" = "Please update to new version, your current version is outdated";
```

```
"5-6_event" = "귀하께서 해당사항 홀시 ";
"5-6_customer" = "계좌번호가 사용정지되어, 애프터 서비스와 연락할것. 
"5-6_version" = "새로운 버전으로 갱신후에 다시 인출 신청할 것. ";
"5-6_update" = "귀하의 현재 버번이 너무 낮아, 즉시 승급할것. ";
```
这样的文件，然后把它导入到对应的国际化文件中

![locailzable.png](http://upload-images.jianshu.io/upload_images/1664496-93f1d3caf030a360.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样就算完成了。

观察发现，这些都有规律可循，我们完全可以使用一个工具来做这些事，而不是手动。

#### 4.TCZLocalizableTool
[TCZLocalizableTool](https://github.com/lefex/TCZLocalizableTool) 可以帮助我们完成这些事，当然某些地方可能需要手动改一下。　**如果觉得能帮到你，给个星星支持一下**。它主要原理为：


![process.png](http://upload-images.jianshu.io/upload_images/1664496-b5293bcfe41a2a62.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以汉语为例说明一下 [TCZLocalizableTool](https://github.com/lefex/TCZLocalizableTool) 工作流程：

- `source.strings` 其实是一个 `plist` 文件，可以把它转换成 key-value 的形式，这样我们可以拿到自己定义的 key 和 value；
- 解析 Excel 文件 `language.xlxs` 一般需要把它转换成 `language.csv` 文件；
- 读取 `language.csv` 文件中的每个值的时候，根据 `source.strings` 转换后的字典，可以找到对应的 key 和 value；
- 把结果导出为 csv 文件。

最终结果如图：

![Simulator Screen Shot 2017年8月24日 下午2.49.39.png](http://upload-images.jianshu.io/upload_images/1664496-f66d9a1353134420.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 如何1秒找出国际化文件(en.lproj/Localizable.strings)语法错误

国际化的时候难免会由于不小心，会出现语法错误，如果国际化文件有几千行的时候，无非是一场灾难。有时为了解决一个语法错误可能会耗费几个小时。使用这个脚本可以 《1秒》 定位到报错的代码行。比如 `"HOM_Lefe" = "wsy“;` 由于错误使用了汉语双引号，导致编译失败。

【如何使用】
1.修改 DESPATH 为你项目的路径；
2.直接在脚本所在的目录下，打开终端执行 python localizableError.py，这里的 localizableError.py 为脚本文件名。你可以在这里 http://t.cn/RORnD3s 找到脚本文件；
3.执行完成后，控制台会打印报错的代码行。
`/en.lproj/Localizable.strings:line[11] : "HOM_Lefe" = "wsy“;`

## 找出项目中未国际化的文本

对于支持多语言的 APP 来说，国际化非常麻烦，而找出项目中未国际化的文字非常耗时（如果单纯的靠手动查找）。虽然可以使用 Xcode 自带的工具（Show not-localized strings）或者 Analyze 找出未国际化的文本，但是它们都不够灵活，而且比较耗时。如果能直接把项目中未国际化的文本导入到一个文件中，直接给产品，然后再使用 [TCZLocalizableTool] http://t.cn/ROcrQuB ，岂不是事半功倍。图中就是通过一个 Python 脚本获得的部分未国际化的文本。

使用很简单
1.修改 DESPATH 路径为你项目的路径
2.直接在脚本所在的目录下，执行 python unLocalizable.py，这里的 unLocalizable.py 为脚本文件名。你可以在这里 (http://t.cn/ROcrQu1 找到脚本文件。
3.BLACKDIRLIST 你可以过滤掉和国际化无关的文件，比如某些第三方库。


## 更人性化的找出 iOS 中未使用的图

【痛点】
删除 iOS 项目中没有用到的图片市面上已经有很多种方式，但是我试过几个都不能很好地满足需求，因此使用 Python 写了这个脚本，它可能也不能很好的满足你的需求，因为这种静态查找始终会存在问题，每个人写的代码风格不一，导致匹配字符不一。所以只有掌握了脚本的写法，才能很好的满足自己的需求。如果你的项目中使用 OC，而且使用纯代码布局，使用这个脚本完全没有问题。当然你可以修改脚本来达到自己的需求。本文主要希望能够帮助更多的读者节省更多时间做一些有意义的工作，避免那些乏味重复的工作。

【如何使用】
1.修改 DESPATH 为你项目的路径；
2.直接在脚本所在的目录下，打开终端执行 python unUseImage.py，这里的 unUseImage.py 为脚本文件名。你可以在这里 http://t.cn/ROXKobQ 找到脚本文件；
3.执行完成后，桌面会出现一个 unUseImage 文件夹。文件夹中的 error.log 文件记录了可能存在未匹配到图片的文件目录，image.log 记录了项目中没使用的图片路径，images 存放了未使用到的图片。

【重要提示】
当确认 `images` 文件夹中含有正在使用的图时，复制图片名字到 EXCEPT_IMAGES 中，再次执行脚本，确认 images 文件夹中不再包含使用的图后，修改 IS_OPEN_AUTO_DEL 为 True，执行脚本，脚本将自动清除所有未使用的图。

## 如何找出国际化文件(xxxx.strings)中未国际化的文件

国际化的时候难免会由于不小心，会出现某个 .strings 文件中存在没有添加的国际化字符串。比如某个项目中支持中文和英文。在中文国际化文件（zh-Hans.lproj/Localizable.strings）中含有 ：
```
"HOM_home" = "首页";
"GRB_groupBuy" = "团购";
"SHC_shopnCart" = "购物车";
"PER_personal" = "我的";
```

而在英文国际化文件（en.lproj/Localizable.strings）中含有 ：
```
"HOM_home" = "home";
"PER_personal" = "my";
```

这样导致，英文环境下，`SHC_shopnCart` 和 `GRB_groupBuy` 未国际化，使用这个脚本会检测出这些错误。

【如何使用】

1.修改 DESPATH 为你项目的路径；
2.直接在脚本所在的目录下，打开终端执行 python checkLocalizable.py，这里的 checkLocalizable.py 为脚本文件名。你可以在这里 http://t.cn/ROge6j4 找到脚本文件；
3.执行完成后，桌面会出现一个文件 checkLocalizable.log，记录了未国际化的行：

```
/en.lproj/Localizable.strings
SHC_shopnCart
GRB_groupBuy
```


