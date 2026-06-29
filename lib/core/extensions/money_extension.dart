extension MoneyExtension on num {
  String toMoney() {
    final cents = (this * 100).round();
    final absValue = cents.abs();
    final integer = absValue ~/ 100;
    final decimal = (absValue % 100).toString().padLeft(2, '0');
    final raw = integer.toString();
    final buffer = StringBuffer();

    for (var index = 0; index < raw.length; index++) {
      final reverseIndex = raw.length - index;
      buffer.write(raw[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    final sign = this < 0 ? '-' : '';
    return '${sign}R\$ ${buffer.toString()},$decimal';
  }
}
