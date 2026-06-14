import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

Future<void> telechargerCsv(String csv, String nomFichier) async {
  final bytes = utf8.encode('﻿$csv'); // BOM pour ouverture correcte dans Excel
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),
  );
  final url = web.URL.createObjectURL(blob);
  final a = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = nomFichier
    ..style.display = 'none';
  web.document.body!.appendChild(a);
  a.click();
  web.document.body!.removeChild(a);
  web.URL.revokeObjectURL(url);
}