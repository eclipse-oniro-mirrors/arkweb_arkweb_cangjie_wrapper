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

import ohos.business_exception.BusinessException
import ohos.labels.APILevel

const MAX_STRING_LENGTH: Int64 = 40960

/**
 * Provides methods for managing the web cookies.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebCookieManager {
    init() {}

    /**
     * Gets all cookies for the given URL.
     *
     * @param { String } url - The URL for which the cookies are requested.
     * @param { Bool } [incognito] - true gets all cookies for the given URL
     *                                in incognito mode; false otherwise.
     * @returns { String } Resolved after the cookies of given URL have been gotten.
     * @throws { BusinessException } 17100002 - URL error. No valid cookie found for the specified URL.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public static func fetchCookie(url: String, incognito!: Bool = false): String {
        if (url.size > MAX_STRING_LENGTH) {
            throw BusinessException(INVALID_URL, getErrorMsg(INVALID_URL))
        }
        var cookie: String = ""
        var errCode: Int32 = 0
        unsafe {
            let curl = LibC.mallocCString(url)
            let cvalue = FfiOHOSCookieMgrFetchCookieSync(curl, incognito, inout errCode)
            try {
                throwIfNotSuccess(errCode, "WebCookieManager", "fetchCookie")
                cookie = cvalue.toString()
            } finally {
                LibC.free(curl)
                LibC.free(cvalue)
            }
        }
        return cookie
    }

    /**
     * Set a single cookie (key-value pair) for the given URL.
     *
     * @param { String } url - The URL for which the cookie is to be set.
     * @param { String } value - The cookie as a string, using the format of the 'Set-Cookie' HTTP response header.
     * @param { Bool } [incognito] - true set a single cookie (key-value pair) for the given URL
     *                                in incognito mode; false otherwise.
     * @throws { BusinessException } 17100002 - URL error. No valid cookie found for the specified URL.
     * @throws { BusinessException } 17100005 - The provided cookie value is invalid. It must follow the format specified 
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public static func configCookie(url: String, value: String, incognito!: Bool = false): Unit {
        if (url.size > MAX_STRING_LENGTH || value.size > MAX_STRING_LENGTH) {
            throw BusinessException(INVALID_URL, getErrorMsg(INVALID_URL))
        }
        unsafe {
            var errCode: Int32 = 0
            try (
                curl = LibC.mallocCString(url).asResource(),
                cvalue = LibC.mallocCString(value).asResource()
            ) {
                errCode = FfiOHOSCookieMgrConfigCookieSync(curl.value, cvalue.value, incognito)
            }
            throwIfNotSuccess(errCode, "WebCookieManager", "configCookie")
        }
    }

    /**
     * Get whether the instance can send and accept cookies.
     *
     * @returns { Bool } True if the instance can send and accept cookies else false.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func isCookieAllowed(): Bool {
        unsafe {
            return FfiOHOSCookieMgrIsCookieAllowed()
        }
    }

    /**
     * Set whether the instance should send and accept cookies.
     * By default this is set to be true.
     *
     * @param { Bool } accept - Whether the instance should send and accept cookies.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setAcceptCookiesEnabled(accept: Bool): Unit {
        unsafe {
            FfiOHOSCookieMgrPutAcceptCookieEnabled(accept)
        }
    }

    /**
     * Get whether the instance can send and accept thirdparty cookies.
     *
     * @returns { Bool } True if the instance can send and accept thirdparty cookies else false.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func isThirdPartyCookieAllowed(): Bool {
        unsafe {
            return FfiOHOSCookieMgrIsThirdPartyCookieAllowed()
        }
    }

    /**
     * Set whether the instance should send and accept thirdparty cookies.
     * By default this is set to be false.
     *
     * @param { Bool } accept - Whether the instance should send and accept thirdparty cookies.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setAcceptThirdPartyCookieEnabled(accept: Bool): Unit {
        unsafe {
            FfiOHOSCookieMgrPutAcceptThirdPartyCookieEnabled(accept)
        }
    }

    /**
     * Check whether exists any cookies.
     *
     * @param { Bool } [incognito] - true check whether exists any cookies.
     *                                in incognito mode; false otherwise.  The default value is false.
     * @returns { Bool } True if exists more than one cookie else false;
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func hasCookie(incognito!: Bool = false): Bool {
        unsafe {
            return FfiOHOSCookieMgrExistCookie(incognito)
        }
    }

    /**
     * Remove all cookies.
     *
     * @param { Bool } [incognito] - true remove all cookies in incognito mode;
     *                               false otherwise. The default value is false.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func clearAllCookies(incognito!: Bool = false): Unit {
        unsafe {
            FfiOHOSCookieMgrClearAllCookiesSync(incognito)
        }
    }

    /**
     * Delete the session cookies.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func clearSessionCookie(): Unit {
        unsafe {
            FfiOHOSCookieMgrClearSessionCookieSync()
        }
    }
}
