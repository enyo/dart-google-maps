import 'dart:io';

import 'package:dart_style/src/dart_formatter.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

final LICENCE = '''
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
''';

final customClassName = <String, String>{
  'Map': 'GMap',
  'Symbol': 'GSymbol',
  'Duration': 'GDuration',
};

final customContent = <String, String>{
  'Data.StylingFunction':
      'typedef DataStyleOptions DataStylingFunction(DataFeature dataFeature);',
  'MVCArray': '''
@JsName('google.maps.MVCArray')
abstract class _MVCArray<E> extends MVCObject {
  Codec<E, dynamic> _codec = null;

  _MVCArray({List<E> elements, Codec<E, dynamic> codec}) : this.created(
          new JsObject(getPath('google.maps.MVCArray'), [
        elements == null
            ? new JsArray()
            : new JsArray.from(
                codec == null ? elements : elements.map(codec.encode))
      ]), codec);

  _MVCArray.created(JsObject o,
      [Codec<E, dynamic> codec])
      : _codec = codec != null ? codec : new IdentityCodec(),
        super.created(o);

  void clear();
  void forEach(void callback(E o, num index)) =>
      _forEach((o, num index) => callback(_codec.decode(o), index));
  void _forEach(void callback(o, num index));
  List<E> getArray() => new JsList.created(_getArray(), _codec);
  JsArray _getArray();
  E getAt(num i) => _codec.decode(_getAt(i));
  _getAt(num i);
  num get length => _getLength();
  num _getLength();
  void insertAt(num i, E elem) => _insertAt(i, _codec.encode(elem));
  void _insertAt(num i, elem);
  E pop() => _codec.decode(_pop());
  _pop();
  num push(E elem) => _push(_codec.encode(elem));
  num _push(elem);
  E removeAt(num i) => _codec.decode(_removeAt(i));
  _removeAt(num i);
  void setAt(num i, E elem) => _setAt(i, _codec.encode(elem));
  void _setAt(num i, elem);

  Stream<int> get onInsertAt => getStream(this, #onInsertAt, "insert_at");
  Stream<IndexAndElement<E>> get onRemoveAt => getStream(this, #onClick,
      "click", (int index, oldElement) =>
          new IndexAndElement<E>(index, _codec.decode(oldElement)));
  Stream<IndexAndElement<E>> get onSetAt => getStream(this, #onClick, "click",
      (int index, oldElement) =>
          new IndexAndElement<E>(index, _codec.decode(oldElement)));
}

class IndexAndElement<E> {
  final int index;
  final E element;
  IndexAndElement(this.index, this.element);
}
''',
  'ImageMapType': '''
@JsName('google.maps.ImageMapType')
abstract class _ImageMapType extends MVCObject implements MapType {
  external factory _ImageMapType(ImageMapTypeOptions opts);

  num get opacity => _getOpacity();
  num _getOpacity();
  Node getTile(Point tileCoord, num zoom, Document ownerDocument);
  void releaseTile(Node tile);
  void set opacity(num opacity) => _setOpacity(opacity);
  void _setOpacity(num opacity);

  String alt;
  num maxZoom;
  num minZoom;
  String name;
  Projection projection;
  num radius;
  Size tileSize;

  Stream get onTilesloaded => getStream(this, #onTilesloaded, "tilesloaded");
}
''',
  'StrokePosition': '''
@JsEnum()
@JsName('google.maps.StrokePosition')
enum StrokePosition { CENTER, INSIDE, OUTSIDE }
''',
  'MapsEngineStatus': '''
@JsEnum()
@JsName('google.maps.visualization.MapsEngineStatus')
enum MapsEngineStatus { INVALID_LAYER, OK, UNKNOWN_ERROR }
'''
};

final defaultImports = '''
import 'dart:async' show Stream;
import 'dart:collection' show MapMixin;
import 'dart:html' show Node, Document, InputElement;

import 'package:js/js.dart';
import 'package:js/adapter/js_list.dart';
import 'package:js/util/codec.dart';

import 'package:google_maps/util/async.dart';
import 'package:google_maps/src/google_maps.dart';
''';

final importsByLib = <String, String>{
  'google_maps': '''
import 'dart:async' show Stream;
import 'dart:collection' show MapMixin;
import 'dart:html' show Node, Document;

import 'package:js/js.dart';
import 'package:js/adapter/js_list.dart';
import 'package:js/util/codec.dart';

import 'package:google_maps/util/async.dart';
'''
};

