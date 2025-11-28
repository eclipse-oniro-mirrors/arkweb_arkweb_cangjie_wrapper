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

internal import ohos.base.LengthProp
internal import ohos.arkui.component.Column
internal import ohos.arkui.component.Row
internal import ohos.arkui.component.Button
internal import ohos.arkui.component.Text
internal import ohos.arkui.component.CustomView
internal import ohos.arkui.component.CJEntry
internal import ohos.arkui.component.loadNativeView
internal import ohos.arkui.component.FontWeight
internal import ohos.arkui.state_management.SubscriberManager
internal import ohos.arkui.state_management.ObservedProperty
internal import ohos.arkui.state_management.LocalStorage
internal import ohos.resource.*
import ohos.arkui.state_macro_manage.Entry
import ohos.arkui.state_macro_manage.Component
import ohos.arkui.state_macro_manage.State
import ohos.arkui.state_macro_manage.r
import ohos.arkui.state_management.*
import ohos.arkui.state_macro_manage.*
import ohos.base.*
import ohos.arkui.component.web.Web
import ohos.web.webview.*
import ohos.business_exception.*

let callback: AsyncCallback<String> = {
    errorCode: Option<BusinessException>, data: Option<String> => match (errorCode) {
        case Some(e) => loggerError("callback error: errcode is ${e.code}")
        case _ => match (data) {
            case Some(value) =>
                loggerInfo("callback: get data successfully and data is ${value.toArray()}")
                loggerInfo("callback: get data successfully and data is ${value}")
            case _ => loggerError("callback: data is null")
        }
    }
}

public func getWebViewController(str: String): WebviewController {
    match (AppStorage.get<WebviewController>("controller${str}")) {
        case None => throw Exception("failed to get controller")
        case Some(abilityContext) => abilityContext
    }
}

@Entry
@Component
class EntryView {
    @State
    var sendFromCangjie = "Send this message from cangjie to HTML"
    @State
    var receivedFromHtml = "Display received message send from HTML"
    @State
    var runOnce = false
    @State
    var muted: Bool = false
    @State
    var msg1 = ""
    @State
    var msg2 = ""
    let webController = getWebViewController("")
    let webCtrl = WebviewController(webTag: "test_web_tag")
    let urltrustList: String = "{\"UrlPermissionList\":[{\"scheme\":\"http\", \"host\":\"trust.example.com\", \"port\":80, \"path\":\"test\"}]}"

