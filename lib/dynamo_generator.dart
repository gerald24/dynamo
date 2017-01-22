// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Copied from library source_gen, adapted for dynamo.

library dynamo.generator;

import 'dart:async';
import 'dart:mirrors';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';
import 'package:source_gen/src/utils.dart';

import 'dynamo.dart';

class DynamoMixinGenerator extends GeneratorForAnnotation<DynamoSerializable> {
  const DynamoMixinGenerator();

  @override
  Future<String> generateForAnnotatedElement(Element element, DynamoSerializable annotation, _) async {
    _validateClassElement(element);

    var classElement = element as ClassElement;
    var className = classElement.name;


// TODO use log instead
    print("Generate protocol implementation for ${classElement}");

    _validateUnnamedConstructorExists(classElement);

    var jsonMapVar = r'_$jsonMap';
    var encodingSupportVar = r'_$dynamoEncodingSupport';
    var decodingSupportVar = r'_$dynamoDecodingSupport';

    var fields = _allFieldsNeedToBeAssigned(classElement);
    var fieldsDeclarations = _createFieldDeclarations(fields);
    var assignToJsonMap = _createAssignmentToJsonMap(fields, encodingSupportVar, jsonMapVar);
    var assignFromJsonMap = _createAssignmentFromJsonMap(fields, decodingSupportVar, jsonMapVar);

    return _mixinDeclaration(
        className,
        classElement.supertype == null || classElement.supertype.isObject,
        jsonMapVar,
        encodingSupportVar,
        decodingSupportVar,
        fieldsDeclarations,
        assignToJsonMap,
        assignFromJsonMap);
  }

  void _validateUnnamedConstructorExists(ClassElement classElement) {
    // TODO make sure unnamed ctor exists
  }

  _createFieldDeclarations(Map<String, FieldElement> fields) {
    var buffer = new StringBuffer();
    fields.forEach((name, element) {
      buffer.writeln("  ${element.type.displayName} get ${element.name};");
      buffer.writeln("  set ${element.name}(${element.type.displayName} value);");
    });
    return buffer;
  }

  _createAssignmentToJsonMap(Map<String, FieldElement> fields, String encodingSupportVar, String jsonMapVar) {
    var buffer = new StringBuffer();
    fields.forEach((name, element) => buffer.writeln("    ${encodingSupportVar}.addValue(${jsonMapVar}, r'${name}', this.${element.name});"));
    return buffer;
  }

  _createAssignmentFromJsonMap(Map<String, FieldElement> fields, String decodingSupportVar, String jsonMapVar) {
    var buffer = new StringBuffer();
    fields.forEach((name, element) {
      var accessor = _accessorForField(element, decodingSupportVar, "${jsonMapVar}[r'${name}']");
      buffer.writeln("    this.${element.name} = ${accessor};");
    });
    return buffer;
  }

  _accessorForField(FieldElement element, String decodingSupportVar, String mapAccess) {
    if (_isDartDateTime(element.type)) {
      return "${decodingSupportVar}.decodeDateTime(${mapAccess})";
    }
    if (_isDartList(element.type)) {
      var factory = r'';
      if (element.type is ParameterizedType) {
        DartType tpe = (element.type as ParameterizedType).typeArguments
            .firstWhere((e) =>
            _isDynamoSupported(e), orElse: () => null);
        if (tpe != null) {
          factory = getFactory(tpe, decodingSupportVar);
        }
      }
      return "${decodingSupportVar}.decodeList(${mapAccess}${factory}) as ${element.type.displayName}";
    }
    if (_isDartMap(element.type)) {
      return "${decodingSupportVar}.decodeMap(${mapAccess})${_castIfNeeded(element)}";
    }

    if (_isSimpleType(element.type)) {
      return mapAccess;
    }

    return "${decodingSupportVar}.decodeDynamic(${mapAccess})${_castIfNeeded(element)}";
  }

  bool _isSimpleType(DartType type) =>
        type.element.library != null &&
            type.element.library.isDartCore &&
            ['bool','String','num','int','double','float'].contains(type.name);


  _castIfNeeded(FieldElement element) {
    if (element.type is ParameterizedType) {
      return " as ${element.type.displayName}";
    } else {
      return "";
    }
  }

