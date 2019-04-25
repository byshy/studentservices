import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final String _databaseName = "StudentServices.db";
  static final int _databaseVersion = 6;

  static final adsTable = 'ads_table';
  static final agendaTable = 'agenda_table';
  static final installmentsTable = 'installments_table';
  static final marksTable = 'marks_table';
  static final subjectsTable = 'subjects_table';
  static final scheduleTable = 'schedule_table';
  static final studentTable = 'student_table';

  static final adsIDColumn = 'ads_table_id';
  static final adsAddressColumn = 'ads_table_address';
  static final adsDestinationColumn = 'ads_table_destination';

  static final agendaIDColumn = 'agenda_table_id';
  static final agendaDateColumn = 'agenda_table_date';

  static final installmentsIDColumn = 'installments_table_id';
  static final installmentsDueDateColumn = 'installments_table_due_date';
  static final installmentsAmountColumn = 'installments_table_amount';
  static final installmentsPayedColumn = 'installments_table_payed';

  static final marksIDColumn = 'marks_table_id';
  static final marksYearColumn = 'marks_table_year';
  static final marksSemesterColumn = 'marks_table_semester';
  static final marksGPAColumn = 'marks_table_gpa';
  static final marksCGPAColumn = 'marks_table_cgpa';

  static final subjectsIDColumn = 'subjects_table_id';
  static final subjectsMarksIDColumn = 'subjects_table_marks_id';
  static final subjectsNameColumn = 'subjects_table_name';
  static final subjectsCodeColumn = 'subjects_table_code';
  static final subjectsMidColumn = 'subjects_table_mid';
  static final subjectsFinalColumn = 'subjects_table_final';
  static final subjectsCreditsColumn = 'subjects_table_credits';

  static final scheduleIDColumn = 'schedule_table_id';
  static final scheduleNameColumn = 'schedule_table_name';
  static final scheduleDayColumn = 'schedule_table_day';
  static final scheduleHourStartColumn = 'schedule_table_hours_start';
  static final scheduleHourEndColumn = 'schedule_table_hours_end';

  static final studentNumberColumn = 'student_table_number';
  static final studentDoBColumn = 'student_table_dob';
  static final studentPoBColumn = 'student_table_pob';
  static final studentNameEngColumn = 'student_table_name_eng';
  static final studentNameArColumn = 'student_table_name_ar';
  static final studentAddressColumn = 'student_table_address';
  static final studentCollegeColumn = 'student_table_college';
  static final studentGPAColumn = 'student_table_gpa';
  static final studentSpecialtyColumn = 'student_table_specialty';
  static final studentLvlColumn = 'student_table_lvl';
  static final studentPlanNoColumn = 'student_table_plan_no';
  static final studentSuccessHrsColumn = 'student_table_success_hrs';
  static final studentStudyHrsColumn = 'student_table_study_hrs';
  static final studentRemainingHrsColumn = 'student_table_remaining_hrs';
  static final studentBalanceColumn = 'student_table_balance';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $adsTable (
            $adsIDColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $adsAddressColumn TEXT NOT NULL,
            $adsDestinationColumn TEXT NOT NULL
          );''');
    await db.execute('''
          CREATE TABLE $agendaTable (
            $agendaIDColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $agendaDateColumn TEXT NOT NULL
          );''');
    await db.execute('''
          CREATE TABLE $installmentsTable (
            $installmentsIDColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $installmentsDueDateColumn TEXT NOT NULL,
            $installmentsAmountColumn INTEGER NOT NULL,
            $installmentsPayedColumn INTEGER NOT NULL
          );''');
    await db.execute('''
          CREATE TABLE $marksTable (
            $marksIDColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $marksYearColumn TEXT NOT NULL,
            $marksSemesterColumn INTEGER NOT NULL,
            $marksGPAColumn REAL NOT NULL,
            $marksCGPAColumn REAL NOT NULL
          );''');
    await db.execute('''
          CREATE TABLE $subjectsTable (
            $subjectsIDColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $subjectsMarksIDColumn INTEGER NOT NULL,
            $subjectsNameColumn TEXT NOT NULL,
            $subjectsCodeColumn TEXT NOT NULL,
            $subjectsMidColumn INTEGER NOT NULL,
            $subjectsFinalColumn INTEGER NOT NULL,
            $subjectsCreditsColumn INTEGER NOT NULL
          );''');
    await db.execute('''
          CREATE TABLE $scheduleTable (
            $scheduleIDColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $scheduleNameColumn TEXT NOT NULL,
            $scheduleDayColumn TEXT NOT NULL,
            $scheduleHourStartColumn TEXT NOT NULL,
            $scheduleHourEndColumn TEXT NOT NULL
          );''');
    await db.execute('''
          CREATE TABLE $studentTable (
            $studentNumberColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $studentDoBColumn TEXT NOT NULL,
            $studentPoBColumn TEXT NOT NULL,
            $studentNameEngColumn TEXT NOT NULL,
            $studentNameArColumn TEXT NOT NULL,
            $studentAddressColumn TEXT NOT NULL,
            $studentCollegeColumn TEXT NOT NULL,
            $studentGPAColumn REAL NOT NULL,
            $studentSpecialtyColumn TEXT NOT NULL,
            $studentLvlColumn INTEGER NOT NULL,
            $studentPlanNoColumn INTEGER NOT NULL,
            $studentSuccessHrsColumn INTEGER NOT NULL,
            $studentStudyHrsColumn INTEGER NOT NULL,
            $studentRemainingHrsColumn INTEGER NOT NULL,
            $studentBalanceColumn REAL NOT NULL
          );''');
  }

  Future<int> insertAds(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(adsTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllAdsRows() async {
    Database db = await database;
    return await db.query(adsTable);
  }

  Future<int> deleteAllAds() async {
    Database db = await database;
    return await db.rawDelete("DELETE FROM $adsTable");
  }

  Future<int> queryAdsRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $adsTable'));
  }

  Future<int> insertAgenda(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(agendaTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllAgendaRows() async {
    Database db = await database;
    return await db.query(agendaTable);
  }

  Future<int> deleteAllAgenda() async {
    Database db = await database;
    return await db.rawDelete("DELETE FROM $agendaTable");
  }

  Future<int> queryAgendaRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $agendaTable'));
  }

  Future<int> insertInstallments(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(installmentsTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllInstallmentsRows() async {
    Database db = await database;
    return await db.query(installmentsTable);
  }

  Future<int> deleteAllInstallments() async {
    Database db = await database;
    return await db.rawDelete("DELETE FROM $installmentsTable");
  }

  Future<int> queryInstallmentsRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $installmentsTable'));
  }

  Future<int> insertMarks(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(marksTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllMarksRows() async {
    Database db = await database;
    return await db.query(marksTable);
  }

  Future<int> deleteAllMarks() async {
    Database db = await database;
    return await db.rawDelete("DELETE FROM $marksTable");
  }

  Future<int> queryMarksRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $marksTable'));
  }

  Future<int> insertSubjects(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(subjectsTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllSubjectsRows() async {
    Database db = await database;
    return await db.query(subjectsTable);
  }

  Future<int> deleteAllSubjects() async {
    Database db = await database;
    return await db.rawDelete("DELETE FROM $subjectsTable");
  }

  Future<int> querySubjectsRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $subjectsTable'));
  }

}
