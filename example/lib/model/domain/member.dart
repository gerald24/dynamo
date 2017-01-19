part of dynamo_example;

enum MemberType { adult, student, unemployed, pensioner, child, vip }

@DynamoSerializable()
class Member extends Object with _$MemberDynamoMixin {
  int id = 0;
  String title;
  String firstName;
  String lastName;
  String birthday;
  String email;
  String phoneNumber;
  String street;
  String city;
  String postalCode;
  String country;
  MemberType type;
  String notes;
  bool active;
  bool registrationFeePaid;
  List<Tag> tags = [];

  Member();

  Member.withIdAndName(this.id, this.firstName, this.lastName) {}

  Member.cloneMember(Member member) {
    id = member.id;
    this.copyFrom(member);
  }

  Member.emptyMember() {}

  @DynamoEntry(ignore: true)
  bool get isNew => id < 1;

  void copyFrom(Member member) {
    firstName = member.firstName;
    lastName = member.lastName;
    email = member.email;
  }

  bool matchFilter(String filter) {
    return filter.split(' ').every((component) => _matchFilterComponent(component.toLowerCase()));
  }

  _matchFilterComponent(String filterComponent) {
    return
        nullSafeLowerCase(firstName).contains(filterComponent) ||
        nullSafeLowerCase(lastName).contains(filterComponent) ||
        nullSafeLowerCase(email).contains(filterComponent);
  }

  int compareTo(Member other) {
    var lastNameCompare = nullSafe(lastName).compareTo(nullSafe(other.lastName));
    return lastNameCompare == 0 ? nullSafe(firstName).compareTo(nullSafe(other.firstName)) : lastNameCompare;
  }

}