  String getFactory(DartType type, String decodingSupportVar) {
    var isAbstract =type != null && type.element is ClassElement && (type.element as ClassElement).isAbstract;
    var factory = isAbstract ? "${decodingSupportVar}.throwAbstractClassError()" : "new ${type.name}()";
    return ", factory: () => ${factory}";
  }

  bool _isDartList(DartType type) =>
      type.element.library != null &&
          type.element.library.isDartCore &&
          type.name == 'List'; // TODO support iterable also?

  bool _isDartMap(DartType type) =>
      type.element.library != null &&
          type.element.library.isDartCore &&
          type.name == 'Map'; // TODO check types oder datetime used for key/value

  bool _isDartDateTime(DartType type) =>
      type.element.library != null &&
          type.element.library.isDartCore &&
          type.name == 'DateTime'; // TODO support list of datetime

  bool _isDynamoSupported(DartType type)  {
    print("_isDynamoSupported ${type}");

    return  type.element.metadata.any((m) {
      var annotationValueType = m.constantValue?.type;
      if (annotationValueType != null) {
        return matchAnnotation(DynamoSerializable, m);
      }
      var classMirror = reflectClass(DynamoSerializable);
      var classMirrorSymbol = classMirror.simpleName;

      var compilationUnitName = (m.element.enclosingElement as ClassElement).type.name;
      var compilationUnitNameSymbol = new Symbol(compilationUnitName);

      return classMirrorSymbol == compilationUnitNameSymbol;
    });
  }

  String _mixinDeclaration(String className, bool isRoot, String jsonMapVar, String encodingSupportVar, String decodingSupportVar,
      fieldsDeclarations, assignToJsonMap, assignFromJsonMap) {
    if (isRoot) {
      return """
abstract class _\$${className}DynamoMixin implements DynamoProtocol<${className}> {
${fieldsDeclarations}

  Map<String, dynamic> asJsonSerializableMap(DynamoEncodingSupport ${encodingSupportVar}) {
    var ${jsonMapVar} = ${encodingSupportVar}.newJsonSerializableMap(this);
${assignToJsonMap}
    return ${jsonMapVar};
  }

  void fromJsonSerializableMap(Map<String, dynamic> ${jsonMapVar}, DynamoDecodingSupport ${decodingSupportVar}) {
${assignFromJsonMap}
  }
}""";
    } else {
      return """
abstract class _\$${className}DynamoMixin implements DynamoProtocol<${className}> {
${fieldsDeclarations}

  Map<String, dynamic> asJsonSerializableMap(DynamoEncodingSupport ${encodingSupportVar}) {
    var ${jsonMapVar} = super.asJsonSerializableMap(${encodingSupportVar});
${assignToJsonMap}
    return ${jsonMapVar};
  }

  void fromJsonSerializableMap(Map<String, dynamic> ${jsonMapVar}, DynamoDecodingSupport ${decodingSupportVar}) {
    super.fromJsonSerializableMap(${jsonMapVar}, ${decodingSupportVar});
${assignFromJsonMap}
  }
}""";
    }
  }

  void _validateClassElement(Element element) {
    if (element is! ClassElement) {
      var friendlyName = friendlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the DynamoSerializable annotation from `$friendlyName`.');
    }
  }

  Map<String, FieldElement> _allFieldsNeedToBeAssigned(ClassElement classElement) {
    Map<String, FieldElement> fields = {};
    classElement.fields.forEach((element) {
      if (element.getter == null) {
        print("field ${element.displayName} has no getter - not serializable.");// TODO use log instead
        return;
      }
      if (element.setter == null) {
        print("field ${element.displayName} has no setter - not serializable.");// TODO use log instead
        return;
      }
      var entry = element.metadata.firstWhere((m) => matchAnnotation(DynamoEntry, m), orElse: () => null);
      if (entry == null) {
        entry = element.getter.metadata.firstWhere((m) => matchAnnotation(DynamoEntry, m), orElse: () => null);
      }
      DartObject ignoreValue = entry == null ? null : entry.constantValue.getField('ignore');
      bool accepted = ignoreValue == null || ignoreValue.isNull || !ignoreValue.toBoolValue();

      if (!accepted) {
        print("field ${element.displayName} marked as ignored.");// TODO use log instead
        return;
      }

      DartObject newName = entry == null ? null : entry.constantValue.getField('name');
      var jsonKey = newName == null || newName.isNull ? element.name : newName.toStringValue();
      fields[jsonKey] = element;
    });

    return fields;
  }
}