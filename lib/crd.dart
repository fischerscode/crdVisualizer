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

  CustomResourceDefinitionProperty(
      {required this.name, required this.type, this.description});

  static CustomResourceDefinitionProperty? load(
      String name, YamlNode? definition) {
    if (definition == null) return null;

    String? type = definition.getMapValue("type")?.asString();
    if (type == null) return null;
    String? description = definition.getMapValue("description")?.asString();

    switch (type.toLowerCase()) {
      case "array":
        String? itemsType =
            definition.getMapValue("items")?.getMapValue("type")?.asString();
        if (itemsType == null) return null;
        if (itemsType.toLowerCase() == "object") {
          return CustomResourceDefinitionObjectArrayProperty(
            name: name,
            description: description,
            itemsProperty: CustomResourceDefinitionObjectProperty(
                name: "",
                description: definition
                    .getMapValue("items")
                    ?.getMapValue("description")
                    ?.asString(),
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
        return CustomResourceDefinitionArrayProperty(
            name: name, type: type, itemsType: itemsType);
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
        return CustomResourceDefinitionProperty(
            name: name, type: type, description: description);
    }
  }
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
