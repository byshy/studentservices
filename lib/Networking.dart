import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studentservices/Ads.dart';
import 'package:studentservices/Agenda.dart';
import 'package:studentservices/Installments.dart';
import 'package:studentservices/Marks.dart';
import 'package:studentservices/Schedule.dart';
import 'package:studentservices/Student.dart';

class Networking {
  final String url = 'https://basil-api.herokuapp.com/';

  Future<AgendaContent> getAgenda() async {
    final response = await http.get("${url}agenda");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return AgendaContent.fromJson(data);
    } else {
      throw Exception('Failed to load agenda');
    }
  }

  Future<Schedule> getSchedule() async {
    final response = await http.get("${url}schedual");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Schedule.fromJson(data);
    } else {
      throw Exception('Failed to load schedual');
    }
  }

  Future<StudentInfo> getStudentInfo() async {
    final response = await http.get("${url}std_info");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return StudentInfo.fromJson(data);
    } else {
      throw Exception('Failed to load student info');
    }
  }

  Future<AcademicalInfo> getAcademicalInfo() async {
    final response = await http.get("${url}academical_data");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return AcademicalInfo.fromJson(data);
    } else {
      throw Exception('Failed to load academical info');
    }
  }

  Future<Installments> getInstallments() async {
    final response = await http.get("${url}installments");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Installments.fromJson(data);
    } else {
      throw Exception('Failed to load installments');
    }
  }

  Future<AdsList> getAds() async {
    final response = await http.get("${url}ads");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return AdsList.fromJson(data);
    } else {
      throw Exception('Failed to load ads');
    }
  }

  Future<MarksList> getMarks() async {
    final response = await http.get("${url}marks");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return MarksList.fromJson(data);
    } else {
      throw Exception('Failed to load marks');
    }
  }

}
