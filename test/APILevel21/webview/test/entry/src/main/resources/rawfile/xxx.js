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

//xxx.js
var h5Port;
var output = document.querySelector('.output');
window.addEventListener('message', function (event) {
    if (event.data == '__init_port__') {
        if (event.ports[0] != null) {
            h5Port = event.ports[0]; // 1. 保存从ets侧发送过来的端口
            h5Port.onmessage = function (event) {
                // 2. 接收ets侧发送过来的消息.
                var msg = 'Got message from cangjie:';
                var result = event.data;
                if (typeof(result) == "string") {
                    console.log("received string message from html5, string is:" + result);
                    msg = msg + result;
                } else if (typeof(result) == "object") {
                    if (result instanceof ArrayBuffer) {
                        console.log("received arraybuffer from html5, length is:" + result.byteLength);
                        const decoder = new TextDecoder();
                        const str = decoder.decode(result);
                        msg = msg + str + " and byteLength is " + result.byteLength;
                    } else {
                        console.log("not support");
                    }
                } else {
                    console.log("not support");
                }
                output.innerHTML = msg;
            }
        }
    }
})

// 3. 使用h5Port往ets侧发送消息.
function PostMsgToCangjie(data) {
    // let a = new ArrayBuffer(12);
    if (h5Port) {
        h5Port.postMessage(data);
        // h5Port.postMessage(a);
    } else {
        console.error("h5Port is null, Please initialize first");
    }
}