final String tableCubes = 'Cubes';

class CubeFields {
  static final List<String> values = [
    /// Add all fields
    id, name, scramble
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String scramble = 'scramble';
}

class Cube {
  final int? id;
  final String name;
  final String scramble;

  const Cube({
    this.id,
    required this.name,
    required this.scramble,
  });

  Cube copy({
    int? id,
    String? name,
    String? scramble,
  }) =>
      Cube(
        id: id ?? this.id,
        name: name ?? this.name,
        scramble: scramble ?? this.scramble,
      );

  static Cube fromJson(Map<String, Object?> json) => Cube(
        id: json[CubeFields.id] as int?,
        name: json[CubeFields.name] as String,
        scramble: json[CubeFields.scramble] as String,
      );

  Map<String, Object?> toJson() => {
        CubeFields.id: id,
        CubeFields.name: name,
        CubeFields.scramble: scramble,
      };
}
