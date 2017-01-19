library dynamo_example.test.serialization;

import 'dart:convert';
import 'package:dynamo/dynamo.dart';
import 'package:test/test.dart';
import 'package:dynamo_example/dynamo_example.dart';

void main() {
  test("simple model", (){
    final json = '{"_isa_":"member","id":1,"firstName":"Gerald","lastName":"Leeb","tags":[]}';
    Member m1 = new Member.withIdAndName(1, "Gerald", "Leeb");
    expect(defaultDynamo.toJson(m1), json);

    Member m1decoded = defaultDynamo.fromJson(json);
    expect(m1decoded.id, 1);
    expect(m1decoded.firstName, "Gerald");
    expect(m1decoded.lastName, "Leeb");
  });

  test("simple model", (){
    final json = '{"memberId":2}';

    Member m1 = new Member.withIdAndName(1, "Gerald", "Leeb");
    Member m2 = new Member.withIdAndName(2, "Donald", "Duck");
    Member m3 = new Member.withIdAndName(3, "Mickey", "Maus");
    List<Member> members = [m1, m2, m3];
    MemberTransformer transformer = new MemberTransformer(members);

    Dynamo dynamo = createCommonDynamo(JSON)
      ..addTransformer(transformer);

    expect(dynamo.toJson(m2), json);

    Member m2decoded = dynamo.fromJson(json);
    expect(m2decoded.id, 2);
    expect(m2decoded.firstName, "Donald");
    expect(m2decoded.lastName, "Duck");
  });

  test("different dynamo", (){
    final requestJson = '{"_isa_":"allMembersRequest","id":2}';
    final responstJson = '{"_isa_":"allMembersResponse","id":2,"members":[{"_isa_":"member","id":1,"firstName":"Gerald","lastName":"Leeb","tags":[]}],"tags":[]}';

    AllMembersRequest m1 = new AllMembersRequest();
    m1.id = 2;
    expect(defaultTransactionDynamo.toJson(m1), requestJson);

    // wrong dynamo
    expect(() => defaultDynamo.fromJson(responstJson), throwsA("No factory for allMembersResponse"));
    // right dynamo
    AllMembersResponse m1decoded = defaultTransactionDynamo.fromJson(responstJson);
    expect(m1decoded.id, 2);
    expect(m1decoded.members.first.firstName, "Gerald");
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