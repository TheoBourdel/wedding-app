import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/model/Log.dart';

class LogItemWidget extends StatelessWidget {
  final Log log;

  const LogItemWidget({Key? key, required this.log}) : super(key: key);

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blue; // Parfois, les codes 300 sont associés à des redirections réussies
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orange;
    } else if (statusCode >= 500) {
      return Colors.red;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            log.method,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(log.method),
              Text(
                log.statusCode.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(log.statusCode),
                ),
              ),
              Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(log.path),
          const SizedBox(height: 5),
          Text(log.clientIp),
        ],
      ),
    );
  }
}
