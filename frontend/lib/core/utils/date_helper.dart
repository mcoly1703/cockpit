class DateHelper {
  static const _mois = [
    'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
    'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc',
  ];

  static String formaterDate(DateTime date) {
    final j = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$j/$m/${date.year}';
  }

  static String formaterDateHeure(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '${formaterDate(date)} $h:$min';
  }

  static String formaterMoisAnnee(DateTime date) {
    return '${_mois[date.month - 1]} ${date.year}';
  }

  static bool estMoisCourant(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Retourne les n derniers mois (du plus ancien au plus récent)
  static List<DateTime> derniersMois(int n) {
    final now = DateTime.now();
    return List.generate(n, (i) => DateTime(now.year, now.month - (n - 1 - i), 1));
  }
}