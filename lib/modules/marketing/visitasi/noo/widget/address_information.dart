import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:uapp/modules/marketing/api/wilayah_service.dart';

class AddressInformation extends StatefulWidget {
  final String title;
  final NooAddressModel? addressModel;
  final String? Function(String?)? addressValidator;
  final String? Function(String?)? rtRwValidator;
  final String? Function(String?)? propinsiValidator;
  final String? Function(String?)? kabKotaValidator;
  final String? Function(String?)? kecamatanValidator;
  final String? Function(String?)? desaKelurahanValidator;
  final String? Function(String?)? kodePosValidator;

  const AddressInformation({
    super.key,
    required this.title,
    this.addressModel,
    this.addressValidator,
    this.rtRwValidator,
    this.propinsiValidator,
    this.kabKotaValidator,
    this.kecamatanValidator,
    this.desaKelurahanValidator,
    this.kodePosValidator,
  });

  @override
  _AddressInformationState createState() => _AddressInformationState();
}

class _AddressInformationState extends State<AddressInformation> {
  late TextEditingController addressController;
  late TextEditingController rtRwController;
  late TextEditingController propinsiController;
  late TextEditingController kabKotaController;
  late TextEditingController kecamatanController;
  late TextEditingController desaKelurahanController;
  late TextEditingController kodePosController;

  final WilayahApiService _apiService = WilayahApiService();
  
  // State for provinces
  List<Province> _provinces = [];
  bool _loadingProvinces = false;
  Province? _selectedProvince;
  
  // State for regencies
  List<Regency> _regencies = [];
  bool _loadingRegencies = false;
  Regency? _selectedRegency;
  
  // State for districts
  List<District> _districts = [];
  bool _loadingDistricts = false;
  District? _selectedDistrict;
  
  // State for villages
  List<Village> _villages = [];
  bool _loadingVillages = false;
  Village? _selectedVillage;

  // Flag to indicate if we're in edit mode
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    // Determine if we're in edit mode by checking if an address model was provided with data
    _isEditMode = widget.addressModel != null && 
        ((widget.addressModel?.address?.isNotEmpty ?? false) ||
         (widget.addressModel?.provinsi?.isNotEmpty ?? false));
    
    String sanitize(String? value) {
      return (value == null || value == "null") ? '' : value;
    }
    // Initialize controllers with existing data
    addressController = TextEditingController(text: sanitize(widget.addressModel?.address));
    rtRwController = TextEditingController(text: sanitize(widget.addressModel?.rtRw));
    kodePosController = TextEditingController(text: sanitize(widget.addressModel?.kodePos));
    propinsiController = TextEditingController(text: sanitize(widget.addressModel?.provinsi));
    kabKotaController = TextEditingController(text: sanitize(widget.addressModel?.kabupatenKota));
    kecamatanController = TextEditingController(text: sanitize(widget.addressModel?.kecamatan));
    desaKelurahanController = TextEditingController(text: sanitize(widget.addressModel?.desaKelurahan));
    
