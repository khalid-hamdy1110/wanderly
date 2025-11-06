String formatNumber(num n) {
  if (n >= 1000000000) {
    return '${(n / 1000000000).toStringAsFixed(1)}B';
  } else if (n >= 1000000) {
    return '${(n / 1000000).toStringAsFixed(1)}M';
  } else if (n >= 1000) {
    return '${(n / 1000).toStringAsFixed(1)}K';
  } else {
    return n.toString();
  }
}

int temperatureKToC(double kelvin) {
  return (kelvin - 273.15).round();
}
