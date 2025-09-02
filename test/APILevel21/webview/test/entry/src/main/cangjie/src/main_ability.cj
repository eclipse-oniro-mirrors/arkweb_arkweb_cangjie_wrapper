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

import kit.AbilityKit.{Ability, Want, LaunchParam, LaunchReason}
import ohos.window.WindowStage
import ohos.web.webview.{WebviewController, WebCookieManager}
import ohos.arkui.state_management.AppStorage
import kit.AbilityKit.UIAbilityContext
import kit.AbilityKit.UIAbility

class MainAbility <: UIAbility {
    public func onCreate(want: Want, launchParam: LaunchParam): Unit {
        loggerInfo("MainAbility OnCreated.${want.abilityName}")
        try {
            AppStorage.setOrCreate<WebviewController>("controller", WebviewController())
            AppStorage.setOrCreate<WebviewController>("controller2", WebviewController())
            AppStorage.setOrCreate<WebviewController>("controller3", WebviewController())
            AppStorage.setOrCreate<WebviewController>("controller4", WebviewController())
            AppStorage.setOrCreate<WebviewController>("controller5", WebviewController())
            WebCookieManager.configCookie("https://www.example.com", "a=b,c=d,e=f")
            AppStorage.setOrCreate("abilityWant", want)
        } catch (e: Exception) {
            loggerError("e = ${e.stackTrace}")
        }
        match (launchParam.launchReason) {
            case LaunchReason.StartAbility => loggerInfo("START_ABILITY")
            case _ => ()
        }
    }

    public func onWindowStageCreate(windowStage: WindowStage): Unit {
        loggerInfo("MainAbility onWindowStageCreate.")
        AppStorage.setOrCreate<UIAbilityContext>("abilityContext", this.context)
        AppStorage.setOrCreate<WindowStage>("windowStage", windowStage)
        windowStage.loadContent("EntryView")
    }
}
