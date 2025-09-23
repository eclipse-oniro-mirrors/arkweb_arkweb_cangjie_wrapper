# arkweb_cangjie_wrapper

## Introduction

The Web Cangjie Interface is a Cangjie API encapsulated on OpenHarmony based on ArkWeb capabilities. It provides the capabilities of Web component control, Cookie management, and historical information list. Developers can control the behavior of web components, query web browsing history records, and set cookie information through the provided capabilities. The currently open ArkWeb Cangjie api only supports standard devices.

## Architecture

**Figure 1** Architecture of the web subsystem

![Architecture of the web subsystem](figures/arkweb_cangjie_wrapper_architecture_en.png)

As shown in the architecture:

- WebviewController: Provides the capability to control various behaviors of Web components (including behaviors such as page navigation, lifecycle status, and JavaScript interaction).
- WebCookieManager: Provides the capability to control various behaviors of cookies in Web components.
- BackForwardList: Provides the capability to obtain information about the historical record item at a specified index in the historical list.
- Cangjie ArkWeb FFI Interface:  Based on cross-language interoperability via C interfaces to implement ArkWeb Cangjie API.
- webview: Responsible for providing basic webview functions, and encapsulates C interfaces for Cangjie to conduct interoperation.
- multimedia_cangjie_wrapper: Provides the capability to use media resources. The BackForwardList depends on PixelMap from this module.
- arkui_cangjie_wrapper: Provides Cangjie UI component interfaces and basic types. The WebviewController depends on the definition and parsing of basic types from this module.
- cangjie_ark_interop: Responsible for providing APILevel definitions, used for annotating APIs. Also provides the BusinessException exception class definition that is thrown to users.
- hiviewdfx_cangjie_wrapper: Responsible for providing HiLog APIs, used for printing logs at critical paths.

## Directory Structure

```
base/web/arkweb_cangjie_wrapper
├── figures                                 # architecture pictures
├── kit                                     # Cangjie ArkWeb kit code
│   └── ArkWeb
├── ohos                                    # Cangjie ArkWeb code
│   └── web
│       └── webview
│           ├── back_forward_list.cj        # BackForwardList
│           ├── web_cookie_manager.cj       # WebCookieManager
│           └── webview_controller.cj       # WebviewController
└── test                                    # Cangjie ArkWeb test cases
    └── webview                             # Cangjie ArkWeb test cases
```
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

For ArkWeb-related APIs, please refer to [ohos.web.webview](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/ArkWeb/cj-apis-webview.md). For relevant guidance, please refer to [ArkWeb Development Guide](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_en/web/cj-web-component-overview.md).

## Code Contribution

Developers are welcome to contribute code, documentation, etc. For specific contribution processes and methods, please refer to [Code Contribution](https://gitcode.com/openharmony/docs/blob/master/en/contribute/code-contribution.md).

## Repositories Involved

[web_webview](https://gitcode.com/openharmony/web_webview)

[arkcompiler_cangjie_ark_interop](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop)

[arkui_arkui_cangjie_wrapper](https://gitcode.com/openharmony-sig/arkui_arkui_cangjie_wrapper)

[multimedia_multimedia_cangjie_wrapper](https://gitcode.com/openharmony-sig/multimedia_multimedia_cangjie_wrapper)

[hiviewdfx_hiviewdfx_cangjie_wrapper](https://gitcode.com/openharmony-sig/hiviewdfx_hiviewdfx_cangjie_wrapper)
