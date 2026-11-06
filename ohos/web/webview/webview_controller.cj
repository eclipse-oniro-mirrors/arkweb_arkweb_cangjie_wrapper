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

import ohos.base.ResourceStr
import ohos.labels.APILevel
import ohos.ffi.{RemoteDataLite, RetDataCString, RetDataI64, CArrString, CArrI64, releaseFFIData,
    Callback1Param, toArrayCString, freeArrCString}
import ohos.business_exception.{BusinessException, AsyncCallback}
import std.collection.HashSet
import ohos.arkui.component.util.transResourceMediaToString

/**
 * WebviewController can control various behaviors of Web components
 * (including page navigation, declaring cycle state, JavaScript interaction and so on).
 * A WebviewController object can only control one Web component,
 * and methods on the Webviewcontroller (except static methods) can only be called
 * after the web component is bound to the WebviewController.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Web.Webview.Core"
]
public class WebviewController <: RemoteDataLite {
    static var webTagId: Int32 = 0
    static let WEB_TAG_SET: HashSet<String> = HashSet<String>()

    static func generateWebTag(): String {
        var webTag = "arkweb:${webTagId}"
        while (WEB_TAG_SET.contains(webTag)) {
            webTagId++
            webTag = "arkweb:${webTagId}"
        }
        WEB_TAG_SET.add(webTag)
        webTag
    }

    /**
     * A constructor used to create a WebviewController object.
     *
     * @param { ?String } [webTag] - specified the name of the web component, None by default.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public init(webTag!: ?String = None) {
        super(createWebviewControllerWithWebTag(webTag))
    }

    ~init() {
        releaseFFIData(myDataId)
    }

    /**
     * Sets whether to enable web debugging. By default, web debugging is disabled.
     * For details, see Debugging Frontend Pages by Using DevTools.
     * 
     * API Note:
     * Enabling web debugging allows users to check and modify the internal status of the web page,
     * which poses security risks. Therefore, you are advised not to enable this function
     * in the officially released version of the app.
     *
     * @param { Bool } webDebuggingAccess - Sets whether to enable web debugging. true enable web debugging;
     *                                     false disable web debugging. The default value is false.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setWebDebuggingAccess(webDebuggingAccess: Bool): Unit {
        WEBVIEW_LOG.info("WebviewController setWebDebuggingAccess start.")
        unsafe {
            FfiOHOSWebviewCtlSetWebDebuggingAccess(webDebuggingAccess)
        }
        WEBVIEW_LOG.info("WebviewController setWebDebuggingAccess success.")
    }

    /**
     * Loads the data or URL.
     *
     * @param { T } url - The URL to load. T should implement ResourceStr.
     * @param { Array<WebHeader> } [headers] - Additional HTTP request header for URL.
     * @throws { BusinessException } 17100001 - Init error.
     *                               The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100002 - URL error. The webpage corresponding to the URL is invalid, or the URL
     *                               length exceeds 2048.
     * @throws { BusinessException } 17100003 - Invalid resource path or file type.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func loadUrl<T>(url: T, headers!: Array<WebHeader> = Array<WebHeader>()): Unit where T <: ResourceStr {
        unsafe {
            try (cUrl = LibC.mallocCString(transResourceMediaToString(url)).asResource()) {
                var errCode: Int32 = 0
                if (headers.size == 0) {
                    errCode = FfiOHOSWebviewCtlLoadUrl(getID(), cUrl.value)
                } else {
                    let cHeaders = ArrWebHeader(headers)
                    errCode = FfiOHOSWebviewCtlLoadUrlWithHeaders(getID(), cUrl.value, cHeaders)
                    freeArrWebHeader(cHeaders.head, cHeaders.size)
                }
                throwIfNotSuccess(errCode, "WebviewController", "loadUrl")
            }
        }
    }

    /**
     * Refreshes the current URL.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func reload(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlRefresh(getID())
            throwIfNotSuccess(errCode, "WebviewController", "reload")
        }
    }

    /**
     * Gets the default user agent.
     *
     * @returns { String } Return user agent information.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getUserAgent(): String {
        unsafe {
            var code: Int32 = 0
            let userAgent = FfiOHOSWebviewCtlGetUserAgent(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "getUserAgent")
            return getStringAndFree(userAgent)
        }
    }

    /**
     * Checks whether the web page can go back.
     *
     * @returns { Bool } True if the web page can go back else false.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func canGoBack(): Bool {
        unsafe {
            var code: Int32 = 0
            let result = FfiOHOSWebviewCtlAccessBackward(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "canGoBack")
            return result
        }
    }

    /**
     * Set custom user agent.
     *
     * @param { String } userAgent - User custom agent information.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func setCustomUserAgent(userAgent: String): Unit {
        unsafe {
            let cUserAgent = LibC.mallocCString(userAgent)
            let errCode = FfiOHOSWebviewCtlSetCustomUserAgent(getID(), cUserAgent)
            LibC.free(cUserAgent)
            throwIfNotSuccess(errCode, "WebviewController", "setCustomUserAgent")
        }
    }

    /**
     * Get custom user agent.
     *
     * @returns { String } Get custom User agent information.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getCustomUserAgent(): String {
        unsafe {
            let ret = FfiOHOSWebviewCtlGetCustomUserAgent(getID())
            throwIfNotSuccess(ret.code, "WebviewController", "getCustomUserAgent")
            return getStringAndFree(ret.data)
        }
    }

    /**
     * Asynchronously execute JavaScript in the context of the currently displayed page.
     * The result of the script execution will be returned through an asynchronous callback.
     * This method must be used on the UI thread, and the callback will also be invoked on the UI thread.
     * API Note:
     * The state of JavaScript is no longer persisted across navigations like loadUrl.
     * For example, global variables and functions defined before calling loadUrl will not exist in the loaded page.
     * It is recommended that applications use registerJavaScriptProxy to ensure that the JavaScript state can be persisted across page navigations.
     *
     * @param { String } script - JavaScript Script.
     * @param { AsyncCallback<String> } callback - Callbacks execute JavaScript script results.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func runJavaScript(script: String, callback: AsyncCallback<String>): Unit {
        unsafe {
            let cScript = LibC.mallocCString(script)
            let wrapper = {
                value: RetDataCString => if (value.code == 0) {
                    let data = value.data.toString()
                    LibC.free(value.data)
                    callback(None, data)
                } else {
                    callback(BusinessException(value.code, getErrorMsg(value.code)), None)
                }
            }
            let lambdaData = Callback1Param<RetDataCString, Unit>(wrapper)
            let errCode = FfiOHOSWebviewCtlRunJavaScript(getID(), cScript, lambdaData.getID())
            LibC.free(cScript)
            throwIfNotSuccess(errCode, "WebviewController", "runJavaScript")
        }
    }

    /**
     * Registers the supplied Cangjie functions into this Web component.
     * The functions are registered into all frames of the web page, including all iframes, using the specified name.
     * This allows the methods of the Cangjie functions to be accessed from JavaScript.
     *
     * Registed functions will not appear in JavaScript until the page is next (re)load.
     * To avoid memory leaks, registerJavaScriptProxy must be used together with deleteJavaScriptProxy.
     * To avoid security risks, it is recommended that registerJavaScriptProxy be used with trusted web components.
     *
     * @param { Array<(String) -> String> } funcs - Application side Cangjie functions participating in registration.
     * @param { String } name - The name of the registered Cangjie functions, which is consistent with the
     *                          object name called in the window.
     * @param { Array<String> } methodList - The method of the application side Cangjie functions participating
     *                                       in the registration.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100015 - New failed, out of memeory.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func registerJavaScriptProxy(funcs: Array<(String) -> String>, name: String, methodList: Array<String>): Unit {
        if (funcs.size != methodList.size) {
            WEBVIEW_LOG.error(
                "WebviewController registerJavaScriptProxy failed: the funcs and methodList must have the same size.")
            throw BusinessException(INIT_ERROR, getErrorMsg(INIT_ERROR))
        }
        if (funcs.size == 0) {
            throw BusinessException(INIT_ERROR, getErrorMsg(INIT_ERROR))
        }
        unsafe {
            let cName = LibC.mallocCString(name)
            let cMethodList: CArrString
            try {
                cMethodList = toArrayCString(methodList)
            } catch (e: IllegalMemoryException) {
                LibC.free(cName)
                throw BusinessException(OUT_MEMEORY, getErrorMsg(OUT_MEMEORY))
            }
            let cFuncIdsPtr = LibC.malloc<Int64>(count: funcs.size)
            if (cFuncIdsPtr.isNull()) {
                LibC.free(cName)
                freeArrCString(cMethodList)
                throw BusinessException(OUT_MEMEORY, getErrorMsg(OUT_MEMEORY))
            }
            for (i in 0..funcs.size) {
                let wrapper = {
                    value: CString =>
                    let data = value.toString()
                    LibC.free(value)
                    let result = funcs[i](data)
                    let resultCString = LibC.mallocCString(result)
                    return resultCString
                }
                let lambdaData = Callback1Param<CString, CString>(wrapper)
                cFuncIdsPtr.write(i, lambdaData.getID())
            }
            let cFuncIds = CArrI64(cFuncIdsPtr, funcs.size)
            let errCode = FfiOHOSWebviewCtlRegisterJavaScriptProxy(getID(), cFuncIds, cName, cMethodList)
            LibC.free(cName)
            freeArrCString(cMethodList)
            LibC.free(cFuncIdsPtr)

            throwIfNotSuccess(errCode, "WebviewController", "registerJavaScriptProxy")
        }
    }

    /**
     * Gets the url of current Web page.
     *
     * @returns { String } Return the url of the current page.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getUrl(): String {
        unsafe {
            let ret = FfiOHOSWebviewCtlGetUrl(getID())
            throwIfNotSuccess(ret.code, "WebviewController", "getUrl")
            return getStringAndFree(ret.data)
        }
    }

    /**
     * Gets the original url of current Web page.
     *
     * @returns { String } Return the original url of the current page.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getOriginalUrl(): String {
        unsafe {
            let ret = FfiOHOSWebviewCtlGetOriginalUrl(getID())
            throwIfNotSuccess(ret.code, "WebviewController", "getOriginalUrl")
            return getStringAndFree(ret.data)
        }
    }

    /**
     * Scroll the contents of this Webview up by half the view size.
     *
     * @param { Bool } top - Whether to jump to the top of the page, if set to false,
     *                          the page content will scroll up half the size of the viewframe,
     *                          and when set to true, it will jump to the top of the page.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func pageUp(top: Bool): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlPageUp(getID(), top)
            throwIfNotSuccess(errCode, "WebviewController", "pageUp")
        }
    }

    /**
     * Scroll the contents of this Webview down by half the view size.
     *
     * @param { Bool } bottom - Whether to jump to the top of the page, if set to false,
     *                             the page content will scroll up half the size of the viewframe,
     *                             and when set to true, it will jump to the top of the page.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func pageDown(bottom: Bool): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlPageDown(getID(), bottom)
            throwIfNotSuccess(errCode, "WebviewController", "pageDown")
        }
    }

    /**
     * Scroll to the position within specified time.
     *
     * @param { Float32 } x - the x of the position.Unit: vp.
     * @param { Float32 } y - the y of the position.Unit: vp.
     * @param { ?Int32 } [duration] - the scroll animation duration. Unit: millisecond.
     *                              If the value is not passed, or is negative or 0, there is no animation.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func scrollTo(x: Float32, y: Float32, duration!: ?Int32 = None): Unit {
        unsafe {
            let errCode = if (let Some(v) <- duration) {
                FfiOHOSWebviewCtlScrollToWithAnime(getID(), x, y, v)
            } else {
                FfiOHOSWebviewCtlScrollTo(getID(), x, y)
            }
            throwIfNotSuccess(errCode, "WebviewController", "scrollTo")
        }
    }

    /**
     * Scroll by the delta position.
     *
     * API Note:
     * In nested scroll scenarios, calling scrollBy does not trigger nested scrolling in the parent component.
     *
     * @param { Float32 } deltaX - the delta x of the position.Unit: vp.
     * @param { Float32 } deltaY - the delta y of the position.Unit: vp.
     * @param { ?Int32 } [duration] - the scroll animation duration. Unit: millisecond.
     *                              If the value is not passed, or is negative or 0, there is no animation.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func scrollBy(deltaX: Float32, deltaY: Float32, duration!: ?Int32 = None): Unit {
        unsafe {
            let errCode = if (let Some(v) <- duration) {
                FfiOHOSWebviewCtlScrollByWithAnime(getID(), deltaX, deltaY, v)
            } else {
                FfiOHOSWebviewCtlScrollBy(getID(), deltaX, deltaY)
            }
            throwIfNotSuccess(errCode, "WebviewController", "scrollBy")
        }
    }

    /**
     * Goes forward in the history of the web page.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func goForward(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlForward(getID())
            throwIfNotSuccess(errCode, "WebviewController", "goForward")
        }
    }

    /**
     * Goes back in the history of the web page.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func goBack(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlBackward(getID())
            throwIfNotSuccess(errCode, "WebviewController", "goBack")
        }
    }

    /**
     * Goes forward or back backOrForward in the history of the web page.
     *
     * @param { Int32 } step - Steps to go forward or backward.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func goBackOrForward(step: Int32): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlBackOrForward(getID(), step)
            throwIfNotSuccess(errCode, "WebviewController", "goBackOrForward")
        }
    }

    /**
     * Obtains the height of this web page.
     *
     * @returns { Int32 } Height of the current web page. Unit: vp.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getPageHeight(): Int32 {
        unsafe {
            var code: Int32 = 0
            let pageHeight = FfiOHOSWebviewCtlGetPageHeight(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "getPageHeight")
            return pageHeight
        }
    }

    /**
     * Gets the title of current Web page.
     *
     * @returns { String } Return to File Selector Title.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getTitle(): String {
        unsafe {
            let ret = FfiOHOSWebviewCtlGetTitle(getID())
            throwIfNotSuccess(ret.code, "WebviewController", "getTitle")
            return getStringAndFree(ret.data)
        }
    }

    /**
     * Let the Web zoom by.
     *
     * API Note:
     * zoomAccess must be true.
     *
     * @param { Float32 } factor - The zoom factor.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100004 - Function not enable.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func zoom(factor: Float32): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlZoom(getID(), factor)
            throwIfNotSuccess(errCode, "WebviewController", "zoom")
        }
    }

    /**
     * Zooms in on this web page by 25%.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100004 - Function not enable.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func zoomIn(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlZoomIn(getID())
            throwIfNotSuccess(errCode, "WebviewController", "zoomIn")
        }
    }

    /**
     * Zooms out of this web page by 20%.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100004 - Function not enable.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func zoomOut(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlZoomOut(getID())
            throwIfNotSuccess(errCode, "WebviewController", "zoomOut")
        }
    }

    /**
     * Clears the history in the Web.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func clearHistory(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlClearHistory(getID())
            throwIfNotSuccess(errCode, "WebviewController", "clearHistory")
        }
    }

    /**
     * Checks whether the web page can go back or forward the given number of steps.
     *
     * @param { Int32 } step - The number of steps.
     * @returns { Bool } True if the web page can go back else false.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func accessStep(step: Int32): Bool {
        
        var code: Int32 = 0
        let result = unsafe { FfiOHOSWebviewCtlAccessStep(getID(), inout code, step) }
        throwIfNotSuccess(code, "WebviewController", "accessStep")
        return result
    }

    /**
     * Stores the current page as a web archive.
     *
     * @param { String } baseName - Where the generated offline webpage is stored, This value cannot be null.
     * @param { Bool } autoName - Decide whether to automatically generate the file name. If false, it is
     *                               stored by the file name of baseName. If true, the file name is
     *                               automatically generated based on the current URL and stored in the file
     *                               directory of baseName.
     * @param { AsyncCallback<String> } callback - called after the web archive has been stored. The parameter
     *                                             will either be the filename under which the file was stored,
     *                                             or empty if storing the file failed.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100003 - Invalid resource path or file type.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func storeWebArchive(baseName: String, autoName: Bool, callback: AsyncCallback<String>): Unit {
        unsafe {
            let cBaseName = LibC.mallocCString(baseName)
            let wrapper = {
                value: RetDataCString => if (value.code == 0) {
                    let data = value.data.toString()
                    LibC.free(value.data)
                    callback(None, data)
                } else {
                    callback(BusinessException(value.code, getErrorMsg(value.code)), None)
                }
            }
            let lambdaData = Callback1Param<RetDataCString, Unit>(wrapper)
            let errCode = FfiOHOSWebviewCtlStoreWebArchive(getID(), cBaseName, autoName, lambdaData.getID())
            LibC.free(cBaseName)
            throwIfNotSuccess(errCode, "WebviewController", "storeWebArchive")
        }
    }

    /**
     * Enable the ability to check website security risks.
     * Illegal and fraudulent websites are mandatory enabled and can't be disabled by this function.
     *
     * @param { Bool } enable - true enable check the website security risks; false otherwise.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func enableSafeBrowsing(enable: Bool): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlEnableSafeBrowsing(getID(), enable)
            throwIfNotSuccess(errCode, "WebviewController", "enableSafeBrowsing")
        }
    }

    /**
     * Get whether checking website security risks is enabled.
     *
     * @returns { Bool } True if enable the ability to check website security risks else false.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func isSafeBrowsingEnabled(): Bool {
        unsafe {
            var code: Int32 = 0
            let result = FfiOHOSWebviewCtlIsSafeBrowsingEnabled(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "isSafeBrowsingEnabled")
            return result
        }
    }

    /**
     * Get the security level of the current page.
     *
     * @returns { SecurityLevel } the security level of current page.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getSecurityLevel(): SecurityLevel {
        unsafe {
            var code: Int32 = 0
            let result = FfiOHOSWebviewCtlGetSecurityLevel(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "getSecurityLevel")
            return SecurityLevel.fromInt32(result)
        }
    }

    /**
     * Whether the incognito mode is set.
     *
     * @returns { Bool } true has been set the incognito mode; false otherwise.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func isIncognitoMode(): Bool {
        unsafe {
            var code: Int32 = 0
            let result = FfiOHOSWebviewCtlIsIncognitoMode(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "isIncognitoMode")
            return result
        }
    }

    /**
     * Clears the cache in the application. This API will clear the cache for all webviews in the same application.
     *
     * @param { Bool } clearRom - Whether to clear the cache in the ROM and RAM at the same time.
     *                            true means to clear the cache in the ROM and RAM at the same time;
     *                            false means to only clear the cache in the RAM.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func removeCache(clearRom: Bool): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlRemoveCache(getID(), clearRom)
            throwIfNotSuccess(errCode, "WebviewController", "removeCache")
        }
    }

    /**
     * Get back forward stack list from current webview.
     *
     * @returns { BackForwardList } Back forward list for current webview.
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getBackForwardEntries(): BackForwardList {
        unsafe {
            var code: Int32 = 0
            let backForwardListId = FfiOHOSWebviewCtlGetBackForwardEntries(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "getBackForwardEntries")
            return BackForwardList(backForwardListId)
        }
    }

    /**
     * Stops the current load.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *                           The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true,
        workerthread: true
    ]
    public func stop(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlStop(getID())
            throwIfNotSuccess(errCode, "WebviewController", "stop")
        }
    }

    /**
     * Loads the dynamic library file of the web engine through this API before the **Web** component is initialized,
     * so as to improve startup performance. It also automatically preconnects to frequently visited websites in
     * history.
     *
     * **NOTE**
     * - **initializeWebEngine** cannot be called in an asynchronous thread. Otherwise, the system breaks down.
     * - **initializeWebEngine** takes effect globally and needs to be called only once in an application lifecycle.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func initializeWebEngine(): Unit {
        WEBVIEW_LOG.info("WebviewController initializeWebEngine start.")
        unsafe {
            FfiOHOSWebviewCtlInitializeWebEngine()
        }
        WEBVIEW_LOG.info("WebviewController initializeWebEngine success.")
    }

    /**
     * Checks whether going to the next page can be performed on the current page.
     *
     * You can use **getBackForwardEntries** to obtain the historical information list of the current WebView and use
     * **accessStep** to determine whether to move forward or backward based on the specified number of steps.
     *
     * @returns { Bool } **true** is returned if going to the next page can be performed on the current page; otherwise,
     *     **false** is returned.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func accessForward(): Bool {
        unsafe {
            var code: Int32 = 0
            let result = FfiOHOSWebviewCtlAccessForward(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "accessForward")
            return result
        }
    }

    /**
     * Checks whether going to the previous page can be performed on the current page.
     *
     * You can use **getBackForwardEntries** to obtain the historical information list of the current WebView and use
     * **accessStep** to determine whether to move forward or backward based on the specified number of steps.
     *
     * **NOTE**
     * - If **setCustomUserAgent** is called when the **Web** component is loaded for the first time, the value of
     * **accessBackward** may be **false** when there are multiple historical entries. That is, there is no backward
     * entry. You are advised to call the **setCustomUserAgent** method to set a user agent before using **loadUrl** to
     * load a specific page.
     * - Causes: When the **Web** component is loaded for the first time, calling **setCustomUserAgent** causes the
     * component to reload and retain the initial history entry. Then the new entry replaces the initial history entry
     * and no new history entry is generated. As a result, the value of **accessBackward** is false.
     *
     * @returns { Bool } **true** is returned if going to the previous page can be performed on the current page.
     *     Otherwise, **false** is returned.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func accessBackward(): Bool {
        unsafe {
            var code: Int32 = 0
            let result = FfiOHOSWebviewCtlAccessBackward(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "accessBackward")
            return result
        }
    }

    /**
     * Called when the **Web** component enters the active state.
     *
     * The application can interact with the user while in the active foreground state, and it remains in this state
     * until the focus is moved away from it due to some event (for example, an incoming call is received or the device
     * screen is turned off).
     *
     * If the page was previously in the inactive state, the event listener registered through document.addEventListener
     * ('visibilitychange',...) in the H5 page will be triggered, and document.visibilityState changes from "hidden" to
     * "visible".
     *
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func onActive(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlOnActive(getID())
            throwIfNotSuccess(errCode, "WebviewController", "onActive")
        }
    }

    /**
     * Called when the **Web** component enters the inactive state. You can implement the behavior to perform after the
     * application loses focus.
     *
     * When this API is called, any content that can be safely paused, such as animations and geographical locations, is
     * paused as much as possible. However, the JavaScript is not paused. To pause the JavaScript globally, use
     * **pauseAllTimers**. To reactivate the **Web** component, use **onActive**.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func onInactive(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlOnInactive(getID())
            throwIfNotSuccess(errCode, "WebviewController", "onInactive")
        }
    }

    /**
     * Loads specified data.
     *
     * When both **baseUrl** and **historyUrl** are empty:
     *
     * If **encoding** is not base64 (including null values), ASCII encoding is used for octets within the secure URL
     * character range, and the standard %xx hexadecimal encoding of the URL is used for octets outside the secure URL
     * character range.
     *
     * **data** must be encoded using Base64 or any hash (#) in the content must be encoded as %23. Otherwise, hash (#)
     * is considered as the end of the content, and the remaining text is used as the document fragment identifier.
     *
     * **NOTE**
     * - To load a local image, you can assign a space to either **baseUrl** or **historyUrl**.
     * - In the scenario of loading a local image, **baseUrl** and **historyUrl** cannot be both empty. Otherwise, the
     * image cannot be loaded.
     * - If the rich text in HTML contains special characters such as hash (#), you are advised to set the values of
     * **baseUrl** and **historyUrl** to spaces.
     * - To load texts, you need to set
     * `<meta name="viewport" content="width=device-width, initial-scale=1.0" charset="utf-8">` to avoid inconsistent
     * font sizes.
     *
     * @param { String } data - String obtained after being base64 or URL encoded.
     * @param { String } mimeType - Media type (MIME).
     * @param { String } encoding - Encoding type, which can be base64 or URL.
     * @param { ?String } [baseUrl] - URL (HTTP/HTTPS/data compliant), which is assigned by the **Web** component to
     *     **window.origin**. If a large number of HTML files need to be loaded, set this parameter to **data**.
     * @param { ?String } [historyUrl] - URL used for historical records. If this parameter is not empty, historical
     *     records are managed based on this URL. This parameter is invalid when **baseUrl** is left empty.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100002 - URL error. The webpage corresponding to the URL is invalid, or the URL
     *     length exceeds 2048.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func loadData(data: String, mimeType: String, encoding: String, baseUrl!: ?String = None,
        historyUrl!: ?String = None): Unit {
        unsafe {
            try (
                cData = LibC.mallocCString(data).asResource(),
                cMimeType = LibC.mallocCString(mimeType).asResource(),
                cEncoding = LibC.mallocCString(encoding).asResource(),
                cBaseUrl = LibC.mallocCString(baseUrl ?? "").asResource(),
                cHistoryUrl = LibC.mallocCString(historyUrl ?? "").asResource()
            ) {
                let loadDatas = LoadDatas(cData.value, cMimeType.value, cEncoding.value, cBaseUrl.value,
                    cHistoryUrl.value)
                let errCode = FfiOHOSWebviewCtlLoadData(getID(), loadDatas)
                throwIfNotSuccess(errCode, "WebviewController", "loadData")
            }
        }
    }

    /**
     * Obtains the index value of the **Web** component, which can be used for managing multiple **Web** components.
     *
     * @returns { Int32 } Index of the Web component.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func getWebId(): Int32 {
        unsafe {
            var code: Int32 = 0
            let webId = FfiOHOSWebviewCtlGetWebId(getID(), inout code)
            throwIfNotSuccess(code, "WebviewController", "getWebId")
            return webId
        }
    }

    /**
     * Requests focus for the specified component.
     *
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func requestFocus(): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlRequestFocus(getID())
            throwIfNotSuccess(errCode, "WebviewController", "requestFocus")
        }
    }

    /**
     * Deletes a specific JavaScript object registered through **registerJavaScriptProxy** or **javaScriptProxy**. The
     * deletion takes effect after the page is reloaded.
     *
     * @param { String } name - Name of the registered JavaScript object, which can be used to invoke the corresponding
     *     object on the application side from the web side.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     * @throws { BusinessException } 17100008 - Failed to delete JavaScriptProxy because it does not exist.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func deleteJavaScriptRegister(name: String): Unit {
        unsafe {
            let cName = LibC.mallocCString(name)
            let errCode = FfiOHOSWebviewCtlDeleteJavaScriptRegister(getID(), cName)
            LibC.free(cName)
            throwIfNotSuccess(errCode, "WebviewController", "deleteJavaScriptRegister")
        }
    }

    /**
     * Grants the cross-domain request and fetch request permissions for custom protocol URLs to the web kernel. When
     * the Web performs a cross-domain fetch of a custom protocol URL, the fetch request can be intercepted by the
     * **onInterceptRequest** event API, so that developers can further process the request. It is recommended to call
     * this API before any **Web** component is initialized.
     *
     * @param { Array<WebCustomScheme> } schemes - Array of up to 10 custom schemes.
     * @throws { BusinessException } 17100020 - Failed to register custom schemes.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public static func customizeSchemes(schemes: Array<WebCustomScheme>): Unit {
        unsafe {
            let cSchemes = ArrScheme(schemes)
            let errCode = FfiWebviewCtlCustomizeSchemes(cSchemes)
            freeArrScheme(cSchemes.head, cSchemes.size)
            throwIfNotSuccess(errCode, "WebviewController", "customizeSchemes")
        }
    }

    /**
     * Mutes the web page. Typical use cases include: the app needs to control the web page volume (such as providing a
     * mute switch), or needs to mute during background playback.
     *
     * @param { Bool } mute - Whether to mute the web page.
     *     The value **true** means to mute the web page, and **false** means the opposite.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func setAudioMuted(mute: Bool): Unit {
        unsafe {
            let errCode = FfiOHOSWebviewCtlSetAudioMuted(getID(), mute)
            throwIfNotSuccess(errCode, "WebviewController", "setAudioMuted")
        }
    }

    /**
     * Sets whether this web page is scrollable, with the scrolling type specified.
     *
     * @param { Bool } enable - Whether this web page is scrollable.
     *     The value **true** indicates that this web page is scrollable, and **false** indicates the opposite.
     *     Default value: **true**.
     * @param { ?ScrollType } [scrollType] - Scrolling type supported by the web page. The default value is supported.
     *     - If the value of **enable** is set to **false**, the specified **ScrollType** is disabled. If **ScrollType**
     *     is set to the default value, all scrolling types are disabled.
     *     - If the value of **enable** is set to **true**, all scrolling types are enabled regardless of the value of
     *     **ScrollType**.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func setScrollable(enable: Bool, scrollType!: ?ScrollType = None): Unit {
        unsafe {
            // The value -1 indicates that scrollType is not specified, which is the same as the ArkTS API.
            let scrollTypeValue: Int32 = if (let Some(v) <- scrollType) {
                v.getValue()
            } else {
                -1
            }
            let errCode = FfiOHOSWebviewCtlSetScrollableEx(getID(), enable, scrollTypeValue)
            throwIfNotSuccess(errCode, "WebviewController", "setScrollable")
        }
    }

    /**
     * Sets the ArkWeb rendering subprocess mode. You can select the appropriate mode based on the app's requirements
     * for memory usage and rendering process isolation.
     *
     * @param { RenderProcessMode } mode - Render subprocess mode.
     *     You can call **getRenderProcessMode()** to view the ArkWeb rendering subprocess mode of the current device.
     *     The enumerated value **0** indicates the single render subprocess mode, and **1** indicates the multi-render
     *     subprocess mode.
     *     By default, mobile phones use the single render subprocess mode, and tablets and PCs/2in1 devices use the
     *     multi-render subprocess mode.
     *     If an invalid number other than the enumerated value of **RenderProcessMode** is passed, the multi-render
     *     subprocess mode is used by default.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core"
    ]
    public static func setRenderProcessMode(mode: RenderProcessMode): Unit {
        unsafe {
            FfiOHOSWebviewCtlSetRenderProcessMode(mode.getValue())
        }
    }

    /**
     * Scrolls the page by the specified amount and returns value to indicate whether the scrolling is successful.
     *
     * @param { Float32 } deltaX - Amount to scroll by along the x-axis. The positive direction is rightward.
     *     Unit: vp
     * @param { Float32 } deltaY - Amount to scroll by along the y-axis. The positive direction is downward.
     *     Unit: vp
     * @returns { Bool } The value **true** indicates that the current web page can be scrolled, and **false**
     *     indicates that the current web page cannot be scrolled.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func scrollByWithResult(deltaX: Float32, deltaY: Float32): Bool {
        unsafe {
            var code: Int32 = 0
            let result = FfiOHOSWebviewCtlScrollByWithResult(getID(), deltaX, deltaY, inout code)
            throwIfNotSuccess(code, "WebviewController", "scrollByWithResult")
            return result
        }
    }

    /**
     * Executes a JavaScript script. This API uses an asynchronous callback to return the script execution result.
     * **runJavaScriptExt** can be invoked only after **loadUrl** is executed. For example, it can be invoked in
     * **onPageEnd**.
     *
     * **NOTE**
     * - The string data type passed from the frontend page to the app side is treated as JSON-formatted data and
     * needs to be deserialized with JSON.parse.
     *
     * @param { ScriptValueType } script - JavaScript script.
     * @param { AsyncCallback<JsMessageExt> } callback - Callback used to return the result.
     * @throws { BusinessException } 17100001 - Init error.
     *     The WebviewController must be associated with a Web component.
     */
    @!APILevel[
        since: "26.1.0",
        syscap: "SystemCapability.Web.Webview.Core",
        throwexception: true
    ]
    public func runJavaScriptExt(script: ScriptValueType, callback: AsyncCallback<JsMessageExt>): Unit {
        unsafe {
            match (script) {
                case StringValue(s) =>
                    let cScript = LibC.mallocCString(s)
                    let wrapper = {
                        value: RetDataI64 => if (value.code == 0) {
                            callback(None, JsMessageExt(value.data))
                        } else {
                            callback(BusinessException(value.code, getErrorMsg(value.code)), None)
                        }
                    }
                    let lambdaData = Callback1Param<RetDataI64, Unit>(wrapper)
                    let errCode = FfiOHOSWebviewCtlRunJavaScriptExt(getID(), cScript, lambdaData.getID())
                    LibC.free(cScript)
                    throwIfNotSuccess(errCode, "WebviewController", "runJavaScriptExt")
                case ArrayBufferValue(_) =>
                    WEBVIEW_LOG.error(
                        "WebviewController runJavaScriptExt failed: the ArrayBuffer script is not supported yet.")
                case _ =>
                    WEBVIEW_LOG.error(
                        "WebviewController runJavaScriptExt failed: unsupported type.")
            }
        }
    }
}
