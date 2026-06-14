import 'package:share_plus/share_plus.dart';

Future<void> telechargerCsv(String csv, String nomFichier) async {
  await Share.share(csv, subject: nomFichier);
}