[![](https://img.shields.io/badge/GitHub%20pages-deployed-blue)](https://fischerscode.github.io/crdVisualizer/)
# crdVisualizer

A tool for browsing complicated kubernetes CustomResourceDefinitions. 

## About

I've been sick of searching the deploy files of kubernetes CustomResourceDefinitions while creating CustomResources. As I could not find a GUI or visualization tool, I've decided to create my own.

## Getting Started

[Click here](https://fischerscode.github.io/crdVisualizer/) to give it a try.

Using it should be pretty simple. Just paste your yaml file in there and click "LOAD" at the bottom.
A new page should open and show you the most important information for creating a CustomResource. Inserting multiple yaml documents separated by `---` works, too.

## Limitations
- Currently only `apiextensions.k8s.io/v1` is supported.
- not implemented/shown: `additionalProperties` with `type: array`, `anyOf`, `x-kubernetes-int-or-string`, `required`, `served`, `storage`, `listKind`, `plural`, `singular`, `scope`