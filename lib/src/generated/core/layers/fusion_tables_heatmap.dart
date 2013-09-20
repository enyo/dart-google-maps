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

class FusionTablesHeatmap extends jsw.TypedJsObject {
  static FusionTablesHeatmap cast(js.JsObject jsObject) => jsObject == null ? null : new FusionTablesHeatmap.fromJsObject(jsObject);
  FusionTablesHeatmap.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  FusionTablesHeatmap() : super();

  set enabled(bool enabled) => $unsafe['enabled'] = enabled;
bool get enabled => $unsafe['enabled'];
}