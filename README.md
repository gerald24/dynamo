# dynamo

A JSON serialization for object graphs. This library will not generate a simple JSON but add some information for types and references.
Thus this library supports circle references, inheritance and object graphs (reference aware).

Dynamo uses [source_gen](https://pub.dartlang.org/packages/source_gen) to generate code, and has no dependency to the 'dart:mirror' at all.

Dynamo is rewritten from scratch, but influenced from [Dartson](https://pub.dartlang.org/packages/dartson) ([dartson on github](https://github.com/eredo/dartson)),
 with some [some extensions to Dartson](https://github.com/gerald24/dartson).

## Alternatives

If you need just simple JSON serialization you might use JsonSerializable from [source_gen](https://pub.dartlang.org/packages/source_gen) instead,
 or [Dartson](https://pub.dartlang.org/packages/dartson). Latter uses code transformers.

## Annotations

Serializable Objects must be annotated with `@DynamoSerializable()`,
and also must use a generated mixin (Namepattern is `_$`*classname*`DynamoMixin`)
Fields with missing getter or setter will be ignored. Optional fields can be annotated with `@DynamoEntry()`
in order to use a different json key, or be ignored for serialization.


```dart
@DynamoSerializable()
class Member extends Object with _$MemberDynamoMixin {

  int id = 0;

  String firstName;

  @DynamoEntry(name: 'last_name')
  String lastName;

  DateTime registered;

  @DynamoEntry(ignore: true)
  bool ignoreMe;
  
  Member();

  Member.withIdAndName(this.id, this.firstName, this.lastName) {}

  // will be ignored (no setter)
  bool get isNew => id < 1;

}
```

## Generate Mixins

Build steps are needed to setup. See the [source_gen > Running Generators](https://github.com/dart-lang/source_gen#running-generators)
and [example](https://github.com/gerald24/dynamo/tree/master/example/tool).


## Serialization

The root object for serialization (`toJson`) or deserialization (`fromJson`) might be:
* a list,
* a map,
* a simple type (bool, num, String),
* or a registered type (annotated with `DynamoSerializable` and using a generated `DynamoMixin`).

The protocol for serialization is:
```dart
  String toJson(dynamic value);
  dynamic fromJson(String json, {InstanceFactory factory});
```

Usually fromJson will detect the target instance but optional a factory can be passed instead.


### type registration

Since no mirroring system will be used, each type must be registered using `registerType` with an identifier, the type and a factory for new instances:

```dart
  new Dynamo()
    ..registerType('member', Member, () => new Member())
```

### dynamo configuration

Different dynamo configurations might be used (with the same serializable objects) to produce different JSON output.

```dart
  var dynamo1 = new Dynamo()
    ..addTransformer(new MemberTypeTransformer())
    ..registerType('member', Member, () => new Member())
    ..registerType('tag', Tag, () => new Tag())
    ;

  var dynamo2 = new Dynamo()
    ..registerType('member', Member, () => new Member())
    ..registerType('tag', Tag, () => new Tag())
    ..addTransformer(new MemberTransformer(allMembers))
    ;
```

#### transformers

A type transformer can be added to a dynamo (configuration) e.g for mapping enum values, or just a representation for an entity.

##### Transformer sample: Enum mapping

```dart
enum MemberType { adult, student, unemployed, pensioner, child, vip }

@DynamoSerializable()
class Member extends Object with _$MemberDynamoMixin {

  MemberType type;

  Member();

}

class MemberTypeTransformer extends TypeTransformer<MemberType> {
  final String KEY = 'membertype';
  final MemberType defaultMemberType = MemberType.adult;

  Map<String,MemberType> typeMap = const {
    'adult': MemberType.adult,
    'student': MemberType.student,
    'unemployed': MemberType.unemployed,
    'pensioner': MemberType.pensioner,
    'child': MemberType.child,
    'vip': MemberType.vip
  };

  @override
  bool canDecode(value) => value is MemberType;

  @override
  bool canEncode(value) => value is Map && value.containsKey(KEY);

  dynamic encode(MemberType value) {
    var type = value == null ? defaultMemberType : value;
    for (var key in typeMap.keys) {
      if (typeMap[key] == type) {
        return {KEY : key};
      }
    }
    throw new ArgumentError("unsupported type");
  }

  MemberType decode(dynamic value) => typeMap.containsKey(value[KEY]) ? typeMap[value[KEY]] : defaultMemberType;

}

main() {
  var dynamo = new Dynamo()
      ..addTransformer(new MemberTypeTransformer())
      ..registerType('member', Member, () => new Member());
  
  
  // dynamo.toJson(member);
  // dynamo.fromJson(member);
}
```

##### Transformer sample: Representation instead of whole mapped instance

E.g. if instances already known then only a representation (e.g. ID of an entity) can be serialized instead:

```dart
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

    // usually repositories for members
    List<Member> members = [m1, m2, m3];

    MemberTransformer memberTransformer = new MemberTransformer(members);

    Dynamo dynamo = new Dynamo()
      ..addTransformer(memberTransformer)
    ;

    var output = dynamo.toJson(m2);
```

will produce:

```json
  {"memberId":2}
```


#### datetime transformer

DateTime will be serialized automatically for fields but due to JSON restriction, can not be automatically detected if part of an untyped list oder map (only by guessing). If DateTime is used in untyped collections the bundled DateTimeTransformer can be used:

```dart
    Dynamo dynamo = new Dynamo()
      ..addTransformer(new DateTimeTransformer("_dt_"))
    ;
```

for values e.g. 
List values = [new DateTime.utc(2017,1,29), new DateTime.utc(2017,1,28)];

dynamo will produce
```json
[
  {"_dt_":"2017-01-29T00:00:00.000Z"},
  {"_dt_":"2017-01-28T00:00:00.000Z"}
]
```
But now, also fields in registered type will use this transformer for DateTime fields:
```json
{
    "_isa_":"member",
    "registered":{"_dt_":"2017-01-30T00:00:00.000Z"}
}
```
instead of (using internal datetime transformers for fields):
```json
{
    "_isa_":"member",
    "registered":"2017-01-30T00:00:00.000Z"
}
```

#### generate pretty json output
```dart
class PrettyJsonCodec extends JsonCodec {
  JsonEncoder get encoder {
    return const JsonEncoder.withIndent('  ');
  }
}

new Dynamo(codec: new PrettyJsonCodec()) ....
```

#### customize json keys for type and reference information

default keys:
* typeKey: `_isa_` (used to identify the type)
* instanceIdKey:  `_id#_` (used to add a sequential number)
* referenceKey: `_ref_` (used to reference to a prior serialized instance)


Sample: serialize same instance (of type member) twice in a list:
```json
[
  {
    "_isa_":"member",
    "_id#_":1
  },
  {"_ref_":1}
]
```

To customize these key use following setters:

```dart
    Dynamo dynamo = createCommonDynamo(JSON)
      ..typeKey = r"$typeof"
      ..instanceIdKey = r"$instance"
      ..referenceKey = r"$reference";
```

Same example will produce:
```json
[
  {
    "$typeof":"member",
    "$instance":1
  },
  {"$reference":1}
]
```



## Example

See [example of dynamo in Github Repo](https://github.com/gerald24/dynamo/tree/master/example).

## Not yet implemented

* using different name for imported dynamo library (import as) 


