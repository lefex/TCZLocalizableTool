[简书](http://www.jianshu.com/p/2c77f0d108c3)

[快速找出项目中未国际化的文本](https://github.com/lefex/TCZLocalizableTool/blob/master/FIND_UNLOCALIZABLE.md)

## 使用前必读
- 1. source.strings 是已国际化好的文件，比如当前您只有汉语国际化文件，那么就使用汉语国际化文件作为 source.strings，名字必须为 source.strings；
- 2. 将要解析的文件（所有国际化后的文件），必须为 csv 文件，一般 World，Numbers （建议使用 Numbers）都支持把 excel 文件导出为 csv 文件；命名为：languages.csv 
- 3. 完成解析后，可以导出 ipa 包或者直接从沙盒中读取文件，找到对应的文件，直接复制到自己项目中即可；
- 4. 解析失败的会标记为：❌❌。

### 痛点
如果 APP 要求国际化，其实添加国际化文字是很头痛的一件事。对于一个大型 
APP 来说，更是麻烦，而且工作量很大。通常替换国际化文字时，产品会给我们一个 Excel 表：

![excel.png](http://upload-images.jianshu.io/upload_images/1664496-bcd911a268c2c574.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们需要做的事，就是把 Excel 表中的文字，添加到下面各个文件中：

![locailzable.png](http://upload-images.jianshu.io/upload_images/1664496-c612ff30b7cb26f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果有 2000 条翻译，有 8 国语言需要添加，可想工作量有多大。

### 解决办法
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

### TCZLocalizableTool
[TCZLocalizableTool](https://github.com/lefex/TCZLocalizableTool) 可以帮助我们完成这些事，当然某些地方可能需要手动改一下。　**如果觉得能帮到你，给个星星支持一下**。它主要原理为：


![process.png](http://upload-images.jianshu.io/upload_images/1664496-b5293bcfe41a2a62.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以汉语为例说明一下 [TCZLocalizableTool](https://github.com/lefex/TCZLocalizableTool) 工作流程：

- `source.strings` 其实是一个 `plist` 文件，可以把它转换成 key-value 的形式，这样我们可以拿到自己定义的 key 和 value；
- 解析 Excel 文件 `language.xlxs` 一般需要把它转换成 `language.csv` 文件；
- 读取 `language.csv` 文件中的每个值的时候，根据 `source.strings` 转换后的字典，可以找到对应的 key 和 value；
- 把结果导出为 csv 文件。

最终结果如图：

![Simulator Screen Shot 2017年8月24日 下午2.49.39.png](http://upload-images.jianshu.io/upload_images/1664496-f66d9a1353134420.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

