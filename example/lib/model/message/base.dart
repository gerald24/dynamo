part of dynamo_example;

@DynamoSerializable()
abstract class Message extends Object with _$MessageDynamoMixin {
  int id = 0;

}