    // Load provinces when widget initializes
    _loadProvinces();
  }

  void _loadProvinces() async {
    setState(() {
      _loadingProvinces = true;
    });
    
    try {
      final provinces = await _apiService.getProvinces();
      setState(() {
        _provinces = provinces;
        _loadingProvinces = false;

        if (_isEditMode && widget.addressModel?.provinsi != null && widget.addressModel!.provinsi!.isNotEmpty) {
          _findBestMatchingProvince(widget.addressModel!.provinsi!);
        }
      });
    } catch (e) {
      setState(() {
        _loadingProvinces = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data provinsi: $e')),
      );
    }
  }

void _findBestMatchingProvince(String provinceNameToFind) {
  final normalizedProvinceToFind = _normalizeString(provinceNameToFind);
  
  try {
    _selectedProvince = _provinces.firstWhere(
      (province) => _normalizeString(province.name) == normalizedProvinceToFind,
    );
    
    widget.addressModel?.provinsi = _selectedProvince?.name;
    propinsiController.text = _selectedProvince!.name;
    
    if (_selectedProvince != null) {
      _loadRegencies(_selectedProvince!.id);
    }
  } catch (e) {

    _selectedProvince = null;

    propinsiController.text = provinceNameToFind;
    
    print('No matching province found: $e');
  }
}

  void _loadRegencies(String provinceId) async {
    setState(() {
      _loadingRegencies = true;
      _regencies = [];
      _selectedRegency = null;
      _districts = [];
      _selectedDistrict = null;
      _villages = [];
      _selectedVillage = null;
    });
    
    try {
      final regencies = await _apiService.getRegencies(provinceId);
      setState(() {
        _regencies = regencies;
        _loadingRegencies = false;

        if (_isEditMode && widget.addressModel?.kabupatenKota != null && widget.addressModel!.kabupatenKota!.isNotEmpty) {
          _findBestMatchingRegency(widget.addressModel!.kabupatenKota!);
        }
      });
    } catch (e) {
      setState(() {
        _loadingRegencies = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kabupaten/kota: $e')),
      );
    }
  }

void _findBestMatchingRegency(String regencyNameToFind) {
  if (_regencies.isEmpty) return;
  
  final normalizedRegencyToFind = _normalizeString(regencyNameToFind);
  
  try {
    _selectedRegency = _regencies.firstWhere(
      (regency) => _normalizeString(regency.name) == normalizedRegencyToFind,
    );
    
    kabKotaController.text = _selectedRegency!.name;
    widget.addressModel?.kabupatenKota = _selectedRegency?.name;
    
    if (_selectedRegency != null) {
      _loadDistricts(_selectedRegency!.id);
    }
  } catch (e) {
    _selectedRegency = null;
    
    kabKotaController.text = regencyNameToFind;
    
    print('No matching regency found: $e');
  }
}
  void _loadDistricts(String regencyId) async {
    setState(() {
      _loadingDistricts = true;
      _districts = [];
      _selectedDistrict = null;
      _villages = [];
      _selectedVillage = null;
    });
    
    try {
      final districts = await _apiService.getDistricts(regencyId);
      setState(() {
        _districts = districts;
        _loadingDistricts = false;

        if (_isEditMode && widget.addressModel?.kecamatan != null && widget.addressModel!.kecamatan!.isNotEmpty) {
          _findBestMatchingDistrict(widget.addressModel!.kecamatan!);
        }
      });
    } catch (e) {
      setState(() {
        _loadingDistricts = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kecamatan: $e')),
      );
    }
  }

  void _findBestMatchingDistrict(String districtNameToFind) {
  if (_districts.isEmpty) return;
  
  final normalizedDistrictToFind = _normalizeString(districtNameToFind);
  
  try {
    _selectedDistrict = _districts.firstWhere(
      (district) => _normalizeString(district.name) == normalizedDistrictToFind,
    );
  
    kecamatanController.text = _selectedDistrict!.name;
    widget.addressModel?.kecamatan = _selectedDistrict?.name;
    
    if (_selectedDistrict != null) {
      _loadVillages(_selectedDistrict!.id);
    }
  } catch (e) {
    _selectedDistrict = null;

    kecamatanController.text = districtNameToFind;
    
    print('No matching district found: $e');
  }
}

  void _loadVillages(String districtId) async {
    setState(() {
      _loadingVillages = true;
      _villages = [];
      _selectedVillage = null;
    });
    
    try {
      final villages = await _apiService.getVillages(districtId);
      setState(() {
        _villages = villages;
        _loadingVillages = false;

        if (_isEditMode && widget.addressModel?.desaKelurahan != null && widget.addressModel!.desaKelurahan!.isNotEmpty) {
          _findBestMatchingVillage(widget.addressModel!.desaKelurahan!);
        } 
      });
    } catch (e) {
      setState(() {
        _loadingVillages = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data desa/kelurahan: $e')),
      );
    }
  }

 void _findBestMatchingVillage(String villageNameToFind) {
  if (_villages.isEmpty) return;
  
  final normalizedVillageToFind = _normalizeString(villageNameToFind);
  
  try {
    _selectedVillage = _villages.firstWhere(
      (village) => _normalizeString(village.name) == normalizedVillageToFind,
    );
    
    desaKelurahanController.text = _selectedVillage!.name;
    widget.addressModel?.desaKelurahan = _selectedVillage?.name;
  } catch (e) {
    _selectedVillage = null;
    
    desaKelurahanController.text = villageNameToFind;
    
    print('No matching village found: $e');
  }
}

  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s]'), '');
  }

  @override
  void dispose() {
    addressController.dispose();
    rtRwController.dispose();
    kodePosController.dispose();
    propinsiController.dispose();
    kabKotaController.dispose();
    kecamatanController.dispose();
    desaKelurahanController.dispose();
    super.dispose();
  }

  @override
 Widget build(BuildContext context) {
  return ExpansionTile(
    title: Text(widget.title),
    leading: const Icon(Icons.location_on),
    expandedAlignment: Alignment.topLeft,
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    initiallyExpanded: true,
    children: [
      const SizedBox(height: 4),
      Text(
        'Alamat:',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      AppTextField(
        controller: addressController,
        hintText: 'Nama Jalan',
        validator: widget.addressValidator,
        onChanged: (value) {
          setState(() {
            widget.addressModel?.address = value.toUpperCase();
          });
        },
      ),
      const SizedBox(height: 16),
      Text(
        'RT/RW:',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      AppTextField(
        controller: rtRwController,
        hintText: 'RT/RW',
        validator: widget.rtRwValidator,
        onChanged: (value) {
          setState(() {
            widget.addressModel?.rtRw = value;
          });
        },
      ),
      const SizedBox(height: 16),
      Text(
        'Provinsi:',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      _buildProvinceDropdown(),
      const SizedBox(height: 16),
      Text(
        'Kabupaten/Kota:',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      _buildRegencyDropdown(),
      const SizedBox(height: 16),
      Text(
        'Kecamatan:',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      _buildDistrictDropdown(),
      const SizedBox(height: 16),
      Text(
        'Desa/Kelurahan:',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      _buildVillageDropdown(),
      const SizedBox(height: 16),
      Text(
        'Kode Pos:',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      AppTextField(
        controller: kodePosController,
        hintText: 'Kode Pos',
        validator: widget.kodePosValidator,
        onChanged: (value) {
          setState(() {
            widget.addressModel?.kodePos = value;
          });
        },
      ),
    ],
  );
}

 Widget _buildProvinceDropdown() {
  return _loadingProvinces
      ? const Center(child: CircularProgressIndicator())
      : DropdownSearch<Province>(
          items: _provinces,
          selectedItem: _selectedProvince,
          itemAsString: (Province? province) => province?.name ?? '',
          onChanged: (Province? province) {
            setState(() {
              _selectedProvince = province;
              widget.addressModel?.provinsi = province?.name;
              propinsiController.text = province?.name ?? '';
              
              widget.addressModel?.kabupatenKota = null;
              widget.addressModel?.kecamatan = null;
              widget.addressModel?.desaKelurahan = null;
              
              kabKotaController.clear();
              
              if (province != null) {
                _loadRegencies(province.id);
              }
            });
          },
          validator: (Province? province) {
            if (province == null && widget.propinsiValidator != null) {
              return widget.propinsiValidator!('');
            }
            return null;
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              
              hintText: _selectedProvince == null && propinsiController.text.isNotEmpty 
                  ? propinsiController.text  
                  : 'Pilih Provinsi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Cari Provinsi',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
        );
}

Widget _buildRegencyDropdown() {
  return _loadingRegencies
      ? const Center(child: CircularProgressIndicator())
      : DropdownSearch<Regency>(
          items: _regencies,
          selectedItem: _selectedRegency,
          itemAsString: (Regency? regency) => regency?.name ?? '',
          onChanged: (Regency? regency) {
            setState(() {
              _selectedRegency = regency;
              widget.addressModel?.kabupatenKota = regency?.name;
              kabKotaController.text = regency?.name ?? '';
              
              // Reset dependent fields
              widget.addressModel?.kecamatan = null;
              widget.addressModel?.desaKelurahan = null;
              
              // Clear controllers for dependent fields
              kecamatanController.clear();
              
              if (regency != null) {
                _loadDistricts(regency.id);
              }
            });
          },
          validator: (Regency? regency) {
            if (regency == null && widget.kabKotaValidator != null) {
              return widget.kabKotaValidator!('');
            }
            return null;
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              // Use the existing text as hint if no match was found
              hintText: _selectedRegency == null && kabKotaController.text.isNotEmpty 
                  ? kabKotaController.text  // Show the previous value as hint
                  : 'Pilih Kabupaten/Kota',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Cari Kabupaten/Kota',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
          enabled: _selectedProvince != null,
        );
}

Widget _buildDistrictDropdown() {
  return _loadingDistricts
      ? const Center(child: CircularProgressIndicator())
      : DropdownSearch<District>(
          items: _districts,
          selectedItem: _selectedDistrict,
          itemAsString: (District? district) => district?.name ?? '',
          onChanged: (District? district) {
            setState(() {
              _selectedDistrict = district;
              widget.addressModel?.kecamatan = district?.name;
              kecamatanController.text = district?.name ?? '';
              
              // Reset dependent field
              widget.addressModel?.desaKelurahan = null;
              
              // Clear controller for dependent field
              desaKelurahanController.clear();
              
              if (district != null) {
                _loadVillages(district.id);
              }
            });
          },
          validator: (District? district) {
            if (district == null && widget.kecamatanValidator != null) {
              return widget.kecamatanValidator!('');
            }
            return null;
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              // Use the existing text as hint if no match was found
              hintText: _selectedDistrict == null && kecamatanController.text.isNotEmpty 
                  ? kecamatanController.text  // Show the previous value as hint
                  : 'Pilih Kecamatan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Cari Kecamatan',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
          enabled: _selectedRegency != null,
        );
}

Widget _buildVillageDropdown() {
  return _loadingVillages
      ? const Center(child: CircularProgressIndicator())
      : DropdownSearch<Village>(
          items: _villages,
          selectedItem: _selectedVillage,
          itemAsString: (Village? village) => village?.name ?? '',
          onChanged: (Village? village) {
            setState(() {
              _selectedVillage = village;
              widget.addressModel?.desaKelurahan = village?.name;
              desaKelurahanController.text = village?.name ?? '';
            });
          },
          validator: (Village? village) {
            if (village == null && widget.desaKelurahanValidator != null) {
              return widget.desaKelurahanValidator!('');
            }
            return null;
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              // Use the existing text as hint if no match was found
              hintText: _selectedVillage == null && desaKelurahanController.text.isNotEmpty 
                  ? desaKelurahanController.text  // Show the previous value as hint
                  : 'Pilih Desa/Kelurahan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Cari Kelurahan',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
          enabled: _selectedDistrict != null,
        );
  }
}