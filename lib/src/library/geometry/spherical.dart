// Copyright (c) 2015, Alexandre Ardhuin
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

part of google_maps.src.geometry;

final spherical =
    new Spherical.created(context['google']['maps']['geometry']['spherical']);
abstract class _Spherical implements JsInterface {
  num computeArea(dynamic /*List<LatLng>|MVCArray<LatLng>*/ path,
          [num radius]) =>
      _computeArea((new ChainedCodec()
    ..add(new JsListCodec<LatLng>(new JsInterfaceCodec<LatLng>(
        (o) => new LatLng.created(o),
        (o) => o != null && o.instanceof(context['google']['maps']['LatLng']))))
    ..add(new JsInterfaceCodec<MVCArray<LatLng>>(
        (o) => new MVCArray<LatLng>.created(o, new JsInterfaceCodec<LatLng>(
                (o) => new LatLng.created(o), (o) => o != null &&
                    o.instanceof(context['google']['maps']['LatLng']))))))
          .encode(path), radius);
  _computeArea(dynamic /*List<LatLng>|MVCArray<LatLng>*/ path, [num radius]);
  num computeDistanceBetween(LatLng from, LatLng to, [num radius]);
  num computeHeading(LatLng from, LatLng to);
  num computeLength(dynamic /*List<LatLng>|MVCArray<LatLng>*/ path,
          [num radius]) =>
      _computeLength((new ChainedCodec()
    ..add(new JsListCodec<LatLng>(new JsInterfaceCodec<LatLng>(
        (o) => new LatLng.created(o),
        (o) => o != null && o.instanceof(context['google']['maps']['LatLng']))))
    ..add(new JsInterfaceCodec<MVCArray<LatLng>>(
        (o) => new MVCArray<LatLng>.created(o, new JsInterfaceCodec<LatLng>(
                (o) => new LatLng.created(o), (o) => o != null &&
                    o.instanceof(context['google']['maps']['LatLng']))))))
          .encode(path), radius);
  _computeLength(dynamic /*List<LatLng>|MVCArray<LatLng>*/ path, [num radius]);
  LatLng computeOffset(LatLng from, num distance, num heading, [num radius]);
  LatLng computeOffsetOrigin(LatLng to, num distance, num heading,
      [num radius]);
  num computeSignedArea(dynamic /*List<LatLng>|MVCArray<LatLng>*/ loop,
          [num radius]) =>
      _computeSignedArea((new ChainedCodec()
    ..add(new JsListCodec<LatLng>(new JsInterfaceCodec<LatLng>(
        (o) => new LatLng.created(o),
        (o) => o != null && o.instanceof(context['google']['maps']['LatLng']))))
    ..add(new JsInterfaceCodec<MVCArray<LatLng>>(
        (o) => new MVCArray<LatLng>.created(o, new JsInterfaceCodec<LatLng>(
                (o) => new LatLng.created(o), (o) => o != null &&
                    o.instanceof(context['google']['maps']['LatLng']))))))
          .encode(loop), radius);
  _computeSignedArea(dynamic /*List<LatLng>|MVCArray<LatLng>*/ loop,
      [num radius]);
  LatLng interpolate(LatLng from, LatLng to, num fraction);
}
