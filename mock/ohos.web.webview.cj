/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ohos.web.webview

import ohos.base.ResourceStr
import ohos.business_exception.AsyncCallback
import ohos.callback_invoke.Callback
import ohos.labels.*
import ohos.labels.APILevel
import ohos.multimedia.image.*
import ohos.multimedia.image.PixelMap
import std.collection.*
import ohos.ffi.*

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class BackForwardList {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public prop currentIndex: Int32 {
        
        get() {
            return 0
        }
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public prop size: Int32 {
        
        get() {
            return 0
        }
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getItemAtIndex(index: Int32): HistoryItem {
        return HistoryItem()
    }
    
    public init() {
        super()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebCookieManager {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public static func fetchCookie(url: String, incognito!: Bool = false): String {
        return String()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public static func configCookie(url: String, value: String, incognito!: Bool = false): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setAcceptCookiesEnabled(accept: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func isCookieAllowed(): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setAcceptThirdPartyCookieEnabled(accept: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func isThirdPartyCookieAllowed(): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func hasCookie(incognito!: Bool = false): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func clearAllCookies(incognito!: Bool = false): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func clearSessionCookie(): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func saveCookieAsync(callback: AsyncCallback<Unit>): Unit {
        return ()
    }

    public init() {
        super()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum SecurityLevel {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    NoneLevel
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Secure
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Warning
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Dangerous
    | ...
}

extend SecurityLevel <: ToString {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public func toString(): String {
        return String()
    }
}

extend SecurityLevel <: Equatable<SecurityLevel> {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func ==(other: SecurityLevel): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func !=(other: SecurityLevel): Bool {
        return true
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum WebHitTestType {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    EditText
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Email
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Unknown
    | ...
}

extend WebHitTestType <: ToString {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public func toString(): String {
        return String()
    }
}

extend WebHitTestType <: Equatable<WebHitTestType> {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func ==(other: WebHitTestType): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func !=(other: WebHitTestType): Bool {
        return true
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebHeader {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var headerKey: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var headerValue: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public init(headerKey: String, headerValue: String) {
        super()
        this.headerKey = String()
        this.headerValue = String()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class HitTestValue {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var hitTestType: WebHitTestType

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var extra: String
    
    public init() {
        super()
        this.hitTestType = WebHitTestType.EditText
        this.extra = String()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class HistoryItem {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var icon: ?PixelMap

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var historyUrl: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var historyRawUrl: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var title: String
    
    public init() {
        super()
        this.icon = None
        this.historyUrl = String()
        this.historyRawUrl = String()
        this.title = String()
    }
}

/**
 * Placeholder for the ArrayBuffer type, which is referenced by the ScriptValueType API but is not
 * yet officially defined in the Cangjie SDK base layer.
 *
 * NOTE: This is a temporary shim for compilation. Once ArrayBuffer is officially provided by the
 * SDK, this local definition must be removed. The ToString and Equatable implementations only
 * exist to keep this placeholder consistent with the real implementation.
 */
public type ArrayBuffer = Array<Byte>

@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebCustomScheme {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop schemeName: String {
        get() {
            return ""
        }
        set(value) {
        }
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop isSupportCORS: Bool {
        get() {
            return true
        }
        set(value) {
        }
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop isSupportFetch: Bool {
        get() {
            return true
        }
        set(value) {
        }
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop isCodeCacheSupported: ?Bool {
        get() {
            return None
        }
        set(value) {
        }
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public init(schemeName: String, isSupportCORS: Bool, isSupportFetch: Bool) {
        super()
    }
}

@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public func once(eventType: String, callback: Callback<Unit>): Unit {
    return ()
}

@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebStorage {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func deleteAllData(incognito!: ?Bool = false): Unit {
        return ()
    }
}

@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum ScriptValueType {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    StringValue(String)
    |
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    ArrayBufferValue(ArrayBuffer)
    | ...
}

extend ScriptValueType <: ToString {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public func toString(): String {
        return String()
    }
}

extend ScriptValueType <: Equatable<ScriptValueType> {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func ==(other: ScriptValueType): Bool {
        return true
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func !=(other: ScriptValueType): Bool {
        return true
    }
}

@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class JsMessageExt {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getString(): String {
        return String()
    }
}

@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum RenderProcessMode {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Single
    |
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Multiple
    | ...
}

extend RenderProcessMode <: ToString {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public func toString(): String {
        return String()
    }
}

extend RenderProcessMode <: Equatable<RenderProcessMode> {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func ==(other: RenderProcessMode): Bool {
        return true
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func !=(other: RenderProcessMode): Bool {
        return true
    }
}

@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum ScrollType {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Event
    | ...
}

extend ScrollType <: ToString {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public func toString(): String {
        return String()
    }
}

extend ScrollType <: Equatable<ScrollType> {
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func ==(other: ScrollType): Bool {
        return true
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public operator func !=(other: ScrollType): Bool {
        return true
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebviewController <: RemoteDataLite {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public init(webTag!: ?String = None) {
        super()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setWebDebuggingAccess(webDebuggingAccess: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func enableSafeBrowsing(enable: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func isSafeBrowsingEnabled(): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func canGoBack(): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func accessStep(step: Int32): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func goForward(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func goBack(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func clearHistory(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func reload(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func loadUrl<T>(url: T, headers!: Array<WebHeader> = Array<WebHeader>()): Unit where T <: ResourceStr {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func storeWebArchive(baseName: String, autoName: Bool, callback: AsyncCallback<String>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func zoom(factor: Float32): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func zoomIn(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func zoomOut(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getUserAgent(): String {
        return String()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getTitle(): String {
        return String()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getPageHeight(): Int32 {
        return 0
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func goBackOrForward(step: Int32): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true,
        workerthread: true
    ]
    public func stop(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func registerJavaScriptProxy(funcs: Array<(String) -> String>, name: String, methodList: Array<String>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func runJavaScript(script: String, callback: AsyncCallback<String>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getUrl(): String {
        return String()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func pageUp(top: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func pageDown(bottom: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getOriginalUrl(): String {
        return String()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getBackForwardEntries(): BackForwardList {
        return BackForwardList()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func removeCache(clearRom: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func scrollTo(x: Float32, y: Float32, duration!: ?Int32 = None): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func scrollBy(deltaX: Float32, deltaY: Float32, duration!: ?Int32 = None): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func setCustomUserAgent(userAgent: String): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getCustomUserAgent(): String {
        return String()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getSecurityLevel(): SecurityLevel {
        return SecurityLevel.NoneLevel
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func isIncognitoMode(): Bool {
        return true
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func initializeWebEngine(): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func accessForward(): Bool {
        return true
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func accessBackward(): Bool {
        return true
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func onActive(): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func onInactive(): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func loadData(data: String, mimeType: String, encoding: String, baseUrl!: ?String = None,
        historyUrl!: ?String = None): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getWebId(): Int32 {
        return 0
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func requestFocus(): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func deleteJavaScriptRegister(name: String): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public static func customizeSchemes(schemes: Array<WebCustomScheme>): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func setAudioMuted(mute: Bool): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func setScrollable(enable: Bool, scrollType!: ?ScrollType = None): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setRenderProcessMode(mode: RenderProcessMode): Unit {
        return ()
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func scrollByWithResult(deltaX: Float32, deltaY: Float32): Bool {
        return true
    }

    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func runJavaScriptExt(script: ScriptValueType, callback: AsyncCallback<JsMessageExt>): Unit {
        return ()
    }
}
