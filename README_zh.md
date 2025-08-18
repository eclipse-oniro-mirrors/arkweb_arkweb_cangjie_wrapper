# Web仓颉接口

## 简介

### 内容介绍

Web仓颉接口是在 OpenHarmony 上基于 arkweb 能力之上封装的仓颉API。arkweb是OpenHarmony webview组件的Native引擎，基于Chromium和CEF构建。

### 软件架构

软件架构说明
![](figures/arkweb_cangjie_wrapper_architecture.png "web软件架构图")

* nweb：基于CEF构建的OpenHarmony web组件的Native引擎。
* CEF：CEF全称Chromium Embedded Framework，是一个基于Google Chromium 的开源项目。

## 目录

```
base/web/arkweb_cangjie_wrapper
├── ohos             # 仓颉webview接口实现
├── kit              # 仓颉kit化代码
├── figures          # 存放readme中的架构图
```

## 相关仓

[web_webview](https://gitee.com/openharmony/web_webview/blob/master/README.md)
