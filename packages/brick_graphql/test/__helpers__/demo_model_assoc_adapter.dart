import 'package:brick_graphql/src/runtime_graphql_definition.dart';

import 'demo_model.dart';
// ignore: unused_import, unused_shown_name
import 'package:brick_graphql/graphql.dart';

Future<DemoModelAssoc> _$DemoModelAssocFromGraphql(Map<String, dynamic> data,
    {GraphqlProvider? provider, repository}) async {
  return DemoModelAssoc(name: data['full_name'] == null ? null : data['full_name'] as String);
}

Future<Map<String, dynamic>> _$DemoModelAssocToGraphql(DemoModelAssoc instance,
    {GraphqlProvider? provider, repository}) async {
  return {'full_name': instance.name};
}

/// Construct a [DemoModelAssoc]
class DemoModelAssocAdapter extends GraphqlAdapter<DemoModelAssoc> {
  DemoModelAssocAdapter();

  @override
  final Map<String, RuntimeGraphqlDefinition> fieldsToRuntimeDefinition = {
    'primaryKey': const RuntimeGraphqlDefinition(
      association: false,
      documentNodeName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'name': const RuntimeGraphqlDefinition(
      association: false,
      documentNodeName: 'full_name',
      iterable: false,
      type: String,
    ),
  };

  @override
  Future<DemoModelAssoc> fromGraphql(Map<String, dynamic> input,
          {required provider, repository}) async =>
      await _$DemoModelAssocFromGraphql(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toGraphql(DemoModelAssoc input,
          {required provider, repository}) async =>
      await _$DemoModelAssocToGraphql(input, provider: provider, repository: repository);
}