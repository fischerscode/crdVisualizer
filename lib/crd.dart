import 'package:yaml/yaml.dart';

class CustomResourceDefinition {
  final String group;
  final String kind;
  final String? scope;
  final List<CustomResourceDefinitionVersion> versions;

  CustomResourceDefinition({
    required this.group,
    required this.kind,
    this.scope,
    required this.versions,
  });

  static CustomResourceDefinition? load(YamlDocument definition) {
    if (definition.contents.asMap()?.get("apiVersion")?.asString() ==
            "apiextensions.k8s.io/v1" &&
        definition.contents.getMapValue("kind")?.asString() ==
            "CustomResourceDefinition") {
      return _loadv1(definition);
    }
  }

  static CustomResourceDefinition? _loadv1(YamlDocument definition) {
    String? group = definition.contents
        .getMapValue("spec")
        ?.getMapValue("group")
        ?.asString();
    String? kind = definition.contents
        .getMapValue("spec")
        ?.getMapValue("names")
        ?.getMapValue("kind")
        ?.asString();
    String? scope = definition.contents
        .getMapValue("spec")
        ?.getMapValue("scope")
        ?.asString();
    if (group == null || kind == null) return null;
    List<CustomResourceDefinitionVersion> versions = definition.contents
            .getMapValue("spec")
            ?.getMapValue("versions")
            ?.asList()
            ?.nodes
            .map((e) => CustomResourceDefinitionVersion.load(e))
            .where((element) => element != null)
            .map((e) => e!)
            .toList() ??
        [];
    return CustomResourceDefinition(
        group: group, kind: kind, versions: versions, scope: scope);
  }
}

class CustomResourceDefinitionVersion {
  final String name;
  final List<CustomResourceDefinitionProperty> properties;

  CustomResourceDefinitionVersion(this.name, this.properties);

  static CustomResourceDefinitionVersion? load(YamlNode definition) {
    String? name = definition.getMapValue("name")?.asString();
    if (name == null) return null;

    List<CustomResourceDefinitionProperty> properties = (definition
                    .getMapValue("schema")
                    ?.getMapValue("openAPIV3Schema")
                    ?.getMapValue("properties") ??
                definition
                    .getMapValue("schema")
                    ?.getMapValue("openAPIV3Schema")
                    ?.getMapValue("additionalProperties"))
            ?.asMap()
            ?.asPropertyList() ??
        [];
    return CustomResourceDefinitionVersion(name, properties);
  }
}

class CustomResourceDefinitionProperty {
  final String name;
  final String type;
  final String? description;
  final String? format;

  CustomResourceDefinitionProperty({
    required this.name,
    required this.type,
    this.description,
    this.format,
  });

  static List<String>? _readEnum(YamlNode? node) {
    return node
        ?.asList()
        ?.nodes
        .map((element) => element.asString())
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  }

  static CustomResourceDefinitionProperty? load(
      String name, YamlNode? definition) {
    if (definition == null) return null;

    String? type = definition.getMapValue("type")?.asString();
    if (type == null) return null;
    String? description = definition.getMapValue("description")?.asString();
    String? format = definition.getMapValue("format")?.asString();
    List<String>? enums = _readEnum(definition.getMapValue("enum"));

    switch (type.toLowerCase()) {
      case "array":
        String? itemsType =
            definition.getMapValue("items")?.getMapValue("type")?.asString();
        String? itemsDescription = definition
            .getMapValue("items")
            ?.getMapValue("description")
            ?.asString();
        if (itemsType == null) return null;
        if (itemsType.toLowerCase() == "object") {
          return CustomResourceDefinitionObjectArrayProperty(
            name: name,
            description: description,
            itemsProperty: CustomResourceDefinitionObjectProperty(
                name: "",
                description: itemsDescription,
                properties: (definition
                                .getMapValue("items")
                                ?.getMapValue("properties") ??
                            definition
                                .getMapValue("items")
                                ?.getMapValue("additionalProperties"))
                        ?.asMap()
                        ?.asPropertyList() ??
                    []),
          );
        }
        List<String>? enums =
            _readEnum(definition.getMapValue("items")?.getMapValue("enum"));
        print(enums);
        if (enums != null) {
          return CustomResourceDefinitionEnumArrayProperty(
            name: name,
            itemsType: itemsType,
            description: "${description ?? ""}\n\n${itemsDescription ?? ""}",
            enums: enums,
          );
        }
        return CustomResourceDefinitionArrayProperty(
            name: name,
            type: type,
            itemsType: itemsType,
            description: description);
      case "object":
        return CustomResourceDefinitionObjectProperty(
            name: name,
            description: description,
            properties: (definition.getMapValue("properties") ??
                        definition.getMapValue("additionalProperties"))
                    ?.asMap()
                    ?.asPropertyList() ??
                []);
      default:
        if (enums != null) {
          return CustomResourceDefinitionEnumProperty(
              name: name, type: type, description: description, enums: enums);
        }
        return CustomResourceDefinitionProperty(
            name: name, type: type, description: description, format: format);
    }
  }
}

