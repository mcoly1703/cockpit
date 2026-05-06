class FormatHelper {
  // Formate un montant en euros : 1 234,56 €
  static String formaterMontant(double montant) {
    final parts = montant.toStringAsFixed(2).split('.');
    final entier = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]} ',
    );
    return '$entier,${parts[1]} €';
  }

  static String formaterPourcentage(double valeur) {
    return '${valeur.toStringAsFixed(1)} %';
  }

  static String initiales(String nom, String prenom) {
    final n = nom.isNotEmpty ? nom[0].toUpperCase() : '';
    final p = prenom.isNotEmpty ? prenom[0].toUpperCase() : '';
    return '$n$p';
  }

  // Formate un numéro français : 0612345678 → +33 6 12 34 56 78
  static String formaterTelephone(String tel) {
    final clean = tel.replaceAll(RegExp(r'\s|-'), '');
    if (clean.length == 10 && clean.startsWith('0')) {
      final national = clean.substring(1);
      final groupes = RegExp(r'.{2}').allMatches(national).map((m) => m.group(0)).join(' ');
      return '+33 $groupes';
    }
    return tel;
  }
}