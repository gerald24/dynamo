part of dynamo_example;

@DynamoSerializable()
class Tag extends Object with _$TagDynamoMixin {
  int id = 0;
  String name;

  Tag();
  Tag.withIdAndName(this.id, this.name);
}