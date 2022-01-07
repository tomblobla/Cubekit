import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cubekit/model/solve.dart';
import 'package:cubekit/model/solvestate.dart';
import 'package:cubekit/model/cube.dart';

class SolvesDatabase {
  static final SolvesDatabase instance = SolvesDatabase._init();

  static Database? _database;

  SolvesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('cubekit.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  _createDB(Database db, int version) {
    final idType = 'INTEGER PRIMARY KEY';
    final textType = 'TEXT';
    final integerType = 'INTEGER NOT NULL';
    var executeScript = '''
      CREATE TABLE $tableSolveStates(${SolveStateFields.id} $idType, ${SolveStateFields.name} $textType);
    ''';
    db.execute(executeScript);
    executeScript = '''
      CREATE TABLE $tableCubes ( 
        ${CubeFields.id} $idType, 
        ${CubeFields.name} $textType,
        ${CubeFields.scramble} $textType);
      ''';
    db.execute(executeScript);
    executeScript = '''
      CREATE TABLE $tableSolves(
        ${SolveFields.id} $idType AUTOINCREMENT, 
        ${SolveFields.cubeid} INTEGER REFERENCES $tableCubes(${CubeFields.id}),
        ${SolveFields.stateid} INTEGER REFERENCES $tableSolveStates(${SolveStateFields.id}),
        ${SolveFields.length} $integerType,
        ${SolveFields.scramble} $textType,
        ${SolveFields.comment} $textType,
        ${SolveFields.time} $textType);
      ''';
    db.execute(executeScript);
    executeScript = '''
    INSERT INTO $tableSolveStates(${SolveStateFields.id}, ${SolveStateFields.name})
    VALUES (0, 'OK'),
      (1, '+2'),
      (2, 'DNF');
    ''';
    db.execute(executeScript);
    executeScript = '''
    INSERT INTO $tableCubes(
        ${CubeFields.id},
        ${CubeFields.name},
        ${CubeFields.scramble})
      VALUES (0, '3 x 3 x 3', '333'),
        (1, '2 x 2 x 2', '222'),
        (2, '4 x 4 x 4', '444'),
        (3, '5 x 5 x 5', '555'),
        (4, '6 x 6 x 6', '666'),
        (5, '7 x 7 x 7', '777'),
        (6, 'Megaminx', 'minx'),
        (7, 'Pyraminx', 'minx'),
        (8, 'Skewb', 'skewb'),
        (9, 'Square - 1', 'sq1'),
        (10, 'Clock', 'clock');
    ''';
    db.execute(executeScript);
  }

  Future<Solve> create(Solve solve) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableSolves, solve.toJson());
    return solve.copy(id: id);
  }

  Future<Solve> readSolve(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSolves,
      columns: SolveFields.values,
      where: '${SolveFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Solve.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Solve>> readAllSolves(int cubeid) async {
    final db = await instance.database;

    final orderBy = '${SolveFields.time} DESC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(
      tableSolves,
      orderBy: orderBy,
      columns: SolveFields.values,
      where: '${SolveFields.cubeid} = ?',
      whereArgs: [cubeid],
    );

    return result.map((json) => Solve.fromJson(json)).toList();
  }

  Future<int> update(Solve solve) async {
    final db = await instance.database;

    return db.update(
      tableSolves,
      solve.toJson(),
      where: '${SolveFields.id} = ?',
      whereArgs: [solve.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableSolves,
      where: '${SolveFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<SolveState>> readAllSolveStates() async {
    final db = await instance.database;

    final orderBy = '${SolveStateFields.id} ASC';

    final result = await db.query(
      tableSolveStates,
      orderBy: orderBy,
    );

    return result.map((json) => SolveState.fromJson(json)).toList();
  }

  Future<List<Cube>> readAllCubes() async {
    final db = await instance.database;

    final orderBy = '${CubeFields.id} ASC';

    final result = await db.query(
      tableCubes,
      orderBy: orderBy,
    );
    var res = result.map((json) => Cube.fromJson(json)).toList();
    return res;
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
