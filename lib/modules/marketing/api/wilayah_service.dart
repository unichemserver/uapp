import 'dart:convert';
import 'package:http/http.dart' as http;

class WilayahApiService {
  // Base URL for the API
  static const String baseUrl = 'https://www.emsifa.com/api-wilayah-indonesia/api';

  // Get all provinces
  Future<List<Province>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/provinces.json'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Province.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load provinces: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load provinces: $e');
    }
  }

  // Get regencies/cities by province ID
  Future<List<Regency>> getRegencies(String provinceId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/regencies/$provinceId.json'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Regency.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load regencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load regencies: $e');
    }
  }

  // Get districts by regency/city ID
  Future<List<District>> getDistricts(String regencyId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/districts/$regencyId.json'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => District.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load districts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load districts: $e');
    }
  }

  // Get villages by district ID
  Future<List<Village>> getVillages(String districtId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/villages/$districtId.json'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Village.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load villages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load villages: $e');
    }
  }
}

// Models
class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() => name;
}

class Regency {
  final String id;
  final String provinceId;
  final String name;

  Regency({required this.id, required this.provinceId, required this.name});

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      id: json['id'],
      provinceId: json['province_id'],
      name: json['name'],
    );
  }

  @override
  String toString() => name;
}

class District {
  final String id;
  final String regencyId;
  final String name;

  District({required this.id, required this.regencyId, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      regencyId: json['regency_id'],
      name: json['name'],
    );
  }

  @override
  String toString() => name;
}

class Village {
  final String id;
  final String districtId;
  final String name;

  Village({required this.id, required this.districtId, required this.name});

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'],
      districtId: json['district_id'],
      name: json['name'],
    );
  }

  @override
  String toString() => name;
}