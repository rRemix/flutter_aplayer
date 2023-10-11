// ignore_for_file: constant_identifier_names

enum LogType {
  VERBOSE(2),
  DEBUG(3),
  INFO(4),
  WARN(5),
  ERROR(6);

  const LogType(this.value);

  final int value;
}
