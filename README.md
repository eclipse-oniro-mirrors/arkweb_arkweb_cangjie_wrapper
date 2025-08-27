# arkweb_cangjie_wrapper

## Introduction

The Web Cangjie API is a Cangjie API encapsulated on OpenHarmony based on the arkweb capability. arkweb is the native engine of OpenHarmony webview components, built on Chromium and CEF.

## Architecture

**Figure 1** Architecture of the web subsystem

![](figures/arkweb_cangjie_wrapper_architecture_en.png "web-architecture")

* nweb: native engine of the OpenHarmony web component, which is built based on the Chromium Embedded Framework (CEF).
* CEF: stands for Chromium Embedded Framework. It is an open-source project based on Google Chromium.

## Directory Structure

```
base/web/arkweb_cangjie_wrapper
├── ohos             # Cangjie webview code
├── kit              # Cangjie kit code
├── figures          # architecture pictures
```

## Constraints

The currently open ArkWeb Cangjie api only supports standard devices.

## Usage Guidelines

The following features are provided:

  - BackForwardList：list of historical information
  - WebCookieManager：Cookie Management
  - WebviewController：Web Component Controller

The following features are not provided yet:

  - AdsBlockManager：Ad Blocking Configuration
  - BackForwardCacheOptions：Forward/Backward Cache Configuration
  - BackForwardCacheSupportedFeatures：Forward/Backward Cache Feature Configuration
  - GeolocationPermissions: Geolocation Permission Configuration
  - JsMessageExt: Result of Executing JavaScript Scripts
  - MediaSourceInfo: Media Source Information Configuration
  - NativeMediaPlayerSurfaceInfo: Rendering Information When the App Takes Over Media Playback
  - PdfData: Generated PDF Output Data
  - ProxyConfig: Network Proxy Configuration
  - ProxyController: Network Proxy Controller
  - WebDataBase: Web Database Management
  - WebDownloadDelegate: Download Task Status Events
  - WebDownloadItem: Download Task
  - WebDownloadManager: Download Task Management
  - WebHttpBodyStream: HTTP Request Body
  - WebMessageExt: Data Object for Communication Between Frontend and App
  - WebResourceHandler: Resource Loading Control
  - WebSchemeHandler: Request Interceptor for Specified Scheme
  - WebSchemeHandlerRequest: Request Intercepted by the Interceptor
  - WebSchemeHandlerResponse: Custom Response Created for the Intercepted Request
  - WebStorageOrigin: Web Component Storage Operation Interface
  - NativeMediaPlayerBridge: Hosted Web Page Media Player Bridging Interface
  - NativeMediaPlayerHandler: Event Interface for Hosted Web Page Media Player
  - WebMessagePort: Message Port Between Web Frontend and App

For ArkWeb-related APIs, please refer to [ohos.web.webview](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/ArkWeb/cj-apis-webview.md). For relevant guidance, please refer to [ArkWeb Development Guide](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_en/web).

## Repositories Involved

[web_webview](https://gitee.com/openharmony/web_webview)

## Code Contribution

Developers are welcome to contribute code, documentation, etc. For specific contribution processes and methods, please refer to [Code Contribution](https://gitcode.com/openharmony/docs/blob/master/en/contribute/code-contribution.md).
