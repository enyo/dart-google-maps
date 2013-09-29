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

class LocationElevationRequest extends jsw.TypedJsObject {
  static LocationElevationRequest cast(js.JsObject jsObject) => jsObject == null ? null : new LocationElevationRequest.fromJsObject(jsObject);
  LocationElevationRequest.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  LocationElevationRequest() : super();

  set locations(List<LatLng> locations) => $unsafe['locations'] = locations == null ? null : locations is js.Serializable ? locations : js.jsify(locations);
  List<LatLng> get locations => jsw.TypedJsArray.castListOfSerializables($unsafe['locations'], LatLng.cast);
}
