import 'package:flutter/material.dart';
import 'package:client/model/user.dart';
import 'package:client/services/user_service.dart';
import 'package:flutter/services.dart'; // Import pour utiliser le presse-papiers

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> futureUsers;
  int currentPage = 1;
  int pageSize = 10;
  String query = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() {
    setState(() {
      futureUsers = UserService().fetchUsers(page: currentPage, pageSize: pageSize, query: query);
    });
  }

  Future<void> _deleteUser(int id) async {
    try {
      await UserService().deleteUser(id);
      fetchUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression: $e'),
        ),
      );
    }
  }

  void _searchUser(String value) {
    setState(() {
      query = value;
      currentPage = 1;
      fetchUsers();
    });
  }

  void _nextPage() {
    setState(() {
      currentPage++;
      fetchUsers();
    });
  }

  void _previousPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage--;
        fetchUsers();
      }
    });
  }

  Future<void> _createUser() async {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    String selectedRole = 'admin';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouvel utilisateur'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                  ),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de famille',
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                DropdownButton<String>(
                  value: selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue!;
                    });
                  },
                  items: <String>['admin', 'marry', 'provider']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Créer'),
              onPressed: () async {
                try {
                  // Créez l'utilisateur sans générer le mot de passe côté client
                  final newUser = await UserService().createUser(
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    selectedRole,
                  );
                  fetchUsers();
                  Navigator.of(context).pop();
                  _showPasswordDialog(newUser.password);  // Afficher le mot de passe généré
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la création: $e'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialog(String password) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Utilisateur créé avec succès'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Mot de passe généré :'),
                Text(
                  password,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Copier le mot de passe'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: password));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mot de passe copié dans le presse-papiers'),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createUser,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchUser,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun utilisateur trouvé'));
                } else {
                  List<User> users = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text('${user.firstName ?? ''} ${user.lastName ?? ''}'),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(user.role),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _previousPage,
                child: const Text('Précédent'),
              ),
              TextButton(
                onPressed: _nextPage,
                child: const Text('Suivant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
