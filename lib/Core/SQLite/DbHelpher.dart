// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print
import 'package:ism/Model/Address(local).dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Profile(local).dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const _databaseVersion = 1;

//Checklist Create
class DBSQL {
  static final _databaseName = "SQLDbsss.db3";
  final table = 'SQLpro_tbl';
  final id = "id";
  final proId = "proId";
  final proname = "proname";
  final proemail = "proemail";
  final promobileno = "promobileno";
  final propassword = "propassword";
  final imageByteArray = "imageByteArray";
  final image = "image";
  final issaved = "issaved";
  final role = "role";
  DBSQL._privateConstructor();
  static final DBSQL instance = DBSQL._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: 1, // Define the database version here
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT, 
        $proId TEXT,
        $proname TEXT,
        $proemail TEXT,
        $promobileno TEXT,
        $propassword TEXT,
        $imageByteArray TEXT,
        $issaved TEXT,
        $role TEXT,
        $image BLOB
      )
    ''');
    print("database table created");
  }

  void insert(Map<String, dynamic> value) async {
    Database db = await instance.database;
    await db.insert(table, value);
    print("insert data");
  }

  void SQLUpdatedata(Profile value) async {
    final db = await database;
    await db.update(
      table,
      value.toJson(),
      where: 'proId = ?',
      whereArgs: [value.proId],
    );
  }

  Future<void> DeleteCheckList(Profile value) async {
    final db = await database;
    await db.delete(
      table,
      where: 'proId = ?',
      whereArgs: [value.proId],
    );
  }

  Future<List<Profile>> fatchdataSQLNew() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table");
    print(maps);
    return List.generate(maps.length, (i) {
      return Profile(
        proId: maps[i]['proId'],
        proname: maps[i]['proname'],
        proemail: maps[i]['proemail'],
        propassword: maps[i]['propassword'],
        image: maps[i]['image'],
        //imageByteArray: maps[i]['imageByteArray'],
        issaved: maps[i]['issaved'],
        role: maps[i]['role'],
      );
    });
  }
//user auth

  Future<Profile?> login(String promobileno) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM $table WHERE promobileno = ?", [promobileno]);

    if (maps.isNotEmpty) {
      return Profile(
        proId: maps.first['proId'],
        proname: maps.first['proname'],
        proemail: maps.first['proemail'],
        promobileno: maps.first['promobileno'],
        propassword: maps.first['propassword'],
        issaved: maps.first['issaved'],
        // imageByteArray: maps.first['imageByteArray'],
        image: maps.first['image'],
        role: maps.first['role'],
      );
    }
    return null;
  }

  Future<Profile?> getdetails(String proId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM $table WHERE promobileno = ?", [proId]);

    if (maps.isNotEmpty) {
      return Profile(
        proId: maps.first['proId'],
        proname: maps.first['proname'],
        proemail: maps.first['proemail'],
        promobileno: maps.first['promobileno'],
        image: maps.first['image'],
        //imageByteArray: maps.first['imageByteArray'],
        issaved: maps.first['issaved'],
        role: maps.first['role'],
      );
    }
    return null;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

class DbLocationHelper {
  static final _databaseName = "location.db3";
  final table = 'location_tbl';
  final id = "id";
  final Longitude = "Longitude";
  final Latitude = "Latitude";
  final address = "address";
  DbLocationHelper._privateConstructor();
  static final DbLocationHelper instance =
      DbLocationHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: 1, // Define the database version here
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY AUTOINCREMENT, 
        $Longitude TEXT,
        $Latitude TEXT,
        $address TEXT
      )
    ''');
    print("database table created");
  }

  void insertlocation(Map<String, dynamic> value) async {
    Database db = await instance.database;
    await db.insert(table, value);
    print("insert data");
  }

  void SQLUpdatedata(Profile value) async {
    final db = await database;
    await db.update(
      table,
      value.toJson(),
      where: 'proId = ?',
      whereArgs: [value.proId],
    );
  }

  Future<void> DeleteCheckList(Profile value) async {
    final db = await database;
    await db.delete(
      table,
      where: 'proId = ?',
      whereArgs: [value.proId],
    );
  }

  Future<LocationClass?> fatchdatalocation() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table");
    print(maps);
    if (maps.isNotEmpty) {
      return LocationClass(
        address: maps.first['address'],
        Latitude: maps.first['Latitude'],
        Longitude: maps.first['Longitude'],
      );
    }
    return null;
  }
