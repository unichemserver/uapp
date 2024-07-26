class Custprod {
  final List<Customer> customers;
  final List<Product> products;

  Custprod({required this.customers, required this.products});

  factory Custprod.fromJson(Map<String, dynamic> json) {
    final customers = json['customer'].cast<Map<String, dynamic>>();
    final products = json['product'].cast<Map<String, dynamic>>();

    return Custprod(
      customers:
          customers.map<Customer>((json) => Customer.fromJson(json)).toList(),
      products:
          products.map<Product>((json) => Product.fromJson(json)).toList(),
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['CustID'],
      name: json['custname'],
      address: json['address'] ?? '',
    );
  }
}

class Product {
  final String id;
  final String name;

  Product({required this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['itemid'],
      name: json['description'],
    );
  }
}
