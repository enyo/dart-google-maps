// Copyright (c) 2012, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of google_maps;

class MVCObject extends jsw.TypedJsObject {
  static MVCObject cast(js.JsObject jsObject) => jsObject == null ? null : new MVCObject.fromJsObject(jsObject);
  MVCObject([js.Serializable<js.JsFunction> constructor, List args]) : super(constructor != null ? constructor : maps['MVCObject'], args);
  MVCObject.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);

  MapsEventListener addListener(String eventName, Function handler) => MapsEventListener.cast($unsafe.callMethod('addListener', [eventName, handler]));
  void bindTo(String key, MVCObject target, [String targetKey, bool noNotify]) {
    $unsafe.callMethod('bindTo', [key, target, targetKey, noNotify]);
  }
  void changed(String key) {
    $unsafe.callMethod('changed', [key]);
  }
  Object get(String key) => $unsafe.callMethod('get', [key]);
  void notify(String key) {
    $unsafe.callMethod('notify', [key]);
  }
  void set(String key, Object value) {
    $unsafe.callMethod('set', [key, value]);
  }
  set values(Map<String, Object> values) => $unsafe.callMethod('setValues', [values == null ? null : values is js.Serializable ? values : js.jsify(values)]);
  void unbind(String key) {
    $unsafe.callMethod('unbind', [key]);
  }
  void unbindAll() {
    $unsafe.callMethod('unbindAll');
  }
}