//user auth

  Future<Profile?> login(String promobileno) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM $table WHERE promobileno = ?", [promobileno]);

    if (maps.isNotEmpty) {
      return Profile(
        proId: maps.first['proId'],
        proname: maps.first['proname'],
        proemail: maps.first['proemail'],
        promobileno: maps.first['promobileno'],
        propassword: maps.first['propassword'],
        issaved: maps.first['issaved'],
        // imageByteArray: maps.first['imageByteArray'],
        image: maps.first['image'],
      );
    }
    return null;
  }

  Future<Profile?> getdetails(String proId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM $table WHERE proId = ?", [proId]);

    if (maps.isNotEmpty) {
      return Profile(
        proId: maps.first['proId'],
        proname: maps.first['proname'],
        proemail: maps.first['proemail'],
        propassword: maps.first['propassword'],
        image: maps.first['image'],
        // imageByteArray: maps.first['imageByteArray'],
        issaved: maps.first['issaved'],
      );
    }
    return null;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  getUsersotherdetailsbyList() {}
}

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'students.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE students (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         fingerprint_id TEXT UNIQUE
//       )
//     ''');
//     await db.execute('''
//       CREATE TABLE attendance (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         student_id INTEGER,
//         date TEXT,
//         FOREIGN KEY (student_id) REFERENCES students (id)
//       )
//     ''');
//   }

//   Future<void> insertStudent(Map<String, dynamic> student) async {
//     Database db = await database;
//     await db.insert('students', student);
//   }

//   Future<Map<String, dynamic>?> getStudentByFingerprintId(
//       String fingerprintId) async {
//     Database db = await database;
//     final List<Map<String, dynamic>> students = await db.query(
//       'students',
//       where: 'fingerprint_id = ?',
//       whereArgs: [fingerprintId],
//     );
//     if (students.isNotEmpty) {
//       return students.first;
//     }
//     return null;
//   }

//   Future<void> markAttendance(int studentId) async {
//     Database db = await database;
//     await db.insert('attendance', {
//       'student_id': studentId,
//       'date': DateTime.now().toIso8601String(),
//     });
//   }

//   Future<List<Map<String, dynamic>>> getAttendance() async {
//     Database db = await database;
//     return await db.query('attendance');
//   }

