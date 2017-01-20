part of dynamo_example;

enum MemberType { adult, student, unemployed, pensioner, child, vip }

@DynamoSerializable()
class Member extends Object with _$MemberDynamoMixin {

  int id = 0;

  String firstName;

  @DynamoEntry(name: 'last_name')
  String lastName;

  DateTime registered;

  MemberType type;

  bool active;

  @DynamoEntry(ignore: true)
  bool ignoreMe;

  List<Tag> tags = [];

  Member();

  Member.withIdAndName(this.id, this.firstName, this.lastName) {}

  bool get isNew => id < 1;

}