// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:paisa/core/common.dart';
import 'package:paisa/core/error/exceptions.dart';
import 'package:paisa/features/account/data/data_sources/account_data_manager.dart';
import 'package:paisa/features/account/data/model/account_model.dart';
import 'package:paisa/features/category/data/data_sources/local/category_data_source.dart';
import 'package:paisa/features/category/data/model/category_model.dart';
import 'package:paisa/features/transaction/data/data_sources/local/transaction_data_manager.dart';
import 'package:paisa/features/transaction/data/model/transaction_model.dart';
import 'model/data.dart';

@LazySingleton()
class FileHandler {
  FileHandler(
    this.deviceInfo,
    this.accountDataManager,
    this.categoryDataManager,
    this.expenseDataManager,
  );

  final AccountDataSource accountDataManager;
  final CategoryDataSource categoryDataManager;
  final DeviceInfoPlugin deviceInfo;
  final TransactionDataSource expenseDataManager;

  Future<bool> importDataFromFile() async {
    try {
      final FilePickerResult? result = await _pickFile();
      if (result == null || result.files.isEmpty) {
        throw FileNotFoundException();
      }

      final jsonString = await _readJSONFromFile(result.files.first.path!);
      final Data data = Data.fromRawJson(jsonString);

      await expenseDataManager.clear();
      await categoryDataManager.clear();
      await accountDataManager.clear();

      for (var element in data.accounts) {
        await accountDataManager.update(element);
      }

      for (var element in data.categories) {
        await categoryDataManager.update(element);
      }

      for (var element in data.expenses) {
        await expenseDataManager.update(element);
      }

      return true;
    } catch (err) {
      debugPrint(err.toString());
      throw ErrorFileException();
    }
  }

  Future<FilePickerResult?> _pickFile() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return FilePicker.platform.pickFiles(
        type: androidInfo.version.sdkInt < 29 ? FileType.any : FileType.custom,
        allowedExtensions: androidInfo.version.sdkInt < 29 ? null : ['json'],
        allowMultiple: false,
      );
    } else {
      return FilePicker.platform.pickFiles();
    }
  }

  Future<String> _readJSONFromFile(String path) async {
    final Uint8List bytes = await File(path).readAsBytes();
    return String.fromCharCodes(bytes);
  }

  Future<String> writeDataIntoFile() async {
    final File file = await getTempFile();
    final List<int> jsonBytes = await _fetchAllDataAndEncode();
    await file.writeAsBytes(jsonBytes);
    return file.path;
  }

  Future<File> getTempFile() async {
    final Directory tempDir = await getTemporaryDirectory();
    return await File('${tempDir.path}/paisa_backup.json').create();
  }

  Future<List<int>> _fetchAllDataAndEncode() async {
    final Iterable<TransactionModel> expenses = expenseDataManager.export();
    final Iterable<AccountModel> accounts = accountDataManager.export();
    final Iterable<CategoryModel> categories = categoryDataManager.export();

    final Map<String, dynamic> data = {
      'expenses': expenses.toJson(),
      'accounts': accounts.toJson(),
      'categories': categories.toJson(),
    };
    return utf8.encode(jsonEncode(data));
  }
}
