class ApiResponse {
  final String message;
  final dynamic data;
  final bool success;

  ApiResponse({required this.message, this.data, this.success = false});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      data: json['data'],
      success: json['data'] != null,
    );
  }
}