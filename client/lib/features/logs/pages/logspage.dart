import 'package:client/features/logs/pages/logWidgetItem.dart';
import 'package:client/model/Log.dart';
import 'package:client/repository/log_repository.dart';
import 'package:flutter/material.dart';


class LogsPage extends StatelessWidget {
  const LogsPage({Key? key}) : super(key: key);

  Future<List<Log>> fetchLogs() async {
    final logs = await LogRepository().getLogs();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
      ),
      body: FutureBuilder<List<Log>>(
        future: fetchLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No logs available'));
          } else {
            final logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return LogItemWidget(log: logs[index]);
              },
            );
          }
        },
      ),
    );
  }
}