final additionalContentByLib = <String, String>{
  'google_maps': '''

abstract class _Controls extends JsInterface
    with MapMixin<ControlPosition, MVCArray<Node>> {
  _Controls() : super.created(new JsArray());

  MVCArray<Node> operator [](ControlPosition controlPosition) {
    var value = asJsObject(this)[_toJsControlPosition(controlPosition)];
    if (value == null) return null;
    return new MVCArray<Node>.created(value);
  }
  void operator []=(ControlPosition controlPosition, MVCArray<Node> nodes) {
    asJsObject(this)[_toJsControlPosition(controlPosition)] = asJsObject(nodes);
  }
  Iterable<ControlPosition> get keys {
    var result = <ControlPosition>[];
    for (final control in ControlPosition.values) {
      if (this[control] != null) result.add(control);
    }
    return result;
  }
  MVCArray<Node> remove(Object key) {
    var result = this[key];
    this[key] = null;
    return result;
  }
  void clear() => (asJsObject(this) as JsArray).clear();

  _toJsControlPosition(ControlPosition controlPosition) => ((e) {
    if (e == null) return null;
    final path = getPath('google.maps.ControlPosition');
    if (e == ControlPosition.BOTTOM_CENTER) return path['BOTTOM_CENTER'];
    if (e == ControlPosition.BOTTOM_LEFT) return path['BOTTOM_LEFT'];
    if (e == ControlPosition.BOTTOM_RIGHT) return path['BOTTOM_RIGHT'];
    if (e == ControlPosition.LEFT_BOTTOM) return path['LEFT_BOTTOM'];
    if (e == ControlPosition.LEFT_CENTER) return path['LEFT_CENTER'];
    if (e == ControlPosition.LEFT_TOP) return path['LEFT_TOP'];
    if (e == ControlPosition.RIGHT_BOTTOM) return path['RIGHT_BOTTOM'];
    if (e == ControlPosition.RIGHT_CENTER) return path['RIGHT_CENTER'];
    if (e == ControlPosition.RIGHT_TOP) return path['RIGHT_TOP'];
    if (e == ControlPosition.TOP_CENTER) return path['TOP_CENTER'];
    if (e == ControlPosition.TOP_LEFT) return path['TOP_LEFT'];
    if (e == ControlPosition.TOP_RIGHT) return path['TOP_RIGHT'];
  })(controlPosition);
}

'''
};

final ignoredClasses = <String>['LatLngLiteral', 'undefined'];

