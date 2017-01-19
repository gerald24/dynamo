part of dynamo_example;

String nullSafe(String value) {
  return value == null ? '' : value;
}

String nullSafeLowerCase(String value) {
  return value == null ? "" : value.toLowerCase();
}