    func build() {
        Row {
            Column {
                Text(this.receivedFromHtml).fontSize(6)
                //jsExt
                Text(this.msg1).fontSize(6)
                Text(this.msg2).fontSize(6)

                Button("loadpage")
                    .onClick ({
                        evt => webController.loadUrl(@rawfile("message.html"))
                    })
                    .fontSize(5)
                    .height(5)
                    .id("loadmessage")

                Button("loadpage")
                    .onClick ({
                        evt =>
                        loggerInfo("load page2")
                        webController.loadUrl(@rawfile("page2.html"))
                    })
                    .fontSize(5)
                    .height(5)
                    .id("load")
                Button("loadpage2")
                    .onClick ({
                        evt =>
                        loggerInfo("load page2")
                        webController.loadUrl(@rawfile("page2.html"), headers: [WebHeader("headerKey", "headerValue")])
                    })
                    .fontSize(5)
                    .height(5)
                    .id("load2")
                Button("setCustomUserAgent")
                    .onClick ({
                        evt =>
                        loggerInfo("setCustomUserAgent")
                        webController.setCustomUserAgent("ua")
                    })
                    .fontSize(5)
                    .height(5)
                    .id("setCustomUserAgent")
                Button("registerJavaScriptProxy")
                    .onClick ({
                        evt =>
                        loggerInfo("registerJavaScriptProxy")
                        let funcA1 = {
                            a: String =>
                            loggerInfo("funcA1 ${a}")
                            return "funcA1 " + a
                        }
                        let funcA2 = {
                            a: String =>
                            loggerInfo("funcA2 ${a}")
                            return "funcA2 " + a
                        }
                        let funcA3 = {
                            a: String =>
                            loggerInfo("funcA3 ${a}")
                            return "funcA3 " + a
                        }
                        let funcB1 = {
                            a: String =>
                            loggerInfo("funcB1 ${a}")
                            return "funcB1 " + a
                        }
                        let funcB2 = {
                            a: String =>
                            loggerInfo("funcB2 ${a}")
                            return "funcB2 " + a
                        }
                        let funcB3 = {
                            a: String =>
                            loggerInfo("funcB3 ${a}")
                            return "funcB3 " + a
                        }
                        let funcsA = [funcA1, funcA2, funcA3]
                        let funcsB = [funcB1, funcB2, funcB3]
                        let methodListA = ["testFunA1", "testFunA2", "testFunA3"]
                        let methodListB = ["testFunB1", "testFunB2", "testFunB3"]
                        try {
                            webController.registerJavaScriptProxy(funcsA, "testObjA", methodListA)
                        } catch (e: Exception) {
                            loggerInfo(e.message)
                        }
                        webController.registerJavaScriptProxy(funcsA, "testObjA", methodListA)
                        webController.registerJavaScriptProxy(funcsB, "testObjB", methodListB)
                    })
                    .fontSize(5)
                    .height(5)
                    .id("registerJavaScriptProxy")

                Button("refresh")
                    .onClick ({
                        evt =>
                        loggerInfo("refresh")
                        webController.reload()
                    })
                    .fontSize(5)
                    .height(5)
                    .id("refresh")
                Button("runJavaScript")
                    .onClick ({
                        evt =>
                        loggerInfo("runJavaScript")
                        webController.runJavaScript("testObjA.testFunA2('someData')", callback)
                        webController.runJavaScript("testObjB.testFunB2('someData')", callback)
                    })
                    .fontSize(5)
                    .height(5)
                    .id("runJavaScript")

                Button("storeWebArchive")
                    .onClick ({
                        evt =>
                        loggerInfo("storeWebArchive")
                        webController.storeWebArchive("/data/storage/el2/base/", true, callback)
                    })
                    .fontSize(5)
                    .height(5)
                    .id("storeWebArchive")
                Button("stop").onClick ({
                    evt =>
                    loggerInfo("stop")
                    webController.stop()
                })
                    .fontSize(5)
                    .height(5)
                    .id("stop")

                Button("enableSafeBrowsing")
                    .onClick ({
                        evt =>
                        loggerInfo("enableSafeBrowsing")
                        webController.enableSafeBrowsing(true)
                    })
                    .fontSize(5)
                    .height(5)
                    .id("enableSafeBrowsing")

                Button("isSafeBrowsingEnabled")
                    .onClick ({
                        evt =>
                        loggerInfo("isSafeBrowsingEnabled")
                        let bool = webController.isSafeBrowsingEnabled()
                        loggerInfo("isSafeBrowsingEnabled -- ${bool}")
                    })
                    .fontSize(5)
                    .height(5)
                    .id("isSafeBrowsingEnabled")

                Button("getSecurityLevel")
                    .onClick ({
                        evt =>
                        loggerInfo("getSecurityLevel")
                        let securityLevel = webController.getSecurityLevel()
                        loggerInfo("get SecurityLevel: ${securityLevel.toString()}")
                        match (securityLevel) {
                            case SecurityLevel.NoneLevel => loggerInfo("getSecurityLevel returns NoneLevel")
                            case SecurityLevel.Secure => loggerInfo("getSecurityLevel returns Secure")
                            case SecurityLevel.Warning => loggerInfo("getSecurityLevel returns Warning")
                            case SecurityLevel.Dangerous => loggerInfo("getSecurityLevel returns Dangerous")
                            case _ => throw Exception("unsupported enum constructor")
                        }
                    })
                    .fontSize(5)
                    .height(5)
                    .id("getSecurityLevel")

                Button("isIncognitoMode")
                    .onClick ({
                        evt =>
                        loggerInfo("isIncognitoMode")
                        let bool = webController.isIncognitoMode()
                        loggerInfo("isIncognitoMode -- ${bool}")
                    })
                    .fontSize(5)
                    .height(5)
                    .id("isIncognitoMode")

                Button("getBackForwardEntries")
                    .onClick ({
                        evt =>
                        loggerInfo("getBackForwardEntries")
                        let backForwardList = webController.getBackForwardEntries()
                        loggerInfo("backForwardList currentIndex is ${backForwardList.currentIndex}")
                        loggerInfo("backForwardList size is ${backForwardList.size}")
                    })
                    .fontSize(5)
                    .height(5)
                    .id("getBackForwardEntries")

                Button("getItemAtIndex")
                    .onClick ({
                        evt =>
                        loggerInfo("getItemAtIndex")
                        let backForwardList = webController.getBackForwardEntries()
                        loggerInfo("Current size is ${backForwardList.size}.")
                        loggerInfo("Current index is ${backForwardList.currentIndex}.")
                        let historyItem = backForwardList.getItemAtIndex(backForwardList.currentIndex)
                        loggerInfo("Current historyUrl is ${historyItem.historyUrl}.")
                        loggerInfo("Current historyRawUrl is ${historyItem.historyRawUrl}.")
                        loggerInfo("Current title is ${historyItem.title}.")
                        if (let Some(pixelMap) <- historyItem.icon) {
                            let byteInfo = pixelMap.getPixelBytesNumber()
                            loggerInfo("icon byteInfo is ${byteInfo}")
                        }
                    })
                    .fontSize(5)
                    .height(5)
                    .id("getItemAtIndex")

                Button("removeCache")
                    .onClick ({
                        evt =>
                        loggerInfo("removeCache")
                        webController.removeCache(false)
                    })
                    .fontSize(5)
                    .height(5)
                    .id("removeCache")

                Button("clearHistory")
                    .onClick ({
                        evt =>
                        loggerInfo("clearHistory")
                        webController.clearHistory()
                    })
                    .fontSize(5)
                    .height(5)
                    .id("clearHistory")

                Button("testConfigCookie").onClick ({
                    _ =>
                    try {
                        WebCookieManager.clearAllCookies()
                        WebCookieManager.configCookie("https://www.example.com/", "test=lltConfigCookieSync", incognito: false)
                        let cookie = WebCookieManager.fetchCookie("https://www.example.com/", incognito: false)
                        loggerInfo("cookie: ${cookie}")
                    } catch (e: BusinessException) {
                        loggerError("testConfigCookie error ${e}")
                    }
                })
                .fontSize(5)
                .height(5)
                .id("testConfigCookie")

                Button("scroll").onClick ({
                    _ =>
                    try {
                        let webController = getWebViewController("3")
                        webController.scrollTo(50.0, 50.0)
                        webController.scrollBy(50.0, 50.0)
                        webController.scrollTo(0.0, 0.0, duration: 100)
                        webController.scrollBy(50.0, 50.0, duration: -20)
                    } catch (e: BusinessException) {
                        loggerError("scroll error ${e}")
                    }
                })
                .fontSize(5)
                .height(5)
                .id("scroll")

                // cert
                Web(src: "https://www.example.com", controller: getWebViewController("5")).height(30)

                Web(src: @rawfile("page1.html"), controller: getWebViewController(""))
                    .onPageBegin({
                        evt => loggerInfo("page begin url: ${evt.url}")
                    })
                    .onPageEnd(
                        {
                            evt =>
                            loggerInfo("page end url: ${evt.url}")
                            if (runOnce) {
                                return
                            }
                            synchronized(Test_webview.webInitialized[1]) {
                                Test_webview
                                    .webInitialized[0]
                                    .store(true)
                                Test_webview
                                    .webInitialized[1]
                                    .notifyAll()
                            }

                            runOnce = true
                        }
                    )
                    .height(100)
                Web(src: @rawfile("page1.html"), controller: getWebViewController("2")).height(100)
                Web(src: @rawfile("scroll.html"), controller: getWebViewController("3"))
            }.width(100.percent)
        }.height(100.percent)
    }
}
