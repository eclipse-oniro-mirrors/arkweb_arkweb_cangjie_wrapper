/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// The Cangjie API is in Beta. For details on its capabilities and limitations, please refer to the README file.

package ohos.web.webview

import ohos.hilog.HilogChannel
import ohos.multimedia.image.PixelMap
import ohos.labels.{APILevel, Hide}
import ohos.ffi.{RemoteDataLite, releaseFFIData, Callback0Param}
import ohos.callback_invoke.Callback

import std.deriving.Derive

const LOG_DOMAIN: UInt32 = 0xD004500
let WEBVIEW_LOG = HilogChannel(0, LOG_DOMAIN, "CJ-Webview")

foreign func memcpy_s(dest: CPointer<UInt8>, destMax: UIntNative, src: CPointer<UInt8>, count: UIntNative): Int32

/**
 * Defines the security level for the page.
 */
@Derive[ToString, Equatable]
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum SecurityLevel {
    /**
     * Unable to determine whether it is safe or not, the non-http/https protocol used.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    NoneLevel
    |
    /**
     * Indicates the HTTPS protocol used by the page and the authentication is successful.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Secure
    |
    /**
     * The page is insecure. For example, the HTTP protocol is used or the HTTPS protocol
     * is used but use an legacy TLS version.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Warning
    |
    /**
     * Attempted HTTPS and failed, the authentication is failed.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Dangerous
    | ...

    static func fromInt32(code: Int32): SecurityLevel {
        match (code) {
            case 1 => Secure
            case 2 => Warning
            case 3 => Dangerous
            case _ => NoneLevel
        }
    }
}

/**
 * Enum type supplied to getHitTest for indicating the cursor node HitTest.
 */
@Derive[ToString, Equatable]
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum WebHitTestType {
    /**
     * The edit text.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    EditText
    |
    /**
     * The email address.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Email
    |
    /**
     * The HTML::a tag with src=http.
     */
     @!Hide[isChecked: true]
    HttpAnchor
    |
    /**
     * The HTML::a tag with src=http + HTML::img.
     */
    @!Hide[isChecked: true]
    HttpAnchorImg
    |
    /**
     * The HTML::img tag.
     */
    @!Hide[isChecked: true]
    Img
    |
    /**
     * The map address.
     */
    @!Hide[isChecked: true]
    Map
    |
    /**
     * The phone number.
     */
    @!Hide[isChecked: true]
    Phone
    |
    /**
     * Other unknown HitTest.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Unknown
    | ...
}

/**
 * Defines the Web's request/response header.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebHeader {
    /**
     * Gets the key of the request/response header.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var headerKey: String

    /**
     * Gets the value of the request/response header.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var headerValue: String

    /**
     * WebHeader constructor.
     *
     * @param  { String } headerKey - The key of the request/response header.
     * @param  { String } headerValue - The value of the request/response header.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public init(headerKey: String, headerValue: String) {
        this.headerKey = headerKey
        this.headerValue = headerValue
    }
}

/**
 * Provides element information of the click area. related to getLastHitTest method.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class HitTestValue {
    /**
     * Get the hit test type.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var hitTestType: WebHitTestType

    /**
     * Get the hit test extra data.
     * If the clicked area is an image or a link, the additional parameter information is it's URL address.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var extra: String

    init(hitTestType: WebHitTestType, extra: String) {
        this.hitTestType = hitTestType
        this.extra = extra
    }
}

/**
 * Provides information for history item in BackForwardList.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class HistoryItem {
    /**
     * Pixelmap of icon.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var icon: ?PixelMap

    /**
     * Url of this history item.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var historyUrl: String

    /**
     * Original request url of this history item.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var historyRawUrl: String

    /**
     * Title of this history item.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var title: String

    /**
     * HistoryItem constructor.
     */
    init(icon: ?PixelMap, historyUrl: String, historyRawUrl: String, title: String) {
        this.icon = icon
        this.historyUrl = historyUrl
        this.historyRawUrl = historyRawUrl
        this.title = title
    }
}

/**
 * Placeholder for the ArrayBuffer type, which is referenced by the ScriptValueType API but is not
 * yet officially defined in the Cangjie SDK base layer.
 *
 * NOTE: This is a temporary shim for compilation. Once ArrayBuffer is officially provided by the
 * SDK, this local definition must be removed, and the ArrayBufferValue branch of runJavaScriptExt
 * must be implemented with real byte conversion. The ToString and Equatable implementations only
 * exist to satisfy the @Derive requirements of ScriptValueType.
 */
public type ArrayBuffer = Array<Byte>

class WebCustomSchemeImpl {
    var schemeName_: String
    var isSupportCORS_: Bool
    var isSupportFetch_: Bool
    var isCodeCacheSupported_: ?Bool = None

    init(schemeName: String, isSupportCORS: Bool, isSupportFetch: Bool) {
        this.schemeName_ = schemeName
        this.isSupportCORS_ = isSupportCORS
        this.isSupportFetch_ = isSupportFetch
    }
}

/**
 * Defines a custom URL scheme.
 */
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebCustomScheme {
    private var webCustomSchemeImpl: WebCustomSchemeImpl

    /**
     * Custom protocol name. The maximum length is 32, and only lowercase letters, digits, '.', '+', and '-' are
     * supported. It must start with a letter. If the preceding restrictions are not met, the custom protocol
     * configuration does not take effect.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop schemeName: String {
        get() {
            return webCustomSchemeImpl.schemeName_
        }
        set(value) {
            webCustomSchemeImpl.schemeName_ = value
        }
    }

    /**
     * Whether to support cross-origin resource sharing (CORS).
     *
     * The value **true** means to support cross-origin resource sharing (CORS), and **false** means the opposite.
     *
     * Default value: **true**.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop isSupportCORS: Bool {
        get() {
            return webCustomSchemeImpl.isSupportCORS_
        }
        set(value) {
            webCustomSchemeImpl.isSupportCORS_ = value
        }
    }

    /**
     * Whether to support fetch requests.
     *
     * The value **true** means to support fetch requests, and **false** means the opposite.
     *
     * Default value: **true**.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop isSupportFetch: Bool {
        get() {
            return webCustomSchemeImpl.isSupportFetch_
        }
        set(value) {
            webCustomSchemeImpl.isSupportFetch_ = value
        }
    }

    /**
     * Whether JavaScript resources of the scheme with this option set support code cache generation.
     *
     * **true** indicates that JavaScript resources of the scheme with this option set support code cache generation,
     * and **false** indicates that they do not support code cache generation.
     *
     * Default value: false.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public mut prop isCodeCacheSupported: ?Bool {
        get() {
            return webCustomSchemeImpl.isCodeCacheSupported_
        }
        set(value) {
            webCustomSchemeImpl.isCodeCacheSupported_ = value
        }
    }

    /**
     * Creates a **WebCustomScheme** object.
     * Initializes the custom URL scheme with the specified scheme name.
     *
     * @param { String } schemeName - Custom protocol name.
     * @param { Bool } isSupportCORS - Whether to support cross-origin resource sharing (CORS).
     *     The value **true** means to support cross-origin resource sharing (CORS), and **false** means the opposite.
     *     Default value: **true**.
     * @param { Bool } isSupportFetch - Whether to support fetch requests.
     *     The value **true** means to support fetch requests, and **false** means the opposite.
     *     Default value: **true**.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public init(schemeName: String, isSupportCORS: Bool, isSupportFetch: Bool) {
        this.webCustomSchemeImpl = WebCustomSchemeImpl(schemeName, isSupportCORS, isSupportFetch)
    }
}

/**
 * Registers a one-time callback for web events of the specified type. Currently, only **webInited** is supported.
 * This callback is triggered when the Web engine initialization is complete.
 *
 * When the first **Web** component is loaded in an app, the Web engine is initialized, and the once() callback is not
 * triggered when other **Web** components are subsequently loaded in the same app. When the app destroys the last
 * **Web** component, if the first **Web** component is loaded again, the app re-enters the Web engine initialization
 * process.
 *
 * @param { String } eventType - Type of the Web event. Currently, only **"webInited"** (Web engine initialization complete)
 *     is supported.
 * @param { Callback<Unit> } callback - Callback invoked when the Web engine initialization is complete.
 */
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public func once(eventType: String, callback: Callback<Unit>): Unit {
    unsafe {
        let cType = LibC.mallocCString(eventType)
        let wrapper = { => callback(()) }
        let lambdaData = Callback0Param<Unit>(wrapper)
        let errCode = FfiOHOSWebviewOnce(cType, lambdaData.getID())
        LibC.free(cType)
        throwIfNotSuccess(errCode, "webview", "once")
    }
}

/**
 * Implements a **WebStorage** object to manage the Web SQL database and HTML5 Web Storage APIs. All **Web**
 * components in an application share a **WebStorage** object.
 *
 * **NOTE**
 * - You must load the **Web** component before calling the APIs in **WebStorage**.
 */
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebStorage {
    init() {}

    /**
     * Deletes all storage data used by JavaScript storage APIs, including the Web SQL Database and HTML5-supported Web
     * storage APIs.
     *
     * @param { ?Bool } [incognito] - Whether to delete all data in the Web SQL Database in incognito mode. The value
     *     **true** means to delete all data in the Web SQL Database in incognito mode, and **false** means the
     *     opposite.
     *     Default value: **false**.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func deleteAllData(incognito!: ?Bool = false): Unit {
        unsafe {
            FfiWebStorageDeleteAllData(incognito ?? false)
        }
    }
}

/**
 * Defines the script type of the **runJavaScriptExt** API. The JavaScript script to be executed can be passed as a
 * string or as a byte array.
 */
@Derive[ToString, Equatable]
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum ScriptValueType {
    /**
     * The JavaScript script is passed as a string.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    StringValue(String)
    |
    /**
     * The JavaScript script is passed as a byte array.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    ArrayBufferValue(ArrayBuffer)
    | ...
}

class JsMessageExtImpl <: RemoteDataLite {
    init(id: Int64) {
        super(id)
    }

    ~init() {
        releaseFFIData(myDataId)
    }

    prop id: Int64 {
        get() {
            return getID()
        }
    }
}

/**
 * JsMessageExt is a data class in the ArkWeb framework used to encapsulate the result returned after executing a
 * JavaScript script through the **runJavaScriptExt** API. Unlike the conventional runJavaScript API,
 * runJavaScriptExt supports richer return value types, and JsMessageExt provides a type-safe way to access these
 * diverse return results. Developers first obtain the data type through the getType method of JsMessageExt, and then
 * call the corresponding get method to retrieve the specific value.
 */
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class JsMessageExt {
    private var jsMessageExtImpl: JsMessageExtImpl

    init(id: Int64) {
        this.jsMessageExtImpl = JsMessageExtImpl(id)
    }

    /**
     * Obtains string-type data of the data object.
     *
     * @returns { String } String-type data obtained after the script of the runJavaScriptExt API is executed.
     * @throws { BusinessException } 17100014 - The type and value of the message do not match.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getString(): String {
        var code: Int32 = 0
        let ret = unsafe {
            FfiOHOSJsMessageExtImplGetString(jsMessageExtImpl.id, inout code)
        }
        throwIfNotSuccess(code, "JsMessageExt", "getString")
        return getStringAndFree(ret)
    }
}

/**
 * Enumerates the ArkWeb renderer subprocess mode types. You can select the appropriate mode based on the app's
 * requirements for memory usage and renderer process isolation.
 */
@Derive[ToString, Equatable]
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum RenderProcessMode {
    /**
     * ArkWeb single render subprocess mode. In this mode, multiple **Web** components share one render subprocess.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Single
    |
    /**
     * ArkWeb multi-render subprocess mode. In this mode, each **Web** component has a rendering subprocess.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Multiple
    | ...

    func getValue(): Int32 {
        match (this) {
            case Single => 0
            case Multiple => 1
            // An invalid value falls back to the multi-render subprocess mode by default.
            case _ => 1
        }
    }
}

/**
 * Enumerates the scroll types for **setScrollable**.
 */
@Derive[ToString, Equatable]
@!APILevel[
    since: "26.1.0",
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum ScrollType {
    /**
     * Scroll event, which represents web page scrolling generated through the touchscreen, touchpad, or mouse wheel.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Event
    | ...

    func getValue(): Int32 {
        match (this) {
            case Event => 0
            case _ => 0
        }
    }
}
