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

/**
 * Created on 2024/1/29
 */
package ohos_app_cangjie_entry

import std.unittest.testmacro.*
import ohos.base.*
import std.runtime.*
import std.time.*
import ohos.arkui.state_macro_manage.rawfile
internal import ohos.resource_manager.AppResource
import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.base.*
import std.sync.AtomicBool
import std.sync.Monitor
import ohos.web.webview.*
import ohos.multimedia.image.PixelMap
import ohos.business_exception.*

let LongURL = "1" * 50000

@Test
class Test_webview {
    static let webInitialized = (AtomicBool(false), Monitor())
    let raw = @rawfile("page1.html")
    let wc = WebviewController(webTag: "test")
    let wh = WebHeader("key", "value")
    var resultCallback = {
        errorCode: Option<BusinessException>, data: Option<String> => match (errorCode) {
            case Some(e) => @Expect(true)
            case _ => match (data) {
                case Some(value) => @Expect(true)
                case _ => @Expect(true)
            }
        }
    }

    protected func beforeAll() {
        synchronized(webInitialized[1]) {
            if (!webInitialized[0].load()) {
                webInitialized[1].wait()
            }
            Test_webview.webInitialized[0].store(false)
        }
    }

    override func afterAll(): Unit {
        gc(heavy: true)
        sleep(Duration.second)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getTitle() {
        let webController = getWebViewController("")
        let title = webController.getTitle()
        loggerInfo("title is ${title}")
        @Expect(title, "Page1")
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getUserAgent() {
        let webController = getWebViewController("")
        let userAgent = webController.getUserAgent()
        @Expect(userAgent.contains("Mozilla"))
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getUrl() {
        let webController = getWebViewController("")
        let url = webController.getUrl()
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getOriginalUrl() {
        let webController = getWebViewController("")
        webController.getOriginalUrl() // not fixed
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_pageUp_pageDown() {
        let webController = getWebViewController("")
        webController.pageUp(false)
        webController.pageUp(true)
        webController.pageDown(false)
        webController.pageDown(true)
    }

    @TestCase
    @Skip
    func test_scrollTo_scrollBy() {
        let webController = getWebViewController("")
        webController.scrollTo(50.0, 50.0)
        webController.scrollBy(50.0, 50.0)
        webController.scrollTo(0.0, 0.0, duration: 100)
        webController.scrollBy(50.0, 50.0, duration: -20)
        try {
            webController.scrollTo(-1.0, -1.0)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
        try {
            webController.scrollBy(-1.0, -1.0)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_forward_backward_backOrForward() {
        let webController = getWebViewController("")
        webController.forward()
        webController.backward()
        webController.backOrForward(1)
        webController.backOrForward(-1)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getPageHeight() {
        let webController = getWebViewController("")
        webController.getPageHeight() // not fixed
    }


    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_loadUrlRawFile() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("load").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_loadUrlRawFile2() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("load2").perform(click())
    }

    @Skip
    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_setCustomUserAgent() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("setCustomUserAgent").perform(click())
        let webController = getWebViewController("")
        try {
            webController.setCustomUserAgent("")
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }



    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_runJavaScript() {
        let webController = getWebViewController("")
        try {
            webController.runJavaScript("test", resultCallback)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_registerJavaScriptProxy() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("registerJavaScriptProxy").perform(click())
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("refresh").perform(click())
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("runJavaScript").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_zoom() {
        let webController = getWebViewController("")
        webController.zoom(3.0)
        webController.zoomIn()
        webController.zoomOut()
        try {
            webController.zoom(-1.0)
        } catch (e: BusinessException) {
            @Expect(e.code, 401)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getHitTestValue() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("getHitTestValue").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_storeWebArchive() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("storeWebArchive").perform(click())
        let webController = getWebViewController("")
        try {
            webController.storeWebArchive("test", true, resultCallback)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100003)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_stop() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("stop").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_enableSafeBrowsing() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("enableSafeBrowsing").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_isSafeBrowsingEnabled() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("isSafeBrowsingEnabled").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getSecurityLevel() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("getSecurityLevel").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_isIncognitoMode() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("isIncognitoMode").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getBackForwardEntries() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("getBackForwardEntries").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getItemAtIndex() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("getItemAtIndex").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_clearHistory() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("clearHistory").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_removeCache() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("removeCache").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getBackForwardEntries2() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("getBackForwardEntries").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_accessStep() {
        let webController = getWebViewController("")
        let bool = webController.accessStep(1)
        @Expect(bool, false)
        try {
            webController.accessStep(10000)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
            return true
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getTitle2() {
        let webController = getWebViewController("")
        let title = webController.getTitle()
        loggerInfo("title is ${title}")
        @Expect(title, "Page2")
    }


    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getHitTest() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("getHitTest").perform(click())
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_webController() {
        let webController = WebviewController(webTag: "web_test_tag")
        try {
            webController.accessBackward()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
            return
        }
        return
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func rawfile() {
        let webController = getWebViewController("")
        webController.loadUrl("resource://rawfile/page1.html")
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_loadUrl_exception() {
        try {
            wc.loadUrl("test", headers: Array<WebHeader>())
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.loadUrl("test", headers: [wh])
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.loadUrl(raw, headers: [wh])
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_funcs_exception() {
        try {
            wc.refresh()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getUserAgent()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.setCustomUserAgent("test")
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getPageHeight()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getTitle()
            @Expect(false)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getCustomUserAgent()
            @Expect(false)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_runJS_exception() {
        try {
            wc.runJavaScript("test", resultCallback)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.registerJavaScriptProxy(Array<(String) -> String>(), "test", ["1"])
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.registerJavaScriptProxy(Array<(String) -> String>(), "test", Array<String>())
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.registerJavaScriptProxy([{p: String => "1"}], "test", ["1"])
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getUrl_exception() {
        try {
            wc.getUrl()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getOriginalUrl()
            @Expect(false)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_pageUpDown_exception() {
        try {
            wc.pageUp(true)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.pageDown(true)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_scroll_exception() {
        try {
            wc.scrollTo(1.0, 1.0)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.scrollBy(1.0, 1.0)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_backOrForward_exception() {
        try {
            wc.forward()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.backward()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.backOrForward(1)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_zoom_exception() {
        try {
            wc.zoom(1.0)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.zoomIn()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.zoomOut()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_funs2_exception() {
        try {
            wc.getHitTestValue()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.clearHistory()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.accessStep(1)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getHitTest()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.storeWebArchive("test", true, resultCallback)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.enableSafeBrowsing(true)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.isSafeBrowsingEnabled()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getSecurityLevel()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_funs3_exception() {
        try {
            wc.isIncognitoMode()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.removeCache(true)
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.getBackForwardEntries()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }

        try {
            wc.stop()
        } catch (e: BusinessException) {
            @Expect(e.code, 17100001)
        }
    }


    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_setWebDebuggingAccess() {
        WebviewController.setWebDebuggingAccess(true)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_refresh() {
        let webController = getWebViewController("")
        webController.refresh()
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_loadUrl() {
        let webController = getWebViewController("")
        try {
            webController.loadUrl("www.baidu.com")
            webController.loadUrl("www.baidu.com", headers: [WebHeader("headerKey", "headerValue")])
        } catch (e: BusinessException) {
            @Expect(true)
        }
        let title = webController.getTitle()
        loggerInfo(title)
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_getCustomUserAgent() {
        sleepFor(300.milliSecond)
        let webController = getWebViewController("")
        let userAgent = webController.getCustomUserAgent()
        @Expect(userAgent.contains("Mozilla"))
    }

    @TestCase
    @Tag[APILevel22, TestLevel0]
    func test_postMessage() {
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("loadmessage").perform(click())
        Screen.getTheOnlyUiComponentWhoseIdEqualsTo("refresh").perform(click())
        click(at: Point(52, 1212))
    }

    @TestCase
    @Tag[APILevel20, TestLevel0]
    func test_configCookie() {
        Screen
            .getTheOnlyUiComponentWhoseIdEqualsTo("testConfigCookie")
            .perform(click())
    }
}
