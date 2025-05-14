const invoiceTable = '''
CREATE TABLE IF NOT EXISTS invoice (
    Transaksi TEXT,      
    Grp_Customer TEXT,    
    Group_ TEXT,         
    Kode_Sales TEXT,      
    Nama_Sales TEXT,     
    Kode_Customer TEXT,   
    Nama_Customer TEXT,  
    Tipe_Transaksi TEXT,  
    Nomor_Invoice TEXT,  
    Nomor_Faktur TEXT,   
    Tanggal_Invoice TEXT, 
    Jatuh_Tempo TEXT,     
    Umur_Piutang TEXT,    
    Nilai_Invoice TEXT,   
    Pajak TEXT,           
    Pembayaran TEXT,      
    Sisa_piutang TEXT     
);
''';

const masterNooTable = '''
CREATE TABLE IF NOT EXISTS masternoo (
    id TEXT PRIMARY KEY,
    group_cust TEXT,
    credit_limit TEXT,
    payment_method TEXT,
    termin TEXT,
    jaminan TEXT,
    nilai_jaminan TEXT,
    nama_perusahaan TEXT,
    id_cust TEXT,
    area_marketing TEXT,
    tgl_join TEXT,
    spv_uci TEXT,
    asm_uci TEXT,
    nama_owner TEXT,
    id_owner TEXT,
    age_gender_owner TEXT,
    nohp_owner TEXT,
    email_owner TEXT,
    alamat_owner TEXT,
    alamat_kantor TEXT,
    nama_jabatan_keuangan TEXT,
    nohp_keuangan TEXT,
    web_email_keuangan TEXT,
    nama_jabatan_penjualan TEXT,
    nohp_penjualan TEXT,
    web_email_penjualan TEXT,
    alamat_gudang TEXT,
    nama_pic_jabatan TEXT,
    nohp_pic TEXT,
    ownership_toko TEXT,
    ownership_gudang TEXT,
    ownership_rumah TEXT,
    luas_toko TEXT,
    luas_gudang TEXT,
    status_pajak TEXT,
    nama_npwp TEXT,
    no_npwp TEXT,
    alamat_npwp TEXT,
    nama_bank TEXT,
    no_rek_va TEXT,
    nama_rek TEXT,
    cabang_bank TEXT,
    bidang_usaha TEXT,
    tgl_mulai_usaha TEXT,
    produk_utama TEXT,
    produk_lain TEXT,
    lima_cust_utama TEXT,
    est_omset_month TEXT,
    status_sync INTEGER DEFAULT 0
);
''';
const masterNooUpdateTable = '''
CREATE TABLE IF NOT EXISTS masternooupdate (
    id TEXT PRIMARY KEY,
    id_noo TEXT,
    group_cust TEXT,
    credit_limit TEXT,
    payment_method TEXT,
    termin TEXT,
    jaminan TEXT,
    nilai_jaminan TEXT,
    nama_perusahaan TEXT,
    id_cust TEXT,
    area_marketing TEXT,
    tgl_join TEXT,
    spv_uci TEXT,
    asm_uci TEXT,
    nama_owner TEXT,
    id_owner TEXT,
    age_gender_owner TEXT,
    nohp_owner TEXT,
    email_owner TEXT,
    alamat_owner TEXT,
    alamat_kantor TEXT,
    nama_jabatan_keuangan TEXT,
    nohp_keuangan TEXT,
    web_email_keuangan TEXT,
    nama_jabatan_penjualan TEXT,
    nohp_penjualan TEXT,
    web_email_penjualan TEXT,
    alamat_gudang TEXT,
    nama_pic_jabatan TEXT,
    nohp_pic TEXT,
    ownership_toko TEXT,
    ownership_gudang TEXT,
    ownership_rumah TEXT,
    luas_toko TEXT,
    luas_gudang TEXT,
    status_pajak TEXT,
    nama_npwp TEXT,
    no_npwp TEXT,
    alamat_npwp TEXT,
    nama_bank TEXT,
    no_rek_va TEXT,
    nama_rek TEXT,
    cabang_bank TEXT,
    bidang_usaha TEXT,
    tgl_mulai_usaha TEXT,
    produk_utama TEXT,
    produk_lain TEXT,
    lima_cust_utama TEXT,
    est_omset_month TEXT,
    status_sync INTEGER DEFAULT 0
);
''';

const ttdNooTable = '''
CREATE TABLE IF NOT EXISTS noottd (
    id TEXT PRIMARY KEY,
    id_noo TEXT,
    customer TEXT,
    sales_spv TEXT,
    asm TEXT,
    nsm TEXT,
    direktur TEXT,
    customer_sign TEXT,
    sales_spv_sign TEXT,
    asm_sign TEXT,
    nsm_sign TEXT,
    direktur_sign TEXT,
    customer_date TEXT,
    sales_spv_date TEXT,
    asm_date TEXT,
    nsm_date TEXT,
    direktur_date TEXT
);
''';

const nooAddressTable = '''
CREATE TABLE IF NOT EXISTS nooaddress (
    id TEXT PRIMARY KEY,
    id_noo TEXT,
    address TEXT,
    rt_rw TEXT,
    desa_kelurahan TEXT,
    kecamatan TEXT,
    kabupaten_kota TEXT,
    provinsi TEXT,
    kode_pos TEXT
);
''';

const nooDocumentTable = '''
CREATE TABLE IF NOT EXISTS noodocument (
    id TEXT PRIMARY KEY,
    id_noo TEXT,
    ktp TEXT,
    npwp TEXT,
    owner_pic TEXT,
    outlet TEXT,
    warehouse TEXT,
    siup TEXT,
    tdp TEXT,
    surat_kerjasama TEXT,
    surat_penunjukan_distributor TEXT,
    surat_domisili_usaha TEXT,
    surat_penerbitan_bank TEXT,
    surat_bank_garansi TEXT,
    akta_pendirian TEXT,
    company_profile TEXT
);
''';

const nooSpesimenTable = '''
CREATE TABLE IF NOT EXISTS noospesimen (
    id TEXT PRIMARY KEY,
    id_noo TEXT,
    nama TEXT,
    jabatan TEXT,
    nohp TEXT,
    ttd TEXT,
    stempel TEXT
);
''';

const canvasingTable = '''
CREATE TABLE IF NOT EXISTS canvasing (
  CustID TEXT PRIMARY KEY,
  nama_outlet TEXT,
  nama_owner TEXT,
  no_hp TEXT,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  alamat TEXT,
  image_path TEXT,
  pembayaran int,
  status_sync INTEGER DEFAULT 0
)
''';

const mastergroupTable = '''
CREATE TABLE IF NOT EXISTS mastergroup (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cluster_kelompok TEXT NOT NULL,
  type TEXT NOT NULL,
  kode TEXT NOT NULL,
  nama_desc TEXT NOT NULL,
  singkatan TEXT NOT NULL,
  definisi TEXT NOT NULL,
  active INTEGER DEFAULT 1
)
''';

const deleteSevenDaysMarketingActivity = '''
DELETE FROM marketing_activity WHERE created_at < datetime('now', '-7 day') AND status_sync = 1;
''';