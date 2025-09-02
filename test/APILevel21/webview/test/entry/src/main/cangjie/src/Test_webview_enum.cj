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

import std.unittest.*
import std.unittest.testmacro.*
import ohos.base.*
import ohos.web.webview.*
import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.base.*

@Test
class Test_webview_enum {
    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testSecurityLevel(): Unit {
        let enumArr: Array<SecurityLevel> = [NoneLevel, Secure, Warning, Dangerous]
        let strArr: Array<String> = ["SecurityLevel.NoneLevel", "SecurityLevel.Secure", "SecurityLevel.Warning",
            "SecurityLevel.Dangerous"]
        for (i in 0..enumArr.size) {
            @Expect(enumArr[i].toString(), strArr[i])
            @Expect(enumArr[i] == enumArr[i])
            @Expect(enumArr[i] != enumArr[(i + 1) % enumArr.size])
        }
    }
 
    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testWebHitTestType(): Unit {
        let enumArr: Array<WebHitTestType> = [EditText, Email, Unknown]
        let strArr: Array<String> = ["WebHitTestType.EditText", "WebHitTestType.Email", "WebHitTestType.Unknown"]
        for (i in 0..enumArr.size) {
            @Expect(enumArr[i].toString(), strArr[i])
            @Expect(enumArr[i] == enumArr[i])
            @Expect(enumArr[i] != enumArr[(i + 1) % enumArr.size])
        }
    }
}