import 'dart:typed_data';

class RapportGenere {
  final Uint8List bytes;
  final String    nom;

  const RapportGenere({required this.bytes, required this.nom});
}