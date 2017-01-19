part of dynamo_example;

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