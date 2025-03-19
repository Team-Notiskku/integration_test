// ❌❌❌❌❌ DO NOT MODIFY ❌❌❌❌❌

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:integration_test/models/notice.dart';

class GoogleSheetsAPI {
  static const _spreadsheetId = "1RPTHVpyEJb4mZs9sz10E5OwIpZB-3YJcfrg5H7dFqhM";
  static const _sheetName = "시트1";

  /// Google Sheets API 연결
  static Future<SheetsApi?> _getSheetsApi() async {
    final credentials = await rootBundle.loadString('assets/credentials.json');
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(credentials),
    );

    final client = await clientViaServiceAccount(serviceAccountCredentials, [
      SheetsApi.spreadsheetsScope,
    ]);
    return SheetsApi(client);
  }

  /// 시트 데이터를 Notice 리스트로 변환해서 리턴 
  static Future<List<Notice>> readData({int startRow = 1, int limit = 10}) async {
    final sheetsApi = await _getSheetsApi();
    if (sheetsApi == null) return [];

    final response = await sheetsApi.spreadsheets.values.get(_spreadsheetId, '$_sheetName');

    final allData = response.values ?? [];

    return allData.isNotEmpty
        ? allData.reversed.skip(startRow - 1).take(limit).map((row) => Notice.fromSheet(row.cast<String>())).toList()
        : [];
  }
}