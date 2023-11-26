import 'package:flutter/material.dart';
import 'user.dart'; // Import the User class
import 'data_manager.dart'; // Import the DataManager class

class DisplayPage extends StatefulWidget {
  final List<User> users;
  final Function(User user) onEdit;
  DisplayPage(this.users, {required this.onEdit});

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  final DataManager _dataManager = DataManager();

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                // Delete the user from the server
                try {
                  await _dataManager.deleteUser(widget.users[index].id as String);
                } catch (e) {
                  print('Error deleting user: $e');
                  // Handle error, show a message, etc.
                }

                // Remove the user from the local list
                setState(() {
                  widget.users.removeAt(index);
                });

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _editUser(User user) {
    // Trigger the onEdit callback to edit the user in the main form
    widget.onEdit(user);

    // Navigate back to the main form
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          User user = widget.users[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Name: ${user.nom} ${user.prenom}'),
              subtitle: Text('Gender: ${user.civilite}, Specialization: ${user.specialite}'),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Edit the selected user
                      _editUser(user);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Show the delete confirmation dialog
                      _showDeleteConfirmationDialog(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