//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     Database db = await database;
//     return await db.query('students');
//   }
// }

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'iitismdb.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id TEXT,
        password TEXT,
        ci_password TEXT,
        auth_id TEXT,
        created_date TEXT,
        updated_date TEXT,
        user_hash TEXT,
        failed_attempt_cnt INTEGER,
        success_attempt_cnt INTEGER,
        is_blocked INTEGER,
        status TEXT,
        remark TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE UserDetails (
        id TEXT,
        salutation TEXT,
        first_name TEXT,
        middle_name TEXT,
        last_name TEXT,
        sex TEXT,
        category TEXT,
        allocated_category TEXT,
        dob TEXT,
        email TEXT,
        photopath TEXT,
        marital_status TEXT,
        physically_challenged TEXT,
        dept_id TEXT,
        updated TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE userotherdetails (
        id TEXT,
        religion TEXT,
        nationality TEXT,
        kashmiri_immigrant TEXT,
        hobbies TEXT,
        fav_past_time TEXT,
        birth_place TEXT,
        mobile_no TEXT,
        father_name TEXT,
        mother_name TEXT,
        emp_allergy TEXT,
        emp_disease TEXT,
        bank_name TEXT,
        bank_accno TEXT,
        ifsc_code TEXT,
        device_info TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ta_details (
        id INTEGER PRIMARY KEY,
        session_year TEXT,
        session TEXT,
        sub_code TEXT,
        sub_offered_id TEXT,
        ft_id TEXT,
        admn_no TEXT,
        remark TEXT,
        status TEXT,
        created_at TEXT,
        modified_at TEXT
      )
    ''');
  }

  // CRUD operations for user table
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'user',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Future<List<User>> getUsers() async {
  //   final db = await database;
  //   return await db.query('user');
  // }
  Future<List<User>> getUsersbyList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM user");
    print(maps);
    return List.generate(maps.length, (i) {
      return User(
        id: maps.first['id'],
        password: maps.first['password'],
        ciPassword: maps.first['ci_password'],
        authId: maps.first['auth_id'],
        createdDate: maps.first['created_date'],
        //imageByteArray: maps.first['imageByteArray'],
        updatedDate: maps.first['updated_date'],
        userHash: maps.first['user_hash'],
        failedAttemptCnt: maps.first['failed_attempt_cnt'],
        successAttemptCnt: maps.first['success_attempt_cnt'],
        isBlocked: maps.first['is_blocked'],
        status: maps.first['status'],
        remark: maps.first['remark'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('user');
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.update(
      'user',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for UserDetails table
  Future<void> insertUserDetails(Map<String, dynamic> userDetails) async {
    final db = await database;
    await db.insert(
      'UserDetails',
      userDetails,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUserDetails() async {
    final db = await database;
    return await db.query('UserDetails');
  }

  Future<List<UserDetails>> getUsersdetailsbyList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM UserDetails");
    print(maps);
    return List.generate(maps.length, (i) {
      return UserDetails(
        id: maps.first['id'],
        salutation: maps.first['salutation'],
        firstName: maps.first['first_name'],
        middleName: maps.first['middle_name'],
        lastName: maps.first['last_name'],
        //imageByteArray: maps.first['imageByteArray'],
        sex: maps.first['sex'],
        category: maps.first['category'],
        allocatedCategory: maps.first['allocated_category'],
        dob: maps.first['dob'],
        email: maps.first['email'],
        photopath: maps.first['photopath'],
        maritalStatus: maps.first['marital_status'],
        deptId: maps.first['dept_id'],
        updated: maps.first['updated'],
      );
    });
  }

  Future<void> updateUserDetails(Map<String, dynamic> userDetails) async {
    final db = await database;
    await db.update(
      'UserDetails',
      userDetails,
      where: 'id = ?',
      whereArgs: [userDetails['id']],
    );
  }

  Future<void> deleteUserDetails(int id) async {
    final db = await database;
    await db.delete(
      'UserDetails',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for userotherdetails table
  Future<void> insertUserOtherDetails(
      Map<String, dynamic> userOtherDetails) async {
    final db = await database;
    await db.insert(
      'userotherdetails',
      userOtherDetails,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUserOtherDetails() async {
    final db = await database;
    return await db.query('userotherdetails');
  }

  Future<List<UserOtherDetails>> getUsersotherdetailsbyList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM userotherdetails");
    print(maps);
    return List.generate(maps.length, (i) {
      return UserOtherDetails(
        id: maps.first['id'],
        religion: maps.first['religion'],
        nationality: maps.first['kashmiri_immigrant'],
        hobbies: maps.first['hobbies'],
        favPastTime: maps.first['fav_past_time'],
        //imageByteArray: maps.first['imageByteArray'],
        birthPlace: maps.first['birth_place'],
        mobileNo: maps.first['mobile_no'],
        fatherName: maps.first['father_name'],
        motherName: maps.first['mother_name'],
        empAllergy: maps.first['emp_allergy'],
        empDisease: maps.first['emp_disease'],
        bankName: maps.first['bank_name'],
        ifscCode: maps.first['ifsc_code'],
        bankAccno: maps.first['bank_accno'],
        deviceInfo: maps.first['device_info'],
        // device_info
      );
    });
  }

  Future<void> updateUserOtherDetails(
      Map<String, dynamic> userOtherDetails) async {
    final db = await database;
    await db.update(
      'userotherdetails',
      userOtherDetails,
      where: 'id = ?',
      whereArgs: [userOtherDetails['id']],
    );
  }

  Future<void> deleteUserOtherDetails(int id) async {
    final db = await database;
    await db.delete(
      'userotherdetails',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for ta_details table
  Future<void> insertTaDetails(Map<String, dynamic> taDetails) async {
    final db = await database;
    await db.insert(
      'ta_details',
      taDetails,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTaDetails() async {
    final db = await database;
    return await db.query('ta_details');
  }

  Future<List<Tadata>> getTadetailsbyList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM ta_details");
    print(maps);
    return List.generate(maps.length, (i) {
      return Tadata(
          id: maps.first['id'],
          sessionYear: maps.first['session_year'],
          session: maps.first['session'],
          subCode: maps.first['sub_code'],
          subOfferedId: maps.first['sub_offered_id'],
          ftId: maps.first['ft_id'],
          admnNo: maps.first['admn_no'],
          remark: maps.first['remark'],
          status: maps.first['status'],
          createdAt: maps.first['created_at'],
          modifiedAt: maps.first['modified_at']);
    });
  }

  Future<void> updateTaDetails(Map<String, dynamic> taDetails) async {
    final db = await database;
    await db.update(
      'ta_details',
      taDetails,
      where: 'id = ?',
      whereArgs: [taDetails['id']],
    );
  }

  Future<void> deleteTaDetails(int id) async {
    final db = await database;
    await db.delete(
      'ta_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method to truncate a table
  Future<void> truncateTableuser(String tableName) async {
    final db = await database;
    await db.delete('user');
  }

  // Method to truncate a table
  Future<void> truncateTableuserdetails(String tableName) async {
    final db = await database;
    await db.delete('UserDetails');
  }

  // Method to truncate a table
  Future<void> truncateTableuserotherdetails(String tableName) async {
    final db = await database;
    await db.delete('userotherdetails');
  }

  // Method to truncate a table
  Future<void> truncateTableta(String tableName) async {
    final db = await database;
    await db.delete('ta_details');
  }
}