final declarationSubstitutions = <String, Map<String, Map<String, String>>>{
  'google_maps': {
    'GMap': {'controls': 'Controls controls;',},
    'LatLng': {
      'lat': '''
num get lat => _lat();
num _lat();''',
      'lng': '''
num get lng => _lng();
num _lng();''',
    },
    'LatLngBounds': {
      'isEmpty': '''
bool get isEmpty => _isEmpty();
bool _isEmpty();''',
    },
    'Data': {
      'getStyle': '''
  dynamic /*DataStylingFunction|DataStyleOptions*/ get style =>
      (new ChainedCodec()
    ..add(new FunctionCodec<DataStylingFunction>((o) => ((f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .decode(p_dataFeature);
        final result = f(p_dataFeature);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .encode(result);
      };
    })(o), (o) => ((JsFunction f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .encode(p_dataFeature);
        final result = f.apply([p_dataFeature]);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .decode(result);
      };
    })(o)))
    ..add(new JsInterfaceCodec<DataStyleOptions>(
        (o) => new DataStyleOptions.created(o)))).decode(_getStyle());
  _getStyle();''',
      'setStyle': '''
  void set style(dynamic /*DataStylingFunction|DataStyleOptions*/ style) =>
      _setStyle((new ChainedCodec()
    ..add(new FunctionCodec<DataStylingFunction>((o) => ((f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .decode(p_dataFeature);
        final result = f(p_dataFeature);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .encode(result);
      };
    })(o), (o) => ((JsFunction f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .encode(p_dataFeature);
        final result = f.apply([p_dataFeature]);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .decode(result);
      };
    })(o)))
    ..add(new JsInterfaceCodec<DataStyleOptions>(
        (o) => new DataStyleOptions.created(o)))).encode(style));
  void _setStyle(dynamic /*DataStylingFunction|DataStyleOptions*/ style);''',
    },
    'DataDataOptions': {
      'style': '''
  dynamic /*DataStylingFunction|DataStyleOptions*/ get style =>
      (new ChainedCodec()
    ..add(new FunctionCodec<DataStylingFunction>((o) => ((f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .decode(p_dataFeature);
        final result = f(p_dataFeature);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .encode(result);
      };
    })(o), (o) => ((JsFunction f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .encode(p_dataFeature);
        final result = f.apply([p_dataFeature]);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .decode(result);
      };
    })(o)))
    ..add(new JsInterfaceCodec<DataStyleOptions>(
        (o) => new DataStyleOptions.created(o)))).decode(_style);
  void set style(dynamic /*DataStylingFunction|DataStyleOptions*/ style) =>
      _style = (new ChainedCodec()
    ..add(new FunctionCodec<DataStylingFunction>((o) => ((f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .decode(p_dataFeature);
        final result = f(p_dataFeature);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .encode(result);
      };
    })(o), (o) => ((JsFunction f) {
      if (f == null) return null;
      return (p_dataFeature) {
        p_dataFeature = new JsInterfaceCodec<DataFeature>((o) =>
                ((e) => e == null ? null : new DataFeature.created(e))(o))
            .encode(p_dataFeature);
        final result = f.apply([p_dataFeature]);
        return new JsInterfaceCodec<DataStyleOptions>((o) =>
                ((e) => e == null ? null : new DataStyleOptions.created(e))(o))
            .decode(result);
      };
    })(o)))
    ..add(new JsInterfaceCodec<DataStyleOptions>(
        (o) => new DataStyleOptions.created(o)))).encode(_style);
  dynamic /*DataStylingFunction|DataStyleOptions*/ _style;''',
    },

    // FIXME https://code.google.com/p/gmaps-api-issues/issues/detail?id=7910
    'MapTypeControlOptions': {
      'mapTypeIds': '''
  dynamic get _mapTypeIds => asJsObject(this)['mapTypeIds'];
  List<dynamic /*MapTypeId|String*/ > get mapTypeIds =>
      (new JsListCodec<dynamic /*MapTypeId|String*/ >(new ChainedCodec()
    ..add(new BiMapCodec<MapTypeId, dynamic>({
      MapTypeId.HYBRID: getPath('google.maps.MapTypeId')['HYBRID'],
      MapTypeId.ROADMAP: getPath('google.maps.MapTypeId')['ROADMAP'],
      MapTypeId.SATELLITE: getPath('google.maps.MapTypeId')['SATELLITE'],
      MapTypeId.TERRAIN: getPath('google.maps.MapTypeId')['TERRAIN']
    }))
    ..add(new IdentityCodec<String>()))).decode(_mapTypeIds);
  void set _mapTypeIds(dynamic mapTypeIds) {
    asJsObject(this)['mapTypeIds'] = mapTypeIds;
  }
  void set mapTypeIds(List<dynamic /*MapTypeId|String*/ > mapTypeIds) {
    _mapTypeIds = (new JsListCodec<dynamic /*MapTypeId|String*/ >(
        new ChainedCodec()
      ..add(new BiMapCodec<MapTypeId, dynamic>({
        MapTypeId.HYBRID: getPath('google.maps.MapTypeId')['HYBRID'],
        MapTypeId.ROADMAP: getPath('google.maps.MapTypeId')['ROADMAP'],
        MapTypeId.SATELLITE: getPath('google.maps.MapTypeId')['SATELLITE'],
        MapTypeId.TERRAIN: getPath('google.maps.MapTypeId')['TERRAIN']
      }))
      ..add(new IdentityCodec<String>()))).encode(mapTypeIds);
  }
''',
    },
  }
};

