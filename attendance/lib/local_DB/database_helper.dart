// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();

//   factory DatabaseHelper() {
//     return _instance;
//   }

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'attendance.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute(
//       '''CREATE TABLE registration (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             empId TEXT,
//             faceImage TEXT
//           )''',
//     );

//     await db.execute(
//       '''CREATE TABLE punchIn (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             empId TEXT,
//             punchImage TEXT,
//             latitude TEXT,
//             longitude TEXT,
//             timestamp TEXT
//           )''',
//     );
//   }
// }
