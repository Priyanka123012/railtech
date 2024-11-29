// class RegistrationDao {
//   final Database db;

//   RegistrationDao(this.db);

//   Future<void> insertRegistration(Registration registration) async {
//     await db.insert('registration', registration.toMap());
//   }

//   // Add other CRUD methods as needed.
// }

// class PunchInDao {
//   final Database db;

//   PunchInDao(this.db);

//   Future<void> insertPunchIn(PunchIn punchIn) async {
//     await db.insert('punchIn', punchIn.toMap());
//   }

//   Future<List<PunchIn>> getAllPunchIns() async {
//     final List<Map<String, dynamic>> maps = await db.query('punchIn');

//     return List.generate(maps.length, (i) {
//       return PunchIn(
//         maps[i]['id'],
//         maps[i]['empId'],
//         maps[i]['punchImage'],
//         maps[i]['latitude'],
//         maps[i]['longitude'],
//         maps[i]['timestamp'],
//       );
//     });
//   }

//   Future<void> deleteAllPunchIns() async {
//     await db.delete('punchIn');
//   }

//   // Add other CRUD methods as needed.
// }

// @dao
// abstract class EPREDao {
//   @insert
//   Future<void> insertEPRE(EPRE epre);

//   @Query('SELECT * FROM epre')
//   Future<List<EPRE>> getAllEPRE();

//   @delete
//   Future<void> deleteEPRE(EPRE epre);
// }
