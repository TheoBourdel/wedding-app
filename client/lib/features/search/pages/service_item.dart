import 'package:client/features/service/widgets/details/service_detail.dart';
import 'package:flutter/material.dart';
import 'package:client/model/service.dart';

class ServiceListItem extends StatelessWidget {
  final Service service;

  const ServiceListItem({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: service.profileImage != null && service.profileImage!.isNotEmpty
              ? NetworkImage(service.profileImage!)
              : AssetImage('assets/default_service_image.png') as ImageProvider, // Replace with your default image asset
        ),
        title: Text(service.name ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${service.id}'),
            Text(service.description ?? 'No Description'),
            Text('Price: ${service.price}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ServiceDetail(service: service),
          ));
        },
      ),
    );
  }
}
