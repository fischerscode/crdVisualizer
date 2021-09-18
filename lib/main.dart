import 'dart:convert';

import 'package:crdvisualizer/crd.dart';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'crdVisualizer',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: YamlLoader(),
    );
  }
}

class YamlLoader extends StatefulWidget {
  @override
  _YamlLoaderState createState() => _YamlLoaderState();
}

class _YamlLoaderState extends State<YamlLoader> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  List<YamlDocument> _yaml = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("crdVisualizer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Paste the yaml here!",
                      labelText: "Your CRD",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (input) {
                      List<YamlDocument> list = loadYamlDocuments(input ?? "");
                      if (list.isEmpty)
                        return "You have to enter your CRD first.";
                      // if (list.any((element) => element.contents.span.))
                      //   return "This does not seem to be yaml.";
                      return null;
                    },
                    onSaved: (input) => _yaml = loadYamlDocuments(input ?? ""),
                  ),
                ),
              ),
              ElevatedButton(
                  focusNode: null,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CRDsViewer(yaml: _yaml),
                        ),
                      );
                    }
                  },
                  child: Text("LOAD"))
            ],
          ),
        ),
      ),
    );
  }
}

class CRDsViewer extends StatelessWidget {
  final List<YamlDocument> yaml;
  const CRDsViewer({
    Key? key,
    required this.yaml,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("crdVisualizer"),
      ),
      body: ListView(
        children: yaml
            .map(
              (document) => CRDViewer(
                document: document,
              ),
            )
            .toList(),
      ),
    );
  }
}

class CRDViewer extends StatelessWidget {
  final YamlDocument document;
  static const bool initiallyExpanded = true;
  const CRDViewer({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // jsonDecode(document.contents.value);
    CustomResourceDefinition? customResourceDefinition =
        CustomResourceDefinition.load(document);
    if (customResourceDefinition != null) {
      return Provider.value(
        value: InsertionCounter(0),
        child: InsertedExpansionTile(
          title: SelectableText(customResourceDefinition.kind),
          subtitle: SelectableText(customResourceDefinition.group),
          initiallyExpanded: initiallyExpanded,
          children: customResourceDefinition.versions
              .map(
                (version) => InsertedExpansionTile(
                  title: SelectableText(version.name),
                  initiallyExpanded: initiallyExpanded,
                  children: buildPropertyList(version.properties),
                ),
              )
              .toList(),
        ),
      );
    } else {
      return ListTile(title: Text("Failed to parse CRD"));
    }
    // jsonDecode(document.toString()).asString() ?? "test"));
    // jsonDecode(source)
  }

  Widget buildProperty(CustomResourceDefinitionProperty property) {
    switch (property.type) {
      case "object":
        return InsertedExpansionTile(
          initiallyExpanded: initiallyExpanded,
          title: SelectableText(property.name),
          subtitle: property.description != null
              ? SelectableText(property.description!)
              : null,
          children: buildPropertyList(
              (property as CustomResourceDefinitionObjectProperty).properties),
        );
      case "array":
        property = property as CustomResourceDefinitionArrayProperty;
        if (property is CustomResourceDefinitionObjectArrayProperty) {
          return InsertedExpansionTile(
            initiallyExpanded: initiallyExpanded,
            title: SelectableText(property.name),
            subtitle: property.description != null
                ? SelectableText(property.description!)
                : null,
            children: [buildProperty(property.itemsProperty)],
            trailing: Text("array"),
          );
        } else {
          return ListTile(
            title: SelectableText(property.name),
            subtitle: property.description != null
                ? SelectableText(property.description!)
                : null,
            trailing: Text("${property.itemsType}-${property.type}"),
          );
        }

      default:
        String type = property.type;
        if (property.format != null) type = "$type as ${property.format}";
        if (property is CustomResourceDefinitionEnumProperty) {
          return InsertedExpansionTile(
            initiallyExpanded: initiallyExpanded,
            title: SelectableText(property.name),
            subtitle: property.description != null
                ? SelectableText(property.description!)
                : null,
            trailing: Text("$type - enum"),
            children: property.enums
                .map(
                  (e) => Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText("- $e"),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )
                .toList(),
          );
        } else {
          return ListTile(
            title: SelectableText(property.name),
            subtitle: property.description != null
                ? SelectableText(property.description!)
                : null,
            trailing: Text(type),
          );
        }
    }
  }

  List<Widget> buildPropertyList(
      List<CustomResourceDefinitionProperty> properties) {
    return properties.map(buildProperty).toList();
  }
}

class InsertedExpansionTile extends StatelessWidget {
  const InsertedExpansionTile({
    Key? key,
    required this.title,
    this.initiallyExpanded = false,
    this.subtitle,
    this.children = const [],
    this.trailing,
  }) : super(key: key);

  static const List<Color> colors = [Colors.blue, Colors.red];

  final Widget title;
  final bool initiallyExpanded;
  final Widget? subtitle;
  final List<Widget> children;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    int insertCount =
        Provider.of<InsertionCounter>(context, listen: false).count;
    return Provider.value(
      value: InsertionCounter(insertCount + 1),
      child: ExpansionTile(
        title: title,
        initiallyExpanded: initiallyExpanded && children.isNotEmpty,
        subtitle: subtitle,
        trailing: trailing,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colors[insertCount % colors.length],
              ),
            ),
            width: double.infinity,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 20),
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 1),
                child: Column(
                  children: children,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InsertionCounter {
  final int count;

  const InsertionCounter(this.count);
}
