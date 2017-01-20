library dynamo_example.test.serialization;

import 'dart:convert';
import 'package:dynamo/dynamo.dart';
import 'package:test/test.dart';
import 'package:dynamo_example/dynamo_example.dart';

void main() {
  test("simple model", (){
    final json = '{"_isa_":"member","id":1,"firstName":"Gerald","last_name":"Leeb","registered":"2017-01-30T00:00:00.000Z","active":true,"tags":[{"_isa_":"tag","id":1,"name":"Dart"},{"_isa_":"tag","id":2,"name":"Java"}]}';
    Tag t1 = new Tag.withIdAndName(1, "Dart");
    Tag t2 = new Tag.withIdAndName(2, "Java");
    Member m1 = new Member.withIdAndName(1, "Gerald", "Leeb");
    m1.registered = new DateTime.utc(2017,1,30);
    m1.active = true;
    m1.tags.addAll([t1, t2]);

    Member m2 = new Member.withIdAndName(2, "Robert", "Leeb");
    m2.registered = new DateTime.utc(2017,1,29);
    m2.active = false;
    m2.tags.addAll([t2]);

    expect(defaultDynamo.toJson(m1), json);

    Member m1decoded = defaultDynamo.fromJson(json);
    expect(m1decoded.id, 1);
    expect(m1decoded.firstName, "Gerald");
    expect(m1decoded.lastName, "Leeb");
    expect(m1decoded.registered, new DateTime.utc(2017,1,30));
    expect(m1decoded.active, isTrue);
    expect(m1decoded.tags.length, 2);
    expect(m1decoded.tags[0].name, "Dart");
  });

  test("simple model with pretty json", (){
    final prettyJson = '''
{
  "_isa_": "member",
  "id": 1,
  "firstName": "Gerald",
  "last_name": "Leeb",
  "tags": [
    {
      "_isa_": "tag",
      "id": 1,
      "name": "Dart"
    },
    {
      "_isa_": "tag",
      "id": 2,
      "name": "Java"
    }
  ]
}''';
    Tag t1 = new Tag.withIdAndName(1, "Dart");
    Tag t2 = new Tag.withIdAndName(2, "Java");
    Member m1 = new Member.withIdAndName(1, "Gerald", "Leeb");
    m1.tags.addAll([t1, t2]);
    expect(prettyDynamo.toJson(m1), prettyJson);

    final json = '{"_isa_":"member","id":1,"firstName":"Gerald","last_name":"Leeb","tags":[]}';
    Member m1decoded = prettyDynamo.fromJson(json);
    expect(m1decoded.id, 1);
    expect(m1decoded.firstName, "Gerald");
    expect(m1decoded.lastName, "Leeb");
  });

  test("use type transformers", (){
    final json = '{"memberId":2}';
    Member m1 = new Member.withIdAndName(1, "Gerald", "Leeb");
    Member m2 = new Member.withIdAndName(2, "Donald", "Duck");
    Member m3 = new Member.withIdAndName(3, "Mickey", "Maus");

    // usually repositories for members and tags
    List<Member> members = [m1, m2, m3];

    MemberTransformer memberTransformer = new MemberTransformer(members);

    Dynamo dynamo = new Dynamo()
      ..addTransformer(memberTransformer)
    ;

    expect(dynamo.toJson(m2), json);

    Member m2decoded = dynamo.fromJson(json);
    expect(m2decoded.id, 2);
    expect(m2decoded.firstName, "Donald");
    expect(m2decoded.lastName, "Duck");
  });

  test("use date time transformers", (){
    final json = '''[
  {
    "_isa_":"member",
    "id":1,
    "firstName":"Gerald",
    "last_name":"Leeb",
    "registered":{"_dt_":"2017-01-30T00:00:00.000Z"},
    "tags":[]},
  {"_dt_":"2017-01-29T00:00:00.000Z"},
  {"_dt_":"2017-01-28T00:00:00.000Z"}
]''';

    Member m = new Member.withIdAndName(1, "Gerald", "Leeb");
    m.registered = new DateTime.utc(2017,1,30);
    DateTime d1 = new DateTime.utc(2017,1,29);
    DateTime d2 = new DateTime.utc(2017,1,28);

    List values = [m, d1, d2];

    Dynamo dynamo = createCommonDynamo(JSON)
      ..addTransformer(new DateTimeTransformer("_dt_"))
    ;

    expect(dynamo.toJson(values), json.replaceAll(new RegExp(r'\s'), r''));

    var decoded = dynamo.fromJson(json);
    expect(decoded is List, isTrue);
    expect(decoded.length, 3);
    expect(decoded[0] is Member, isTrue);
    expect(decoded[0].registered, new DateTime.utc(2017,1,30));
    expect(decoded[1] is DateTime, isTrue);
    expect(decoded[1], new DateTime.utc(2017,1,29));
    expect(decoded[2] is DateTime, isTrue);
    expect(decoded[2], new DateTime.utc(2017,1,28));
  });

  test("different dynamo", (){
    final requestJson = '{"_isa_":"allMembersRequest","id":2}';
    final responstJson = '''
    {
      "_isa_":"allMembersResponse",
      "id":2,
      "tags":[{"_isa_":"tag","id":1,"name":"Dart","_id#_":1},{"_isa_":"tag","id":2,"name":"Java","_id#_":2}],
      "members":[
        {"_isa_":"member","id":1,"firstName":"Gerald","last_name":"Leeb","registered":"2017-01-30T00:00:00.000Z","active":true,"tags":[{"_ref_":1},{"_ref_":2}]},
        {"_isa_":"member","id":2,"firstName":"Robert","last_name":"Leeb","registered":"2017-01-29T00:00:00.000Z","active":false,"tags":[{"_ref_":2}]}]}
    ''';

    AllMembersRequest request = new AllMembersRequest();
    request.id = 2;
    expect(defaultTransactionDynamo.toJson(request), requestJson);

    // wrong dynamo
    expect(() => defaultDynamo.fromJson(responstJson), throwsA("No factory for allMembersResponse"));
    // right dynamo
    Object response = defaultTransactionDynamo.fromJson(responstJson);
    expect(response is AllMembersResponse, isTrue);

    AllMembersResponse allMembersResponse = response as AllMembersResponse;
    expect(allMembersResponse.id, 2);
    expect(allMembersResponse.members.length, 2);
    expect(allMembersResponse.members.first.firstName, "Gerald");
    expect(allMembersResponse.members.first.tags.length, 2);

    expect(allMembersResponse.tags.length, 2);
    expect(allMembersResponse.tags.first.name, "Dart");

    expect(allMembersResponse.members.first.tags.first, same(allMembersResponse.tags.first));
  });

  test("customize json keys", (){
    final json = r'''[{
        "$typeof":"member",
        "id":1,
        "firstName":"Gerald",
        "last_name":"Leeb",
        "tags":[
          {"$typeof":"tag","id":1,"name":"Dart","$instance":1},
          {"$typeof":"tag","id":2,"name":"Java","$instance":2}
        ]
      },
      {"$reference":1},
      {"$reference":2}]
    ''';
    Tag t1 = new Tag.withIdAndName(1, "Dart");
    Tag t2 = new Tag.withIdAndName(2, "Java");
    Member m1 = new Member.withIdAndName(1, "Gerald", "Leeb");
    m1.tags.addAll([t1, t2]);

    Member m2 = new Member.withIdAndName(2, "Robert", "Leeb");
    m2.registered = new DateTime.utc(2017,1,29);
    m2.active = false;
    m2.tags.addAll([t2]);

    Dynamo dynamo = createCommonDynamo(JSON)
      ..typeKey = r"$typeof"
      ..instanceIdKey = r"$instance"
      ..referenceKey = r"$reference";
    ;
    expect(dynamo.toJson([m1, t1, t2]), json.replaceAll(new RegExp(r'\s'), r''));

    List m1decoded = dynamo.fromJson(json);

    expect(m1decoded[0] is Member, isTrue);
    expect(m1decoded[1] is Tag, isTrue);
    expect(m1decoded[2] is Tag, isTrue);

    expect(m1decoded[0].firstName, "Gerald");
    expect(m1decoded[0].lastName, "Leeb");
    expect(m1decoded[0].tags.length, 2);

    expect(m1decoded[0].tags[0], same(m1decoded[1]), reason: "must be the same instance");
    expect(m1decoded[0].tags[1], same(m1decoded[2]), reason: "must be the same instance");
  });
}



class MemberTransformer implements TypeTransformer<Member> {
  static const String KEY = 'memberId';
  final List<Member> members; // usually a repository

  MemberTransformer(this.members);

  @override
  bool canEncode(value) => value is Member;

  @override
  encode(Member value) => {KEY: value.id};

  @override
  bool canDecode(value) => value is Map && value.containsKey(KEY);

  @override
  Member decode(value) => members.firstWhere((member) => member.id == value[KEY], orElse: () => null);
}
