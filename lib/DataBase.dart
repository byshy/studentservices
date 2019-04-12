import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final String _databaseName = "StudentServices.db";
  static final int _databaseVersion = 1;

  static final adsTable = 'ads_table';
  static final agendaTable = 'agenda_table';
  static final installmentsTable = 'installments_table';
  static final marksTable = 'marks_table';
  static final subjectsTable = 'marks_table';
  static final scheduleTable = 'schedule_table';
  static final studentTable = 'student_table';

  static final adsIDColumn = 'ads_table_id';
  static final adsAddressColumn = 'ads_table_address';
  static final adsDestinationColumn = 'ads_table_destination';

  static final agendaIDColumn = 'agenda_table_name';
  static final agendaNameColumn = 'agenda_table_name';
  static final agendaDateColumn = 'agenda_table_date';

  static final installmentsDueDateColumn = 'installments_table_due_date';
  static final installmentsAmountColumn = 'installments_table_amount';
  static final installmentsPayedColumn = 'installments_table_payed';

//  static final installmentsRemainingColumn = 'installments_table_remaining';

  static final marksYearColumn = 'installments_table_due_date';
  static final marksSemesterColumn = 'installments_table_amount';
  static final marksGPAColumn = 'installments_table_payed';
  static final marksCGPAColumn = 'installments_table_payed';
//  static final marksSubjectsColumn = 'installments_table_payed';

  static final subjectsYearColumn = 'subjects_table_year';
  static final subjectsNameColumn = 'subjects_table_name';
  static final subjectsCodeColumn = 'subjects_table_code';
  static final subjectsMidColumn = 'subjects_table_mid';
  static final subjectsFinalColumn = 'subjects_table_final';
  static final subjectsCreditsColumn = 'subjects_table_credits';

  static final scheduleNameColumn = 'schedule_table_name';
  static final scheduleDayColumn = 'schedule_table_day';
  static final scheduleHourStartColumn = 'schedule_table_hours_start';
  static final scheduleHourEndColumn = 'schedule_table_hours_end';

  static final studentNumberColumn = 'student_table_name';
  static final studentDoBColumn = 'student_table_day';
  static final studentPoBColumn = 'student_table_hours_start';
  static final studentNameEngColumn = 'student_table_hours_end';
  static final studentNameAraColumn = 'student_table_name';
  static final studentAddressColumn = 'student_table_day';
  static final studentCollegeColumn = 'student_table_hours_start';
  static final studentGPAColumn = 'student_table_hours_end';
  static final studentSpecialtyColumn = 'student_table_name';
  static final studentLvlColumn = 'student_table_day';
  static final studentPlanNoColumn = 'student_table_hours_start';
  static final studentSuccessHrsColumn = 'student_table_hours_end';
  static final studentStudyHrsColumn = 'student_table_name';
  static final studentRemainingHrsColumn = 'student_table_day';
  static final studentBalanceColumn = 'student_table_hours_start';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $adsTable (
            $adsIDColumn INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $adsAddressColumn TEXT NOT NULL,
            $adsDestinationColumn TEXT NOT NULL
          )
          
          ''');
//    CREATE TABLE $agendaTable (
//        $agendaIDColumn INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//        $agendaNameColumn TEXT NOT NULL,
//        $agendaDateColumn TEXT NOT NULL
//    )
  }

  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertAds(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(adsTable, row);
  }

  Future<int> insertAgenda(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(agendaTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllAdsRows() async {
    Database db = await instance.database;
    return await db.query(adsTable);
  }

  Future<List<Map<String, dynamic>>> queryAllAgendaRows() async {
    Database db = await instance.database;
    return await db.query(agendaTable);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateAds(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[adsIDColumn];
    return await db.update(adsTable, row, where: '$adsIDColumn = ?', whereArgs: [id]);
  }

  Future<int> updateAgenda(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[agendaIDColumn];
    return await db.update(agendaTable, row, where: '$agendaIDColumn = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteAds(int id) async {
    Database db = await instance.database;
    return await db.delete(adsTable, where: '$adsIDColumn = ?', whereArgs: [id]);
  }

  Future<int> deleteAgenda(int id) async {
    Database db = await instance.database;
    return await db.delete(agendaTable, where: '$agendaIDColumn = ?', whereArgs: [id]);
  }

  Future<int> queryAdsRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $adsTable'));
  }

  Future<int> queryAgendaRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $agendaTable'));
  }

}
