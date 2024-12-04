String sensorNameToUnit(String name) {
  switch (name.toLowerCase()) {
    case 'temperature':
      return '°C';

    case 'humidity':
      return '%';

    case 'pressure':
      return 'hPa';

    case 'pm25':
    case 'pm10':
      return 'μg/m3';

    case 'co2':
      return 'ppm';

    case 'no2':
    case 'o3':
      return 'ppb';

    case 'noise':
    case 'noise_dba':
      return 'dBa';

    default:
      return '';
  }
}
