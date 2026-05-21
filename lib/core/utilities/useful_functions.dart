String formatNumber(num n) {
  if (n < 0) {
    return '-${formatNumber(-n)}';
  } else if (n >= 999995000000) {
    return '${(n / 1000000000000).toStringAsFixed(2)}T';
  } else if (n >= 999995000) {
    return '${(n / 1000000000).toStringAsFixed(2)}B';
  } else if (n >= 999995) {
    return '${(n / 1000000).toStringAsFixed(2)}M';
  } else if (n >= 1000) {
    return '${(n / 1000).toStringAsFixed(2)}K';
  } else {
    return n.toString();
  }
}

int temperatureKToC(double kelvin) {
  return (kelvin - 273.15).round();
}
