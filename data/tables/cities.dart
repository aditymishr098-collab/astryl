/// A city to see the sky from. Only latitude and longitude are used. The
/// list needs no permission; "my location" asks for the approximate location.
class City {
  const City(this.id, this.name, this.country, this.lat, this.lon);

  final String id;
  final String name;
  final String country;

  /// Degrees, north positive.
  final double lat;

  /// Degrees, east positive.
  final double lon;
}

const List<City> cities = <City>[
  // Armenia and the Caucasus
  City('yerevan', 'Yerevan', 'Armenia', 40.18, 44.51),
  City('gyumri', 'Gyumri', 'Armenia', 40.79, 43.85),
  City('vanadzor', 'Vanadzor', 'Armenia', 40.81, 44.49),
  City('tbilisi', 'Tbilisi', 'Georgia', 41.72, 44.79),
  City('baku', 'Baku', 'Azerbaijan', 40.41, 49.87),
  // India
  City('delhi', 'Delhi', 'India', 28.61, 77.21),
  City('mumbai', 'Mumbai', 'India', 19.08, 72.88),
  City('kolkata', 'Kolkata', 'India', 22.57, 88.36),
  City('chennai', 'Chennai', 'India', 13.08, 80.27),
  City('bengaluru', 'Bengaluru', 'India', 12.97, 77.59),
  City('hyderabad', 'Hyderabad', 'India', 17.39, 78.49),
  City('ahmedabad', 'Ahmedabad', 'India', 23.02, 72.57),
  City('pune', 'Pune', 'India', 18.52, 73.86),
  City('jaipur', 'Jaipur', 'India', 26.91, 75.79),
  City('lucknow', 'Lucknow', 'India', 26.85, 80.95),
  City('kanpur', 'Kanpur', 'India', 26.45, 80.33),
  City('patna', 'Patna', 'India', 25.59, 85.14),
  City('varanasi', 'Varanasi', 'India', 25.32, 82.97),
  City('prayagraj', 'Prayagraj', 'India', 25.44, 81.85),
  City('bhopal', 'Bhopal', 'India', 23.26, 77.41),
  City('indore', 'Indore', 'India', 22.72, 75.86),
  City('nagpur', 'Nagpur', 'India', 21.15, 79.09),
  City('surat', 'Surat', 'India', 21.17, 72.83),
  City('chandigarh', 'Chandigarh', 'India', 30.73, 76.78),
  City('amritsar', 'Amritsar', 'India', 31.63, 74.87),
  City('dehradun', 'Dehradun', 'India', 30.32, 78.03),
  City('guwahati', 'Guwahati', 'India', 26.14, 91.74),
  City('bhubaneswar', 'Bhubaneswar', 'India', 20.30, 85.82),
  City('ranchi', 'Ranchi', 'India', 23.34, 85.31),
  City('raipur', 'Raipur', 'India', 21.25, 81.63),
  City('kochi', 'Kochi', 'India', 9.93, 76.27),
  City('thiruvananthapuram', 'Thiruvananthapuram', 'India', 8.52, 76.94),
  City('srinagar', 'Srinagar', 'India', 34.08, 74.80),
  // South Asia
  City('kathmandu', 'Kathmandu', 'Nepal', 27.72, 85.32),
  City('dhaka', 'Dhaka', 'Bangladesh', 23.81, 90.41),
  City('karachi', 'Karachi', 'Pakistan', 24.86, 67.01),
  City('lahore', 'Lahore', 'Pakistan', 31.55, 74.34),
  City('islamabad', 'Islamabad', 'Pakistan', 33.68, 73.05),
  City('colombo', 'Colombo', 'Sri Lanka', 6.93, 79.86),
  // Middle East and Central Asia
  City('dubai', 'Dubai', 'UAE', 25.20, 55.27),
  City('abu-dhabi', 'Abu Dhabi', 'UAE', 24.45, 54.38),
  City('riyadh', 'Riyadh', 'Saudi Arabia', 24.71, 46.68),
  City('jeddah', 'Jeddah', 'Saudi Arabia', 21.49, 39.19),
  City('doha', 'Doha', 'Qatar', 25.29, 51.53),
  City('muscat', 'Muscat', 'Oman', 23.59, 58.41),
  City('tehran', 'Tehran', 'Iran', 35.69, 51.39),
  City('baghdad', 'Baghdad', 'Iraq', 33.32, 44.37),
  City('istanbul', 'Istanbul', 'Türkiye', 41.01, 28.98),
  City('ankara', 'Ankara', 'Türkiye', 39.93, 32.86),
  City('tashkent', 'Tashkent', 'Uzbekistan', 41.30, 69.24),
  City('almaty', 'Almaty', 'Kazakhstan', 43.24, 76.89),
  // Europe
  City('moscow', 'Moscow', 'Russia', 55.76, 37.62),
  City('saint-petersburg', 'Saint Petersburg', 'Russia', 59.94, 30.31),
  City('kyiv', 'Kyiv', 'Ukraine', 50.45, 30.52),
  City('warsaw', 'Warsaw', 'Poland', 52.23, 21.01),
  City('berlin', 'Berlin', 'Germany', 52.52, 13.40),
  City('london', 'London', 'United Kingdom', 51.51, -0.13),
  City('paris', 'Paris', 'France', 48.86, 2.35),
  City('madrid', 'Madrid', 'Spain', 40.42, -3.70),
  City('lisbon', 'Lisbon', 'Portugal', 38.72, -9.14),
  City('rome', 'Rome', 'Italy', 41.90, 12.50),
  City('amsterdam', 'Amsterdam', 'Netherlands', 52.37, 4.90),
  City('athens', 'Athens', 'Greece', 37.98, 23.73),
  City('stockholm', 'Stockholm', 'Sweden', 59.33, 18.07),
  // Africa
  City('cairo', 'Cairo', 'Egypt', 30.04, 31.24),
  City('casablanca', 'Casablanca', 'Morocco', 33.57, -7.59),
  City('lagos', 'Lagos', 'Nigeria', 6.52, 3.38),
  City('nairobi', 'Nairobi', 'Kenya', -1.29, 36.82),
  City('addis-ababa', 'Addis Ababa', 'Ethiopia', 9.03, 38.74),
  City('johannesburg', 'Johannesburg', 'South Africa', -26.20, 28.05),
  City('cape-town', 'Cape Town', 'South Africa', -33.92, 18.42),
  // East and Southeast Asia
  City('beijing', 'Beijing', 'China', 39.90, 116.41),
  City('shanghai', 'Shanghai', 'China', 31.23, 121.47),
  City('hong-kong', 'Hong Kong', 'China', 22.32, 114.17),
  City('tokyo', 'Tokyo', 'Japan', 35.68, 139.69),
  City('osaka', 'Osaka', 'Japan', 34.69, 135.50),
  City('seoul', 'Seoul', 'South Korea', 37.57, 126.98),
  City('singapore', 'Singapore', 'Singapore', 1.35, 103.82),
  City('bangkok', 'Bangkok', 'Thailand', 13.76, 100.50),
  City('kuala-lumpur', 'Kuala Lumpur', 'Malaysia', 3.14, 101.69),
  City('jakarta', 'Jakarta', 'Indonesia', -6.21, 106.85),
  City('manila', 'Manila', 'Philippines', 14.60, 120.98),
  City('hanoi', 'Hanoi', 'Vietnam', 21.03, 105.85),
  // Americas
  City('new-york', 'New York', 'United States', 40.71, -74.01),
  City('los-angeles', 'Los Angeles', 'United States', 34.05, -118.24),
  City('chicago', 'Chicago', 'United States', 41.88, -87.63),
  City('houston', 'Houston', 'United States', 29.76, -95.37),
  City('toronto', 'Toronto', 'Canada', 43.65, -79.38),
  City('vancouver', 'Vancouver', 'Canada', 49.28, -123.12),
  City('mexico-city', 'Mexico City', 'Mexico', 19.43, -99.13),
  City('bogota', 'Bogotá', 'Colombia', 4.71, -74.07),
  City('lima', 'Lima', 'Peru', -12.05, -77.04),
  City('sao-paulo', 'São Paulo', 'Brazil', -23.55, -46.63),
  City('rio-de-janeiro', 'Rio de Janeiro', 'Brazil', -22.91, -43.17),
  City('buenos-aires', 'Buenos Aires', 'Argentina', -34.60, -58.38),
  City('santiago', 'Santiago', 'Chile', -33.45, -70.67),
  // Oceania
  City('sydney', 'Sydney', 'Australia', -33.87, 151.21),
  City('melbourne', 'Melbourne', 'Australia', -37.81, 144.96),
  City('perth', 'Perth', 'Australia', -31.95, 115.86),
  City('auckland', 'Auckland', 'New Zealand', -36.85, 174.76),
];

/// The id of the "my location" city made from the phone's location.
const String gpsCityId = 'gps';

City? _myLocation;

/// Sets (or, with null, clears) the place the phone found. It is what
/// [cityById] answers for [gpsCityId].
void setMyLocation(double? lat, double? lon) {
  _myLocation = lat == null || lon == null
      ? null
      : City(gpsCityId, 'My location', '', lat, lon);
}

/// The id of a place picked from the world city list.
const String placeCityId = 'place';

City? _place;

/// Sets (or clears) the place picked from the world list, which is what
/// [cityById] answers for [placeCityId].
void setPlace(String? name, double? lat, double? lon) {
  _place = name == null || lat == null || lon == null ? null : City(placeCityId, name, '', lat, lon);
}

/// The city with [id], or null.
City? cityById(String id) {
  if (id == gpsCityId) {
    return _myLocation;
  }
  if (id == placeCityId) {
    return _place;
  }
  for (final city in cities) {
    if (city.id == id) {
      return city;
    }
  }
  return null;
}