class CustomResourceDefinitionEnumProperty
    extends CustomResourceDefinitionProperty {
  CustomResourceDefinitionEnumProperty({
    required final String name,
    final String? description,
    required final String type,
    required this.enums,
  }) : super(
          name: name,
          description: description,
          type: type,
        );
  final List<String> enums;
}

class CustomResourceDefinitionObjectProperty
    extends CustomResourceDefinitionProperty {
  List<CustomResourceDefinitionProperty> properties;

  CustomResourceDefinitionObjectProperty({
    required final String name,
    final String? description,
    required this.properties,
  }) : super(
          name: name,
          type: "object",
          description: description,
        );
}

class CustomResourceDefinitionArrayProperty
    extends CustomResourceDefinitionProperty {
  String itemsType;
  CustomResourceDefinitionArrayProperty({
    required final String name,
    required final String type,
    final String? description,
    required this.itemsType,
  }) : super(
          name: name,
          type: type,
          description: description,
        );
}

class CustomResourceDefinitionEnumArrayProperty
    extends CustomResourceDefinitionArrayProperty
    implements CustomResourceDefinitionEnumProperty {
  final List<String> enums;
  CustomResourceDefinitionEnumArrayProperty({
    required final String name,
    final String? description,
    required String itemsType,
    required this.enums,
  }) : super(
          name: name,
          type: "enum-array",
          description: description,
          itemsType: itemsType,
        );
}

class CustomResourceDefinitionObjectArrayProperty
    extends CustomResourceDefinitionArrayProperty {
  final CustomResourceDefinitionProperty itemsProperty;
  CustomResourceDefinitionObjectArrayProperty({
    required final String name,
    final String? description,
    required this.itemsProperty,
  }) : super(
          name: name,
          type: "array",
          description: description,
          itemsType: "object",
        );
}

extension on YamlNode {
  YamlMap? asMap() {
    if (this is YamlMap) return this as YamlMap;
    return null;
  }

  YamlList? asList() {
    if (this is YamlList) return this as YamlList;
    return null;
  }

  YamlScalar? asScalar() {
    if (this is YamlScalar) return this as YamlScalar;
    return null;
  }

  String? asString() {
    return asScalar()?.toString();
  }

  YamlNode? getMapValue(String key) {
    String test = "";
    return asMap()?.get(key);
  }
}

extension on YamlMap {
  YamlNode? get(String key) {
    if (this[key] is YamlNode) return this[key] as YamlNode;
    if (this[key] is String) return YamlScalar.wrap(this[key]);
    return null;
  }

  List<CustomResourceDefinitionProperty> asPropertyList() {
    List<CustomResourceDefinitionProperty> list = [];
    for (String key in keys) {
      CustomResourceDefinitionProperty? property =
          CustomResourceDefinitionProperty.load(key, get(key));
      if (property != null) {
        list.add(property);
      }
    }
    return list;
  }
}