main() async {
  final genFolder = 'lib/src';
//  final request = await new HttpClient().getUrl(Uri.parse(
//      'https://developers.google.com/maps/documentation/javascript/reference'));
//  final response = await request.close();
//  final content = await UTF8.decodeStream(response);
  final content = new File('api/api.html').readAsStringSync();
  final document = parse(content);
  final libraries = <String, List<JsElement>>{};
  document.querySelectorAll("#gc-content>div>ul").forEach((ul) {
    var folder = underscores(ul.previousElementSibling.attributes['id']);

    var libraryName = 'google_maps';
    if (folder.endsWith('_library')) {
      final lib = folder.substring(0, folder.length - '_library'.length);
      folder = 'library/$lib';
      libraryName += '.$lib';
    } else {
      folder = 'core/$folder';
    }

    ul.children.forEach((li) {
      final h2id = li.firstChild.attributes['href'].substring(1);
      final fileName = underscores(h2id) + '.dart';
      final file = new File('$genFolder/$folder/$fileName')
        ..createSync(recursive: true);

      final title = document.querySelector("#gc-content h2[id='$h2id']");

      libraries
          .putIfAbsent(libraryName, () => <JsElement>[])
          .add(new JsElement(h2id, file, title.parent));
    });
  });

  // generate contents
  libraries.keys.forEach((libraryName) {
    var imports = importsByLib[libraryName];
    if (imports == null) imports = defaultImports;
    var libContents = '''
$LICENCE

library $libraryName;

$imports

part '${libraryName.replaceAll('.', '_')}.g.dart';

''';
    libContents += libraries[libraryName]
        .where((e) => !ignoredClasses.contains(e.name))
        .map((e) => e.file.path.substring(genFolder.length + 1))
        .map((path) => "part '$path';")
        .join('\n');

    if (additionalContentByLib.containsKey(libraryName)) {
      libContents += additionalContentByLib[libraryName];
    }

    libContents = new DartFormatter().format(libContents);
    new File('$genFolder/${libraryName.replaceAll('.', '_')}.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync(libContents);

    final jsElements = libraries.values.expand((e) => e).toList();

    libraries[libraryName]
        .where((e) => !ignoredClasses.contains(e.name))
        .forEach((jsElmt) {
      var partContents = '''
$LICENCE

part of $libraryName;

''';

      if (customContent.containsKey(jsElmt.id)) {
        partContents += customContent[jsElmt.id];
      } else if (jsElmt.isEnum) {
        final constants = jsElmt.constants
            .map((tr) => tr.getElementsByTagName('td')[0].text.trim());

        String toEnumValue(String v) => v.replaceAll('.', '_').toUpperCase();

        final names = {};
        for (final e in constants) {
          final dartName = toEnumValue(e);
          if (dartName != e) names[dartName] = e;
        }

        if (jsElmt.isAnonymousObject) {
          final codecName =
              jsElmt.name[0].toLowerCase() + jsElmt.name.substring(1) + 'Codec';
          partContents +=
              "final $codecName = new BiMapCodec<${jsElmt.name}, dynamic>({";
          names.forEach((k, v) {
            partContents += "${jsElmt.name}.$k: '$v',";
          });
          partContents += "}); ";
          partContents += "@JsCodec(#$codecName) ";
        } else {
          if (names.isEmpty) partContents += "@JsEnum()";
          else {
            partContents += "@JsEnum(names: const {";
            names.forEach((k, v) {
              partContents += "${jsElmt.name}.$k: '$v',";
            });
            partContents += "})";
          }
          partContents += " @JsName('${jsElmt.fullName}') ";
        }

        partContents +=
            'enum ${jsElmt.name}{${constants.map(toEnumValue).join(',')}}\n\n';

        // codec
//        partContents += 'final ' +
//            getCodecName(jsElmt) +
//            ' = ' +
//            'new BiMapCodec<${jsElmt.name}, dynamic>' +
//            '(<${jsElmt.name}, dynamic>{';
//        for (final c in constants) {
//          partContents +=
//              "${jsElmt.name}.$c: getPath('${jsElmt.fullName}')['$c'],";
//        }
//        partContents += '});\n';
      } else if (jsElmt.isNamespace ||
          jsElmt.isAnonymousObject ||
          jsElmt.isClass) {
        final className = jsElmt.isNamespace
            ? jsElmt.name[0].toUpperCase() + jsElmt.name.substring(1)
            : jsElmt.name;
        final inherit = getExtends(jsElmt.element.querySelector('h2'));
        if (jsElmt.isAnonymousObject) partContents += '@anonymous\n';
        if (jsElmt.isClass) partContents += "@JsName('${jsElmt.fullName}')\n";
        if (jsElmt.isNamespace) {
          partContents +=
              "final ${jsElmt.name} = new $className.created(getPath('${jsElmt.fullName}'));";
        }
        partContents += 'abstract class _$className ' +
            (inherit != null
                ? 'extends ${inherit.replaceAll('.', '')}'
                : 'implements JsInterface') +
            ' {\n';

        // add constructors
        final constr = jsElmt.constructor;
        if (constr != null) {
          final decl = constr.getElementsByTagName('td')[0].text.trim();
          final parameters =
              decl.substring(decl.indexOf('(') + 1, decl.lastIndexOf(')'));
          final params = splitParameters(parameters);
          partContents += '  external factory '
              '_$className(${params.toSignature(jsElements)});\n';
        } else if (jsElmt.isAnonymousObject) {
          partContents += '  external factory _$className();\n';
        }
        partContents += '\n';

        // add methods
        jsElmt.methods.forEach((methodTr) {
          final decl = methodTr.getElementsByTagName('td')[0].text.trim();
          final returnType = methodTr.getElementsByTagName('td')[1].text.trim();
          final methodName = decl.substring(0, decl.indexOf('('));

          if (declarationSubstitutions.containsKey(libraryName) &&
              declarationSubstitutions[libraryName].containsKey(jsElmt.name) &&
              declarationSubstitutions[libraryName][jsElmt.name]
                  .containsKey(methodName)) {
            partContents += declarationSubstitutions[libraryName][jsElmt.name][
                methodName] +
                '\n';
            return;
          }

          final parameters =
              decl.substring(decl.indexOf('(') + 1, decl.lastIndexOf(')'));
          final params = splitParameters(parameters);
          final allParams = ({}
            ..addAll(params.mandatory)
            ..addAll(params.optional));
          final paramsCodecs = new Map.fromIterable(allParams.keys,
              value: (k) => getCodec(allParams[k], jsElements));
          final returnCodec = getCodec(returnType, jsElements);
          final convertedReturnType = convertType(returnType, jsElements);
          if (methodName.startsWith(new RegExp('get[A-Z]')) &&
              params.mandatory.isEmpty &&
              params.optional.isEmpty) {
            final name = methodName[3].toLowerCase() + methodName.substring(4);
            partContents += '  $convertedReturnType get $name => ';
            if (returnCodec.canBeNativelyHandled) {
              partContents += '_$methodName();\n';
              partContents += '  $convertedReturnType _$methodName();\n';
            } else {
              partContents +=
                  '(${returnCodec.codec}).decode(_$methodName());\n';
              partContents += '  _$methodName();\n';
            }
          } else if (methodName.startsWith(new RegExp('set[A-Z]')) &&
              params.mandatory.length == 1 &&
              params.optional.isEmpty) {
            final name = methodName[3].toLowerCase() + methodName.substring(4);
            final p = params.mandatory.keys.first;
            partContents +=
                '  void set $name(${params.toSignature(jsElements)}) => ';
            if (paramsCodecs.values.first.canBeNativelyHandled) {
              partContents += '_$methodName($p);\n';
            } else {
              partContents +=
                  '_$methodName((${paramsCodecs.values.first.codec}).encode($p));\n';
            }
            partContents +=
                '  void _$methodName(${params.toSignature(jsElements)});\n';
          } else {
            if (paramsCodecs.values.every((p) => p.canBeNativelyHandled) &&
                returnCodec.canBeNativelyHandled) {
              partContents +=
                  '  $convertedReturnType $methodName(${params.toSignature(jsElements)});\n';
            } else {
              final returnVoid = convertedReturnType == 'void';
              partContents +=
                  '  $convertedReturnType $methodName(${params.toSignature(jsElements)})';
              partContents += returnVoid ? '{' : ' => ';
              if (!returnCodec.canBeNativelyHandled) {
                partContents += '(${returnCodec.codec}).decode(';
              }
              partContents += '_$methodName(' +
                  paramsCodecs.keys
                      .map((p) => paramsCodecs[p].canBeNativelyHandled
                          ? p
                          : '(${paramsCodecs[p].codec}).encode($p)')
                      .join(',') +
                  ')';
              if (!returnCodec.canBeNativelyHandled) {
                partContents += ')';
              }
              partContents += ';';
              if (returnVoid) partContents += '}';
              partContents +=
                  '  _$methodName(${params.toSignature(jsElements)});\n';
            }
          }
        });
        partContents += '\n';

        // add properties
        jsElmt.properties.forEach((propertiesTr) {
          final name = propertiesTr.getElementsByTagName('td')[0].text.trim();
          final type = propertiesTr.getElementsByTagName('td')[1].text.trim();
          if (declarationSubstitutions.containsKey(libraryName) &&
              declarationSubstitutions[libraryName].containsKey(jsElmt.name) &&
              declarationSubstitutions[libraryName][jsElmt.name]
                  .containsKey(name)) {
            partContents +=
                declarationSubstitutions[libraryName][jsElmt.name][name] + '\n';
          } else {
            final typeCodec = getCodec(type, jsElements);
            final convertedType = convertType(type, jsElements);
            final dartName = !name.contains('_')
                ? name
                : name.replaceAllMapped(
                    new RegExp('_([a-z])'), (m) => m[1].toUpperCase());
            if (typeCodec.canBeNativelyHandled) {
              if (dartName == name) {
                partContents += '  $convertedType $name;\n';
              } else {
                partContents += '  $convertedType _$name;\n';
                partContents += '  $convertedType get $dartName => _$name;\n';
                partContents +=
                    '  void set $dartName($convertedType $dartName) { _$name = $dartName; }\n';
              }
            } else {
              partContents += '''
  dynamic _$name;
  $convertedType get $dartName => (${typeCodec.codec}).decode(_$name);
  void set $dartName($convertedType $dartName) {
    _$name = (${typeCodec.codec}).encode($dartName);
  }''';
            }
          }
        });
        partContents += '\n';

        // add events
        jsElmt.events.forEach((eventsTr) {
          String name = eventsTr.getElementsByTagName('td')[0].text.trim();
          String type = eventsTr.getElementsByTagName('td')[1].text.trim();
          if (type.contains(',')) throw 'multiple args on event not supported';
          type = convertType(type, jsElements);

          final streamName = 'on' +
              name[0].toUpperCase() +
              name.substring(1).replaceAllMapped(
                  new RegExp('_[a-z]'), (m) => m[0][1].toUpperCase());
          if (type == 'void') {
            partContents += '''
Stream get $streamName => getStream(this, #$streamName, "$name");
''';
          } else if (<String>[
            'num',
            'JsObject',
            'String',
            'bool'
          ].contains(type)) {
            partContents += '''
Stream<$type> get $streamName => getStream(this, #$streamName, "$name");
''';
          } else {
            partContents += '''
Stream<$type> get $streamName => getStream(
  this, #$streamName, "$name", (JsObject o) => new $type.created(o));
''';
          }
        });

        partContents += '}\n';
      }

      partContents = new DartFormatter().format(partContents);
      jsElmt.file.writeAsStringSync(partContents);
    });
  });
}

String getCodecName(JsElement jsElmt) =>
    jsElmt.name[0].toLowerCase() + jsElmt.name.substring(1) + 'Codec';

class Parameters {
  final mandatory = <String, String>{};
  final optional = <String, String>{};

  void add(String name, String type) {
    if (name.endsWith('?')) {
      name = name.substring(0, name.length - 1);
      optional[name] = type;
    } else {
      mandatory[name] = type;
    }
  }

  String toSignature(List<JsElement> jsElements) {
    var result = mandatory.keys
        .map((name) => convertParam(mandatory[name], jsElements, name))
        .join(',');
    if (optional.isNotEmpty) {
      if (result.isNotEmpty) result += ',';
      result += '[' +
          optional.keys
              .map((name) => convertParam(optional[name], jsElements, name))
              .join(',') +
          ']';
    }
    return result;
  }
}

Parameters splitParameters(String parameters) {
  final result = new Parameters();

  final paramsParts = <String>[];
  var parenthesisDeepth = 0;
  final buffer = new StringBuffer();
  for (int i = 0; i < parameters.length; i++) {
    var c = parameters[i];
    if (c == ',' && parenthesisDeepth == 0) {
      paramsParts.add(buffer.toString());
      buffer.clear();
      continue;
    }
    if (c == '(') parenthesisDeepth++;
    else if (c == ')') parenthesisDeepth--;
    buffer.write(c);
  }
  if (buffer.isNotEmpty) paramsParts.add(buffer.toString());

  paramsParts.map((p) => p.split(':')).forEach((e) {
    result.add(e[0], (e.length == 1) ? '' : e[1]);
  });

  return result;
}

String convertParam(String type, List<JsElement> jsElements, String name) {
  if (type.startsWith('function(')) {
    return convertType(type, jsElements, name: name);
  } else {
    return convertType(type, jsElements) + ' $name';
  }
}

class CodecInfo {
  final String codec;
  final bool canBeNativelyHandled;
  final bool isIdentity;
  CodecInfo(this.codec, this.canBeNativelyHandled, this.isIdentity);
}

CodecInfo getCodec(String type, List<JsElement> jsElements) {
  type = type.trim();
  if (splitUnionTypes(type).length > 1) {
    for (String ignoredClass in ignoredClasses) {
      if (type.startsWith('$ignoredClass|')) {
        return getCodec(type.substring('$ignoredClass|'.length), jsElements);
      }
      if (type.endsWith('|$ignoredClass')) {
        return getCodec(
            type.substring(0, type.lastIndexOf('|$ignoredClass')), jsElements);
      }
      if (type.contains('|$ignoredClass|')) {
        return getCodec(type.replaceAll('|$ignoredClass|', '|'), jsElements);
      }
    }
    final typeUnion = splitUnionTypes(type);
    final codecInfos = typeUnion.map((t) => getCodec(t, jsElements));
    if (codecInfos.any((ci) => !ci.isIdentity)) {
      return new CodecInfo('new ChainedCodec()' +
              codecInfos.map((ci) => '..add(' + ci.codec + ')').join(), false,
          false);
    } else {
      return new CodecInfo('new IdentityCodec()', true, true);
    }
  } else if (type.startsWith('Object<') && type.endsWith('>')) {
    return new CodecInfo('FUCK', true, true);
  } else if (type.startsWith('Array<') && type.endsWith('>')) {
    final innerType = type.substring('Array<'.length, type.length - 1);
    final convertedInnerType = convertType(innerType, jsElements);
    final innerCodecInfo = getCodec(innerType, jsElements);
    return new CodecInfo('new JsListCodec<$convertedInnerType>'
        '(${innerCodecInfo.codec})', innerCodecInfo.canBeNativelyHandled,
        false);
  } else if (type.startsWith('function(')) {
    return new CodecInfo('PLEASE_IMPLEMENT_MANUALLY', true, true);
  } else if (jsElements.any((e) => e.id == type)) {
    final jsElmt = jsElements.firstWhere((e) => e.id == type);
    final convertedType = convertType(type, jsElements);
    if (jsElmt.isEnum) {
      final constants = jsElmt.constants
          .map((tr) => tr.getElementsByTagName('td')[0].text.trim());
      return new CodecInfo('new BiMapCodec<$convertedType, dynamic>({' +
          constants
              .map((e) =>
                  "${jsElmt.name}.$e: getPath('${jsElmt.fullName}')['$e']")
              .join(',') +
          '})', true, false);
    } else if (jsElmt.isAnonymousObject) {
      return new CodecInfo('new JsInterfaceCodec<$convertedType>'
          '((o) => new $convertedType.created(o))', true, false);
    } else {
      return new CodecInfo('new JsInterfaceCodec<$convertedType>'
          '((o) => new $convertedType.created(o), '
          '(o) => o != null && o.instanceof(getPath("${jsElmt.fullName}")))',
          true, false);
    }
  } else if (type.startsWith('MVCArray<') && type.endsWith('>')) {
    final innerType = type.substring('MVCArray<'.length, type.length - 1);
    final convertedInnerType = convertType(innerType, jsElements);
    final innerCodecInfo = getCodec(innerType, jsElements);
    return new CodecInfo('new JsInterfaceCodec<MVCArray<$convertedInnerType>>'
        '((o) => new MVCArray<$convertedInnerType>.created(o, ${innerCodecInfo.codec}))',
        false, false);
  } else {
    final convertedType = convertType(type, jsElements);
    return new CodecInfo('new IdentityCodec<$convertedType>()', true, true);
  }
}

String convertType(String type, List<JsElement> jsElements, {String name}) {
  type = type.trim();
  if (type == 'boolean') return 'bool';
  else if (type == 'number') return 'num';
  else if (type == 'string') return 'String';
  else if (type == 'Date') return 'DateTime';
  else if (type == 'HTMLInputElement') return 'InputElement';
  else if (type == 'Event') return 'JsObject';
  else if (type == 'Array') return 'List';
  else if (type == 'None') return 'void';
  else if (type == '*') return 'dynamic';
  else if (splitUnionTypes(type).length > 1) {
    for (String ignoredClass in ignoredClasses) {
      if (type.startsWith('$ignoredClass|')) {
        return convertType(type.substring('$ignoredClass|'.length), jsElements,
            name: name);
      }
      if (type.endsWith('|$ignoredClass')) {
        return convertType(
            type.substring(0, type.lastIndexOf('|$ignoredClass')), jsElements,
            name: name);
      }
      if (type.contains('|$ignoredClass|')) {
        return convertType(type.replaceAll('|$ignoredClass|', '|'), jsElements,
            name: name);
      }
    }
    final typeUnion = splitUnionTypes(type);
    final dartUnion =
        typeUnion.map((t) => convertType(t, jsElements)).join('|');
    return 'dynamic/*$dartUnion*/';
  } else if (type.startsWith('Object<') && type.endsWith('>')) {
    final innerType = convertType(
        type.substring('Object<'.length, type.length - 1), jsElements,
        name: name);
    return 'Map<String, $innerType>';
  } else if (type.startsWith('Array<') && type.endsWith('>')) {
    final innerType = convertType(
        type.substring('Array<'.length, type.length - 1), jsElements,
        name: name);
    return 'List<$innerType>';
  } else if (type.startsWith('function(')) {
    final functionParams =
        type.substring('function('.length, type.length - 1).split(',');
    int i = 1;
    final params = functionParams
        .map((p) => convertType(p, jsElements))
        .map((p) => '$p p${i++}')
        .join(',');
    type = '$name($params)';
    if (name == null) type = 'dynamic/*$type*/';
    return type;
  } else if (jsElements.any((e) => e.id == type)) {
    return jsElements.firstWhere((e) => e.id == type).name;
  } else if (type.startsWith('MVCArray<') && type.endsWith('>')) {
    final innerType = convertType(
        type.substring('MVCArray<'.length, type.length - 1), jsElements,
        name: name);
    return 'MVCArray<$innerType>';
  } else {
    return type;
  }
}

List<String> splitUnionTypes(String type) {
  final typeParts = <String>[];
  var parenthesisDeepth = 0;
  var genericDeepth = 0;
  final buffer = new StringBuffer();
  for (int i = 0; i < type.length; i++) {
    var c = type[i];
    if (c == '|' && parenthesisDeepth == 0 && genericDeepth == 0) {
      typeParts.add(buffer.toString());
      buffer.clear();
      continue;
    }
    if (c == '(') parenthesisDeepth++;
    if (c == ')') parenthesisDeepth--;
    if (c == '<') genericDeepth++;
    if (c == '>') genericDeepth--;
    buffer.write(c);
  }
  if (buffer.isNotEmpty) typeParts.add(buffer.toString());
  return typeParts;
}

String getExtends(Element title) {
  var e = title;
  while (true) {
    e = e.nextElementSibling;
    if (e == null || e.localName != 'p') return null;
    if (e.text.startsWith('This class extends')) {
      return e.querySelector('a').attributes['href'].substring(1);
    }
    if (e.text.startsWith('This object extends')) {
      return e.querySelector('a').attributes['href'].substring(1);
    }
  }
}

class JsElement {
  final String id;
  final File file;
  final Element element;

  JsElement(this.id, this.file, this.element);

  String get name => customClassName.containsKey(id)
      ? customClassName[id]
      : id.replaceAll('.', '');

  String get fullName {
    final title = element.querySelector('h2');
    final path = title.querySelector('span[itemprop="path"]');
    var name = title.querySelector('span[itemprop="name"]').text.trim();
    if (path != null && path.text.trim().isNotEmpty) {
      name = path.text.trim() + '.' + name;
    }
    return name;
  }

  Element get constructor =>
      element.querySelector(r"table[summary$='Constructor']>tbody>tr");

  List<Element> get methods =>
      element.querySelectorAll(r"table[summary$='Methods']>tbody>tr");

  List<Element> get properties =>
      element.querySelectorAll(r"table[summary$='Properties']>tbody>tr");

  List<Element> get constants =>
      element.querySelectorAll(r"table[summary$='Constants']>tbody>tr");

  List<Element> get events =>
      element.querySelectorAll(r"table[summary$='Events']>tbody>tr");

  bool get isNamespace =>
      element.querySelector('h2').text.trim().endsWith('namespace');
  bool get isEnum => (isClass || isAnonymousObject) &&
      element.querySelectorAll('h3').isNotEmpty &&
      element
          .querySelectorAll('h3')
          .every((e) => ['Constant', 'Library'].contains(e.text.trim()));
  bool get isClass => element.querySelector('h2').text.trim().endsWith('class');
  bool get isAnonymousObject =>
      element.querySelector('h2').text.trim().endsWith('object specification');
  bool get isTypeDef =>
      element.querySelector('h2').text.trim().endsWith('typedef');
}

String underscores(String name) => name
    .replaceAllMapped(
        new RegExp('([a-z])([A-Z])'), (m) => '${m[1]}_${m[2].toLowerCase()}')
    .replaceAll('-', '_')
    .replaceAll('.', '_')
    .toLowerCase();