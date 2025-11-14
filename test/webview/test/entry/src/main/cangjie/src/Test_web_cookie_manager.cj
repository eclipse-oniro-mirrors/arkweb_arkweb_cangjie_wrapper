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

package ohos_app_cangjie_entry

import ohos.web.webview.*
import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.base.*

@Test
class Test_web_cookie_manager {
    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_configCookie_fetchCookie() {
        sleepFor(2.second)
        let value = WebCookieManager.fetchCookie("https://www.example.com")
        loggerInfo("[WebCookieManager]: value is ${value}")
        @Expect(value, "a=b,c=d,e=f")
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_putAcceptCookieEnabled_isCookieAllowed() {
        WebCookieManager.setAcceptCookiesEnabled(true)
        var result = WebCookieManager.isCookieAllowed()
        @Expect(result, true)
        WebCookieManager.setAcceptCookiesEnabled(false)
        result = WebCookieManager.isCookieAllowed()
        @Expect(result, false)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_putAcceptThirdPartyCookieEnabled_isThirdPartyCookieAllowed() {
        WebCookieManager.setAcceptThirdPartyCookieEnabled(true)
        sleepFor(1.second)
        var result = WebCookieManager.isThirdPartyCookieAllowed()
        @Expect(result, true)
        WebCookieManager.setAcceptThirdPartyCookieEnabled(false)
        sleepFor(1.second)
        result = WebCookieManager.isThirdPartyCookieAllowed()
        @Expect(result, false)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_existCookie_clearAllCookies() {
        var bool = WebCookieManager.hasCookie(incognito: true)
        @Expect(bool, false)
        bool = WebCookieManager.hasCookie(incognito: false)
        @Expect(bool, true)
        WebCookieManager.clearAllCookies()
        WebCookieManager.clearSessionCookie()
        bool = WebCookieManager.hasCookie(incognito: false)
        @Expect(bool, false)
    }
}