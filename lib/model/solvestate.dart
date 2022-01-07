final String tableSolveStates = 'SolveStates';

class SolveStateFields {
  static final List<String> values = [
    /// Add all fields
    id, name
  ];

  static final String id = 'id';
  static final String name = 'name';
}

class SolveState {
  final int? id;
  final String name;

  const SolveState({
    this.id,
    required this.name,
  });

  SolveState copy({
    int? id,
    String? name,
  }) =>
      SolveState(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  static SolveState fromJson(Map<String, Object?> json) => SolveState(
        id: json[SolveStateFields.id] as int?,
        name: json[SolveStateFields.name] as String,
      );

  Map<String, Object?> toJson() => {
        SolveStateFields.id: id,
        SolveStateFields.name: name,
      };

  withOpacity(double d) {}
}
