# web_webview

## 简介

### 内容介绍

arkweb是OpenHarmony webview组件的Native引擎，基于Chromium和CEF构建。

### 软件架构

软件架构说明
![](figures/Web-architecture_ZH.png "web软件架构图")

* webview组件：OpenHarmony的UI组件。
* nweb：基于CEF构建的OpenHarmony web组件的Native引擎。
* CEF：CEF全称Chromium Embedded Framework，是一个基于Google Chromium 的开源项目。
* Chromium： Chromium是一个由Google主导开发的网页浏览器。以BSD许可证等多重自由版权发行并开放源代码。

## 目录

```
base/web/web_cangjie_api
├── ohos             # 仓颉webview接口实现
├── kit              # 仓颉kit化代码
├── figures          # 存放readme中的架构图
```

## 相关仓

web_cangjie_api

[web_webview](https://gitee.com/openharmony/web_webview)
