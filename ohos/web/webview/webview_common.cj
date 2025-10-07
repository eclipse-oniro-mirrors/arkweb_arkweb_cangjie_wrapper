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
import ohos.labels.APILevel

import std.deriving.Derive


const OUT_MEMEORY: Int32 = 17100015
const LOG_DOMAIN: UInt32 = 0xD004500
let WEBVIEW_LOG = HilogChannel(0, LOG_DOMAIN, "CJ-Webview")

foreign func memcpy_s(dest: CPointer<UInt8>, destMax: UIntNative, src: CPointer<UInt8>, count: UIntNative): Int32

/**
 * Defines the security level for the page.
 *
 * @relation enum SecurityLevel
 */
@Derive[ToString, Equatable]
@!APILevel[
    22,
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum SecurityLevel {
    /**
     * Unable to determine whether it is safe or not, the non-http/https protocol used.
     *
     * @relation NONE = 0
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    NoneLevel
    |
    /**
     * Indicates the HTTPS protocol used by the page and the authentication is successful.
     *
     * @relation SECURE = 1
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Secure
    |
    /**
     * The page is insecure. For example, the HTTP protocol is used or the HTTPS protocol
     * is used but use an legacy TLS version.
     *
     * @relation WARNING = 2
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Warning
    |
    /**
     * Attempted HTTPS and failed, the authentication is failed.
     *
     * @relation DANGEROUS = 3
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Danger
    | ...

    static func fromInt32(code: Int32): SecurityLevel {
        match (code) {
            case 1 => Secure
            case 2 => Warning
            case 3 => Danger
            case _ => NoneLevel
        }
    }
}

/**
 * Enum type supplied to {@link getHitTest} for indicating the cursor node HitTest.
 *
 * @relation enum WebHitTestType
 */
@Derive[ToString, Equatable]
@!APILevel[
    22,
    syscap: "SystemCapability.Web.Webview.Core"
]
public enum WebHitTestType {
    /**
     * The edit text.
     *
     * @relation EditText = 0
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    EditText
    |
    /**
     * The email address.
     *
     * @relation Email = 1
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    Email
    |
    /**
     * Other unknown HitTest.
     *
     * @relation Unknown = 7
     */
    @!APILevel[
        22,
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
 *
 * @relation interface WebHeader
 */
@!APILevel[
    22,
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebHeader {
    /**
     * Gets the key of the request/response header.
     *
     * @relation headerKey: string
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var headerKey: String

    /**
     * Gets the value of the request/response header.
     *
     * @relation headerValue: string
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var headerValue: String

    /**
     * WebHeader constructor.
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public init(headerKey: String, headerValue: String) {
        this.headerKey = headerKey
        this.headerValue = headerValue
    }
}

/**
 * Provides element information of the click area. related to {@link getLastHitTest} method.
 *
 * @relation interface HitTestValue
 */
@!APILevel[
    22,
    syscap: "SystemCapability.Web.Webview.Core"
]
public class HitTestValue {
    /**
     * Get the hit test type.
     *
     * @relation type: WebHitTestType
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var hitTestType: WebHitTestType

    /**
     * Get the hit test extra data.
     * If the clicked area is an image or a link, the additional parameter information is it's URL address.
     *
     * @relation extra: string
     */
    @!APILevel[
        22,
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
 *
 * @relation interface HistoryItem
 */
@!APILevel[
    22,
    syscap: "SystemCapability.Web.Webview.Core"
]
public class HistoryItem {
    /**
     * Pixelmap of icon.
     *
     * @relation icon: image.PixelMap
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public let icon: ?PixelMap

    /**
     * Url of this history item.
     *
     * @relation historyUrl: string
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var historyUrl: String

    /**
     * Original request url of this history item.
     *
     * @relation historyRawUrl: string
     */
    @!APILevel[
        22,
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public var historyRawUrl: String

    /**
     * Title of this history item.
     *
     * @relation title: string
     */
    @!APILevel[
        22,
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
