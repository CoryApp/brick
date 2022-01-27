import 'package:analyzer/dart/element/element.dart';
import 'package:brick_build/generators.dart' show ProviderSerializableGenerator, SerdesGenerator;
import 'package:brick_graphql/graphql.dart';
import 'package:brick_graphql_generators/src/graphql_deserialize.dart';
import 'package:brick_graphql_generators/src/graphql_fields.dart';
import 'package:brick_graphql_generators/src/graphql_serialize.dart';
import 'package:source_gen/source_gen.dart';

/// Digest a `graphqlConfig` (`@ConnectOfflineFirstWithGraphQL`) from [reader] and manage serdes generators
/// to and from a `GraphqlProvider`.
class GraphqlModelSerdesGenerator extends ProviderSerializableGenerator<GraphqlSerializable> {
  /// Repository prefix passed to the generators. `Repository` will be appended and
  /// should not be included.
  final String repositoryName;

  GraphqlModelSerdesGenerator(
    Element element,
    ConstantReader reader, {
    required this.repositoryName,
  }) : super(element, reader, configKey: 'graphqlConfig');

  @override
  GraphqlSerializable get config {
    if (reader.peek(configKey) == null) {
      return GraphqlSerializable.defaults;
    }

    final fieldRenameObject = withinConfigKey('fieldRename')?.objectValue;
    final fieldRenameByEnumName = _firstWhereOrNull(
      FieldRename.values,
      (f) => fieldRenameObject?.getField(f.toString().split('.')[1]) != null,
    );

    return GraphqlSerializable(
      fieldRename: fieldRenameByEnumName ?? GraphqlSerializable.defaults.fieldRename,
      defaultDeleteOperation: withinConfigKey('defaultDeleteOperation')?.stringValue,
      defaultGetOperation: withinConfigKey('defaultGetOperation')?.stringValue,
      defaultGetFilteredOperation: withinConfigKey('defaultGetFilteredOperation')?.stringValue,
      defaultSubscriptionOperation: withinConfigKey('defaultSubscriptionOperation')?.stringValue,
      defaultSubscriptionFilteredOperation:
          withinConfigKey('defaultSubscriptionFilteredOperation')?.stringValue,
      defaultUpsertOperation: withinConfigKey('defaultUpsertOperation')?.stringValue,
    );
  }

  @override
  List<SerdesGenerator> get generators {
    final classElement = element as ClassElement;
    final fields = GraphqlFields(classElement, config);
    return [
      GraphqlDeserialize(classElement, fields, repositoryName: repositoryName),
      GraphqlSerialize(classElement, fields, repositoryName: repositoryName),
    ];
  }
}

// from dart:collections, instead of importing a whole package
T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
  for (var item in items) {
    if (test(item)) return item;
  }
  return null;
}
