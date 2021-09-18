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
//       home: CRDsViewer(
//         yaml: loadYamlDocuments("""apiVersion: apiextensions.k8s.io/v1
// kind: CustomResourceDefinition
// metadata:
//   name: keycloakclients.keycloak.org
// spec:
//   group: keycloak.org
//   names:
//     kind: KeycloakClient
//     listKind: KeycloakClientList
//     plural: keycloakclients
//     singular: keycloakclient
//   scope: Namespaced
//   versions:
//   - name: v1alpha1
//     schema:
//       openAPIV3Schema:
//         description: KeycloakClient is the Schema for the keycloakclients API.
//         properties:
//           apiVersion:
//             description: 'APIVersion defines the versioned schema of this representation
//               of an object. Servers should convert recognized schemas to the latest
//               internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources'
//             type: string
//           kind:
//             description: 'Kind is a string value representing the REST resource this
//               object represents. Servers may infer this from the endpoint the client
//               submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds'
//             type: string
//           metadata:
//             type: object
//           spec:
//             description: KeycloakClientSpec defines the desired state of KeycloakClient.
//             properties:
//               client:
//                 description: Keycloak Client REST object.
//                 properties:
//                   access:
//                     additionalProperties:
//                       type: boolean
//                     description: Access options.
//                     type: object
//                   adminUrl:
//                     description: Application Admin URL.
//                     type: string
//                   attributes:
//                     additionalProperties:
//                       type: string
//                     description: Client Attributes.
//                     type: object
//                   authorizationServicesEnabled:
//                     description: True if fine-grained authorization support is enabled
//                       for this client.
//                     type: boolean
//                   authorizationSettings:
//                     description: Authorization settings for this resource server.
//                     properties:
//                       allowRemoteResourceManagement:
//                         description: True if resources should be managed remotely
//                           by the resource server.
//                         type: boolean
//                       clientId:
//                         description: Client ID.
//                         type: string
//                       decisionStrategy:
//                         description: The decision strategy dictates how permissions
//                           are evaluated and how a final decision is obtained. 'Affirmative'
//                           means that at least one permission must evaluate to a positive
//                           decision in order to grant access to a resource and its
//                           scopes. 'Unanimous' means that all permissions must evaluate
//                           to a positive decision in order for the final decision to
//                           be also positive.
//                         type: string
//                       id:
//                         description: ID.
//                         type: string
//                       name:
//                         description: Name.
//                         type: string
//                       policies:
//                         description: Policies.
//                         items:
//                           description: https://www.keycloak.org/docs-api/12.0/rest-api/index.html#_policyrepresentation
//                           properties:
//                             config:
//                               additionalProperties:
//                                 type: string
//                               description: Config.
//                               type: object
//                             decisionStrategy:
//                               description: The decision strategy dictates how the
//                                 policies associated with a given permission are evaluated
//                                 and how a final decision is obtained. 'Affirmative'
//                                 means that at least one policy must evaluate to a
//                                 positive decision in order for the final decision
//                                 to be also positive. 'Unanimous' means that all policies
//                                 must evaluate to a positive decision in order for
//                                 the final decision to be also positive. 'Consensus'
//                                 means that the number of positive decisions must be
//                                 greater than the number of negative decisions. If
//                                 the number of positive and negative is the same, the
//                                 final decision will be negative.
//                               type: string
//                             description:
//                               description: A description for this policy.
//                               type: string
//                             id:
//                               description: ID.
//                               type: string
//                             logic:
//                               description: The logic dictates how the policy decision
//                                 should be made. If 'Positive', the resulting effect
//                                 (permit or deny) obtained during the evaluation of
//                                 this policy will be used to perform a decision. If
//                                 'Negative', the resulting effect will be negated,
//                                 in other words, a permit becomes a deny and vice-versa.
//                               type: string
//                             name:
//                               description: The name of this policy.
//                               type: string
//                             owner:
//                               description: Owner.
//                               type: string
//                             policies:
//                               description: Policies.
//                               items:
//                                 type: string
//                               type: array
//                             resources:
//                               description: Resources.
//                               items:
//                                 type: string
//                               type: array
//                             resourcesData:
//                               description: Resources Data.
//                               items:
//                                 description: https://www.keycloak.org/docs-api/12.0/rest-api/index.html#_resourcerepresentation
//                                 properties:
//                                   _id:
//                                     description: ID.
//                                     type: string
//                                   attributes:
//                                     additionalProperties:
//                                       type: string
//                                     description: The attributes associated with the
//                                       resource.
//                                     type: object
//                                   displayName:
//                                     description: A unique name for this resource.
//                                       The name can be used to uniquely identify a
//                                       resource, useful when querying for a specific
//                                       resource.
//                                     type: string
//                                   icon_uri:
//                                     description: An URI pointing to an icon.
//                                     type: string
//                                   name:
//                                     description: A unique name for this resource.
//                                       The name can be used to uniquely identify a
//                                       resource, useful when querying for a specific
//                                       resource.
//                                     type: string
//                                   ownerManagedAccess:
//                                     description: True if the access to this resource
//                                       can be managed by the resource owner.
//                                     type: boolean
//                                   scopes:
//                                     description: The scopes associated with this resource.
//                                     items:
//                                       x-kubernetes-preserve-unknown-fields: true
//                                     type: array
//                                   type:
//                                     description: The type of this resource. It can
//                                       be used to group different resource instances
//                                       with the same type.
//                                     type: string
//                                   uris:
//                                     description: Set of URIs which are protected by
//                                       resource.
//                                     items:
//                                       type: string
//                                     type: array
//                                 type: object
//                               type: array
//                             scopes:
//                               description: Scopes.
//                               items:
//                                 type: string
//                               type: array
//                             scopesData:
//                               description: Scopes Data.
//                               items:
//                                 x-kubernetes-preserve-unknown-fields: true
//                               type: array
//                             type:
//                               description: Type.
//                               type: string
//                           type: object
//                         type: array
//                       policyEnforcementMode:
//                         description: The policy enforcement mode dictates how policies
//                           are enforced when evaluating authorization requests. 'Enforcing'
//                           means requests are denied by default even when there is
//                           no policy associated with a given resource. 'Permissive'
//                           means requests are allowed even when there is no policy
//                           associated with a given resource. 'Disabled' completely
//                           disables the evaluation of policies and allows access to
//                           any resource.
//                         type: string
//                       resources:
//                         description: Resources.
//                         items:
//                           description: https://www.keycloak.org/docs-api/12.0/rest-api/index.html#_resourcerepresentation
//                           properties:
//                             _id:
//                               description: ID.
//                               type: string
//                             attributes:
//                               additionalProperties:
//                                 type: string
//                               description: The attributes associated with the resource.
//                               type: object
//                             displayName:
//                               description: A unique name for this resource. The name
//                                 can be used to uniquely identify a resource, useful
//                                 when querying for a specific resource.
//                               type: string
//                             icon_uri:
//                               description: An URI pointing to an icon.
//                               type: string
//                             name:
//                               description: A unique name for this resource. The name
//                                 can be used to uniquely identify a resource, useful
//                                 when querying for a specific resource.
//                               type: string
//                             ownerManagedAccess:
//                               description: True if the access to this resource can
//                                 be managed by the resource owner.
//                               type: boolean
//                             scopes:
//                               description: The scopes associated with this resource.
//                               items:
//                                 x-kubernetes-preserve-unknown-fields: true
//                               type: array
//                             type:
//                               description: The type of this resource. It can be used
//                                 to group different resource instances with the same
//                                 type.
//                               type: string
//                             uris:
//                               description: Set of URIs which are protected by resource.
//                               items:
//                                 type: string
//                               type: array
//                           type: object
//                         type: array
//                       scopes:
//                         description: Authorization Scopes.
//                         items:
//                           description: https://www.keycloak.org/docs-api/12.0/rest-api/index.html#_scoperepresentation
//                           properties:
//                             displayName:
//                               description: A unique name for this scope. The name
//                                 can be used to uniquely identify a scope, useful when
//                                 querying for a specific scope.
//                               type: string
//                             iconUri:
//                               description: An URI pointing to an icon.
//                               type: string
//                             id:
//                               description: ID.
//                               type: string
//                             name:
//                               description: A unique name for this scope. The name
//                                 can be used to uniquely identify a scope, useful when
//                                 querying for a specific scope.
//                               type: string
//                             policies:
//                               description: Policies.
//                               items:
//                                 description: https://www.keycloak.org/docs-api/12.0/rest-api/index.html#_policyrepresentation
//                                 properties:
//                                   config:
//                                     additionalProperties:
//                                       type: string
//                                     description: Config.
//                                     type: object
//                                   decisionStrategy:
//                                     description: The decision strategy dictates how
//                                       the policies associated with a given permission
//                                       are evaluated and how a final decision is obtained.
//                                       'Affirmative' means that at least one policy
//                                       must evaluate to a positive decision in order
//                                       for the final decision to be also positive.
//                                       'Unanimous' means that all policies must evaluate
//                                       to a positive decision in order for the final
//                                       decision to be also positive. 'Consensus' means
//                                       that the number of positive decisions must be
//                                       greater than the number of negative decisions.
//                                       If the number of positive and negative is the
//                                       same, the final decision will be negative.
//                                     type: string
//                                   description:
//                                     description: A description for this policy.
//                                     type: string
//                                   id:
//                                     description: ID.
//                                     type: string
//                                   logic:
//                                     description: The logic dictates how the policy
//                                       decision should be made. If 'Positive', the
//                                       resulting effect (permit or deny) obtained during
//                                       the evaluation of this policy will be used to
//                                       perform a decision. If 'Negative', the resulting
//                                       effect will be negated, in other words, a permit
//                                       becomes a deny and vice-versa.
//                                     type: string
//                                   name:
//                                     description: The name of this policy.
//                                     type: string
//                                   owner:
//                                     description: Owner.
//                                     type: string
//                                   policies:
//                                     description: Policies.
//                                     items:
//                                       type: string
//                                     type: array
//                                   resources:
//                                     description: Resources.
//                                     items:
//                                       type: string
//                                     type: array
//                                   resourcesData:
//                                     description: Resources Data.
//                                     items:
//                                       description: https://www.keycloak.org/docs-api/12.0/rest-api/index.html#_resourcerepresentation
//                                       properties:
//                                         _id:
//                                           description: ID.
//                                           type: string
//                                         attributes:
//                                           additionalProperties:
//                                             type: string
//                                           description: The attributes associated with
//                                             the resource.
//                                           type: object
//                                         displayName:
//                                           description: A unique name for this resource.
//                                             The name can be used to uniquely identify
//                                             a resource, useful when querying for a
//                                             specific resource.
//                                           type: string
//                                         icon_uri:
//                                           description: An URI pointing to an icon.
//                                           type: string
//                                         name:
//                                           description: A unique name for this resource.
//                                             The name can be used to uniquely identify
//                                             a resource, useful when querying for a
//                                             specific resource.
//                                           type: string
//                                         ownerManagedAccess:
//                                           description: True if the access to this
//                                             resource can be managed by the resource
//                                             owner.
//                                           type: boolean
//                                         scopes:
//                                           description: The scopes associated with
//                                             this resource.
//                                           items:
//                                             x-kubernetes-preserve-unknown-fields: true
//                                           type: array
//                                         type:
//                                           description: The type of this resource.
//                                             It can be used to group different resource
//                                             instances with the same type.
//                                           type: string
//                                         uris:
//                                           description: Set of URIs which are protected
//                                             by resource.
//                                           items:
//                                             type: string
//                                           type: array
//                                       type: object
//                                     type: array
//                                   scopes:
//                                     description: Scopes.
//                                     items:
//                                       type: string
//                                     type: array
//                                   scopesData:
//                                     description: Scopes Data.
//                                     items:
//                                       x-kubernetes-preserve-unknown-fields: true
//                                     type: array
//                                   type:
//                                     description: Type.
//                                     type: string
//                                 type: object
//                               type: array
//                             resources:
//                               description: Resources.
//                               items:
//                                 description: https://www.keycloak.org/docs-api/12.0/rest-api/index.html#_resourcerepresentation
//                                 properties:
//                                   _id:
//                                     description: ID.
//                                     type: string
//                                   attributes:
//                                     additionalProperties:
//                                       type: string
//                                     description: The attributes associated with the
//                                       resource.
//                                     type: object
//                                   displayName:
//                                     description: A unique name for this resource.
//                                       The name can be used to uniquely identify a
//                                       resource, useful when querying for a specific
//                                       resource.
//                                     type: string
//                                   icon_uri:
//                                     description: An URI pointing to an icon.
//                                     type: string
//                                   name:
//                                     description: A unique name for this resource.
//                                       The name can be used to uniquely identify a
//                                       resource, useful when querying for a specific
//                                       resource.
//                                     type: string
//                                   ownerManagedAccess:
//                                     description: True if the access to this resource
//                                       can be managed by the resource owner.
//                                     type: boolean
//                                   scopes:
//                                     description: The scopes associated with this resource.
//                                     items:
//                                       x-kubernetes-preserve-unknown-fields: true
//                                     type: array
//                                   type:
//                                     description: The type of this resource. It can
//                                       be used to group different resource instances
//                                       with the same type.
//                                     type: string
//                                   uris:
//                                     description: Set of URIs which are protected by
//                                       resource.
//                                     items:
//                                       type: string
//                                     type: array
//                                 type: object
//                               type: array
//                           type: object
//                         type: array
//                     type: object
//                   baseUrl:
//                     description: Application base URL.
//                     type: string
//                   bearerOnly:
//                     description: True if a client supports only Bearer Tokens.
//                     type: boolean
//                   clientAuthenticatorType:
//                     description: What Client authentication type to use.
//                     type: string
//                   clientId:
//                     description: Client ID.
//                     type: string
//                   consentRequired:
//                     description: True if Consent Screen is required.
//                     type: boolean
//                   defaultClientScopes:
//                     description: A list of default client scopes. Default client scopes
//                       are always applied when issuing OpenID Connect tokens or SAML
//                       assertions for this client.
//                     items:
//                       type: string
//                     type: array
//                   defaultRoles:
//                     description: Default Client roles.
//                     items:
//                       type: string
//                     type: array
//                   description:
//                     description: Client description.
//                     type: string
//                   directAccessGrantsEnabled:
//                     description: True if Direct Grant is enabled.
//                     type: boolean
//                   enabled:
//                     description: Client enabled flag.
//                     type: boolean
//                   frontchannelLogout:
//                     description: True if this client supports Front Channel logout.
//                     type: boolean
//                   fullScopeAllowed:
//                     description: True if Full Scope is allowed.
//                     type: boolean
//                   id:
//                     description: Client ID. If not specified, automatically generated.
//                     type: string
//                   implicitFlowEnabled:
//                     description: True if Implicit flow is enabled.
//                     type: boolean
//                   name:
//                     description: Client name.
//                     type: string
//                   nodeReRegistrationTimeout:
//                     description: Node registration timeout.
//                     type: integer
//                   notBefore:
//                     description: Not Before setting.
//                     type: integer
//                   optionalClientScopes:
//                     description: A list of optional client scopes. Optional client
//                       scopes are applied when issuing tokens for this client, but
//                       only when they are requested by the scope parameter in the OpenID
//                       Connect authorization request.
//                     items:
//                       type: string
//                     type: array
//                   protocol:
//                     description: Protocol used for this Client.
//                     type: string
//                   protocolMappers:
//                     description: Protocol Mappers.
//                     items:
//                       properties:
//                         config:
//                           additionalProperties:
//                             type: string
//                           description: Config options.
//                           type: object
//                         consentRequired:
//                           description: True if Consent Screen is required.
//                           type: boolean
//                         consentText:
//                           description: Text to use for displaying Consent Screen.
//                           type: string
//                         id:
//                           description: Protocol Mapper ID.
//                           type: string
//                         name:
//                           description: Protocol Mapper Name.
//                           type: string
//                         protocol:
//                           description: Protocol to use.
//                           type: string
//                         protocolMapper:
//                           description: Protocol Mapper to use
//                           type: string
//                       type: object
//                     type: array
//                   publicClient:
//                     description: True if this is a public Client.
//                     type: boolean
//                   redirectUris:
//                     description: A list of valid Redirection URLs.
//                     items:
//                       type: string
//                     type: array
//                   rootUrl:
//                     description: Application root URL.
//                     type: string
//                   secret:
//                     description: Client Secret. The Operator will automatically create
//                       a Secret based on this value.
//                     type: string
//                   serviceAccountsEnabled:
//                     description: True if Service Accounts are enabled.
//                     type: boolean
//                   standardFlowEnabled:
//                     description: True if Standard flow is enabled.
//                     type: boolean
//                   surrogateAuthRequired:
//                     description: Surrogate Authentication Required option.
//                     type: boolean
//                   useTemplateConfig:
//                     description: True to use a Template Config.
//                     type: boolean
//                   useTemplateMappers:
//                     description: True to use Template Mappers.
//                     type: boolean
//                   useTemplateScope:
//                     description: True to use Template Scope.
//                     type: boolean
//                   webOrigins:
//                     description: A list of valid Web Origins.
//                     items:
//                       type: string
//                     type: array
//                 required:
//                 - clientId
//                 type: object
//               realmSelector:
//                 description: Selector for looking up KeycloakRealm Custom Resources.
//                 properties:
//                   matchExpressions:
//                     description: matchExpressions is a list of label selector requirements.
//                       The requirements are ANDed.
//                     items:
//                       description: A label selector requirement is a selector that
//                         contains values, a key, and an operator that relates the key
//                         and values.
//                       properties:
//                         key:
//                           description: key is the label key that the selector applies
//                             to.
//                           type: string
//                         operator:
//                           description: operator represents a key's relationship to
//                             a set of values. Valid operators are In, NotIn, Exists
//                             and DoesNotExist.
//                           type: string
//                         values:
//                           description: values is an array of string values. If the
//                             operator is In or NotIn, the values array must be non-empty.
//                             If the operator is Exists or DoesNotExist, the values
//                             array must be empty. This array is replaced during a strategic
//                             merge patch.
//                           items:
//                             type: string
//                           type: array
//                       required:
//                       - key
//                       - operator
//                       type: object
//                     type: array
//                   matchLabels:
//                     additionalProperties:
//                       type: string
//                     description: matchLabels is a map of {key,value} pairs. A single
//                       {key,value} in the matchLabels map is equivalent to an element
//                       of matchExpressions, whose key field is "key", the operator
//                       is "In", and the values array contains only "value". The requirements
//                       are ANDed.
//                     type: object
//                 type: object
//               roles:
//                 description: Client Roles
//                 items:
//                   description: https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_rolerepresentation
//                   properties:
//                     attributes:
//                       additionalProperties:
//                         items:
//                           type: string
//                         type: array
//                       description: Role Attributes
//                       type: object
//                     clientRole:
//                       description: Client Role
//                       type: boolean
//                     composite:
//                       description: Composite
//                       type: boolean
//                     composites:
//                       description: Composites
//                       properties:
//                         client:
//                           additionalProperties:
//                             items:
//                               type: string
//                             type: array
//                           description: Map client => []role
//                           type: object
//                         realm:
//                           description: Realm roles
//                           items:
//                             type: string
//                           type: array
//                       type: object
//                     containerId:
//                       description: Container Id
//                       type: string
//                     description:
//                       description: Description
//                       type: string
//                     id:
//                       description: Id
//                       type: string
//                     name:
//                       description: Name
//                       type: string
//                   required:
//                   - name
//                   type: object
//                 type: array
//                 x-kubernetes-list-map-keys:
//                 - name
//                 x-kubernetes-list-type: map
//               scopeMappings:
//                 description: Scope Mappings
//                 properties:
//                   clientMappings:
//                     additionalProperties:
//                       description: https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_clientmappingsrepresentation
//                       properties:
//                         client:
//                           description: Client
//                           type: string
//                         id:
//                           description: ID
//                           type: string
//                         mappings:
//                           description: Mappings
//                           items:
//                             description: https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_rolerepresentation
//                             properties:
//                               attributes:
//                                 additionalProperties:
//                                   items:
//                                     type: string
//                                   type: array
//                                 description: Role Attributes
//                                 type: object
//                               clientRole:
//                                 description: Client Role
//                                 type: boolean
//                               composite:
//                                 description: Composite
//                                 type: boolean
//                               composites:
//                                 description: Composites
//                                 properties:
//                                   client:
//                                     additionalProperties:
//                                       items:
//                                         type: string
//                                       type: array
//                                     description: Map client => []role
//                                     type: object
//                                   realm:
//                                     description: Realm roles
//                                     items:
//                                       type: string
//                                     type: array
//                                 type: object
//                               containerId:
//                                 description: Container Id
//                                 type: string
//                               description:
//                                 description: Description
//                                 type: string
//                               id:
//                                 description: Id
//                                 type: string
//                               name:
//                                 description: Name
//                                 type: string
//                             required:
//                             - name
//                             type: object
//                           type: array
//                       type: object
//                     description: Client Mappings
//                     type: object
//                   realmMappings:
//                     description: Realm Mappings
//                     items:
//                       description: https://www.keycloak.org/docs-api/11.0/rest-api/index.html#_rolerepresentation
//                       properties:
//                         attributes:
//                           additionalProperties:
//                             items:
//                               type: string
//                             type: array
//                           description: Role Attributes
//                           type: object
//                         clientRole:
//                           description: Client Role
//                           type: boolean
//                         composite:
//                           description: Composite
//                           type: boolean
//                         composites:
//                           description: Composites
//                           properties:
//                             client:
//                               additionalProperties:
//                                 items:
//                                   type: string
//                                 type: array
//                               description: Map client => []role
//                               type: object
//                             realm:
//                               description: Realm roles
//                               items:
//                                 type: string
//                               type: array
//                           type: object
//                         containerId:
//                           description: Container Id
//                           type: string
//                         description:
//                           description: Description
//                           type: string
//                         id:
//                           description: Id
//                           type: string
//                         name:
//                           description: Name
//                           type: string
//                       required:
//                       - name
//                       type: object
//                     type: array
//                 type: object
//             required:
//             - client
//             - realmSelector
//             type: object
//           status:
//             description: KeycloakClientStatus defines the observed state of KeycloakClient
//             properties:
//               message:
//                 description: Human-readable message indicating details about current
//                   operator phase or error.
//                 type: string
//               phase:
//                 description: Current phase of the operator.
//                 type: string
//               ready:
//                 description: True if all resources are in a ready state and all work
//                   is done.
//                 type: boolean
//               secondaryResources:
//                 additionalProperties:
//                   items:
//                     type: string
//                   type: array
//                 description: 'A map of all the secondary resources types and names
//                   created for this CR. e.g "Deployment": [ "DeploymentName1", "DeploymentName2"
//                   ]'
//                 type: object
//             required:
//             - message
//             - phase
//             - ready
//             type: object
//         type: object
//     served: true
//     storage: true
//     subresources:
//       status: {}
// """),
//       ),
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
          title: Text(customResourceDefinition.kind),
          subtitle: Text(customResourceDefinition.group),
          initiallyExpanded: initiallyExpanded,
          children: customResourceDefinition.versions
              .map(
                (version) => InsertedExpansionTile(
                  title: Text(version.name),
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
          title: Text(property.name),
          subtitle:
              property.description != null ? Text(property.description!) : null,
          children: buildPropertyList(
              (property as CustomResourceDefinitionObjectProperty).properties),
        );
      case "array":
        property = property as CustomResourceDefinitionArrayProperty;
        if (property is CustomResourceDefinitionObjectArrayProperty) {
          return InsertedExpansionTile(
            initiallyExpanded: initiallyExpanded,
            title: Text(property.name),
            subtitle: property.description != null
                ? Text(property.description!)
                : null,
            children: [buildProperty(property.itemsProperty)],
            trailing: Text("array"),
          );
        } else {
          return ListTile(
            title: Text(property.name),
            subtitle: property.description != null
                ? Text(property.description!)
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
            title: Text(property.name),
            subtitle: property.description != null
                ? Text(property.description!)
                : null,
            trailing: Text("$type - enum"),
            children: property.enums
                .map(
                  (e) => Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("- $e"),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )
                .toList(),
          );
        } else {
          return ListTile(
            title: Text(property.name),
            subtitle: property.description != null
                ? Text(property.description!)
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
