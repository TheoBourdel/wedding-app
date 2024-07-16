class Log {
  final int id;
  final DateTime timestamp;
  final String method;
  final String path;
  final String clientIp;
  final int statusCode;
  final Duration duration;
  final String? errorMsg;

  Log({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.path,
    required this.clientIp,
    required this.statusCode,
    required this.duration,
    this.errorMsg,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      method: json['method'],
      path: json['path'],
      clientIp: json['client_ip'],
      statusCode: json['status_code'],
      duration: Duration(milliseconds: json['duration']),
      errorMsg: json['error_msg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'method': method,
      'path': path,
      'client_ip': clientIp,
      'status_code': statusCode,
      'duration': duration.inMilliseconds,
      'error_msg': errorMsg,
    };
  }
}
