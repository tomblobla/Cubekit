final String tableSolves = 'Solves';

class SolveFields {
  static final List<String> values = [
    /// Add all fields
    id, cubeid, stateid, length, scramble, comment, time
  ];

  static final String id = 'id';
  static final String cubeid = 'cubeid';
  static final String stateid = 'stateid';
  static final String length = 'length';
  static final String scramble = 'scramble';
  static final String comment = 'comment';
  static final String time = 'time';
}

class Solve {
  final int? id;
  final int cubeid;
  int stateid;
  int length;
  String scramble;
  String comment;
  final DateTime time;

  Solve({
    this.id,
    required this.cubeid,
    required this.stateid,
    required this.length,
    required this.scramble,
    required this.comment,
    required this.time,
  });

  Solve copy({
    int? id,
    int? cubeid,
    int? stateid,
    int? length,
    String? scramble,
    String? comment,
    DateTime? time,
  }) =>
      Solve(
        id: id ?? this.id,
        cubeid: cubeid ?? this.cubeid,
        stateid: stateid ?? this.stateid,
        length: length ?? this.length,
        scramble: scramble ?? this.scramble,
        comment: comment ?? this.comment,
        time: time ?? this.time,
      );

  static Solve fromJson(Map<String, Object?> json) => Solve(
        id: json[SolveFields.id] as int?,
        cubeid: json[SolveFields.cubeid] as int,
        stateid: json[SolveFields.stateid] as int,
        length: json[SolveFields.length] as int,
        scramble: json[SolveFields.scramble] as String,
        comment: json[SolveFields.comment] as String,
        time: DateTime.parse(json[SolveFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        SolveFields.id: id,
        SolveFields.cubeid: cubeid,
        SolveFields.stateid: stateid,
        SolveFields.length: length,
        SolveFields.scramble: scramble,
        SolveFields.comment: comment,
        SolveFields.time: time.toIso8601String(),
      };
}
