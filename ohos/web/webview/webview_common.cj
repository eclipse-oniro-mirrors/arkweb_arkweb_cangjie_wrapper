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

import ohos.ffi.{ CArrString, cjArr2CArr }
import ohos.hilog.HilogChannel
import ohos.multimedia.image.PixelMap
import ohos.labels.{APILevel, Hide}

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
     @!Hide
    HttpAnchor
    |
    /**
     * The HTML::a tag with src=http + HTML::img.
     */
    @!Hide
    HttpAnchorImg
    |
    /**
     * The HTML::img tag.
     */
    @!Hide
    Img
    |
    /**
     * The map address.
     */
    @!Hide
    Map
    |
    /**
     * The phone number.
     */
    @!Hide
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

    static func fromInt32(code: Int32): WebHitTestType {
        match (code) {
            case 0 => EditText
            case 1 => Email
            case _ => Unknown
        }
    }
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
