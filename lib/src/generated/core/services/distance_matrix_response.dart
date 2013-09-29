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

class DistanceMatrixResponse extends jsw.TypedJsObject {
  static DistanceMatrixResponse cast(js.JsObject jsObject) => jsObject == null ? null : new DistanceMatrixResponse.fromJsObject(jsObject);
  DistanceMatrixResponse.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  DistanceMatrixResponse() : super();

  set destinationAddresses(List<String> destinationAddresses) => $unsafe['destinationAddresses'] = destinationAddresses == null ? null : destinationAddresses is js.Serializable ? destinationAddresses : js.jsify(destinationAddresses);
  List<String> get destinationAddresses => jsw.TypedJsArray.cast($unsafe['destinationAddresses']);
  set originAddresses(List<String> originAddresses) => $unsafe['originAddresses'] = originAddresses == null ? null : originAddresses is js.Serializable ? originAddresses : js.jsify(originAddresses);
  List<String> get originAddresses => jsw.TypedJsArray.cast($unsafe['originAddresses']);
  set rows(List<DistanceMatrixResponseRow> rows) => $unsafe['rows'] = rows == null ? null : rows is js.Serializable ? rows : js.jsify(rows);
  List<DistanceMatrixResponseRow> get rows => jsw.TypedJsArray.castListOfSerializables($unsafe['rows'], DistanceMatrixResponseRow.cast);
}
