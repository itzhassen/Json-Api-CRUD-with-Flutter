import 'package:flutter/material.dart';
import 'user.dart'; // Import the User class
import 'display_page.dart'; // Import the DisplayPage widget
import 'globals.dart'; // Import the global variables
import 'data_manager.dart'; // Import the DataManager class

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding.

  final loadedUsers = await DataManager().loadUserData();

  if (loadedUsers != null) {
    globalUsers = loadedUsers;
    User.adjustNextId(globalUsers);
  } else {
    print('No user data loaded or an error occurred.');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String? civilite;
  String nom = "";
  String prenom = "";
  String? specialite;
  List<String> matieres = [];

  // Liste de matières en mémoire (à remplir selon vos besoins)
  List<String> matieresEnMemoire = ["JAVA", "C#", "Flutter", "ReactJs"];
  List<String> specialitesEnMemoire = ["DSI", "MDW"];
  User? editingUser; // Track the user being edited

  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription '),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ["M.", "Mme"].map<Widget>((String value) {
                return Row(
                  children: [
                    Radio<String>(
                      value: value,
                      groupValue: civilite,
                      onChanged: (String? newValue) {
                        setState(() {
                          civilite = newValue;
                        });
                      },
                    ),
                    Text(value),
                  ],
                );
              }).toList(),
            ),
            TextFormField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom'),
              onChanged: (value) {
                setState(() {
                  nom = value;
                });
              },
            ),
            TextFormField(
              controller: prenomController,
              decoration: InputDecoration(labelText: 'Prénom'),
              onChanged: (value) {
                setState(() {
                  prenom = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: specialite,
              decoration: InputDecoration(labelText: 'Spécialité'),
              onChanged: (String? value) {
                setState(() {
                  specialite = value; // Update the 'specialite' variable
                });
              },
              items: specialitesEnMemoire.map((String specialite) {
                return DropdownMenuItem<String>(
                  value: specialite,
                  child: Text(specialite),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Sélectionnez les matières :'),
            Column(
              children: matieresEnMemoire.map((String matiere) {
                return CheckboxListTile(
                  title: Text(matiere),
                  value: matieres.contains(matiere),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          matieres.add(matiere);
                        } else {
                          matieres.remove(matiere);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (editingUser == null) {
                  // Create a User object
                  User newUser = User.createNewUser(
                    civilite: civilite,
                    nom: nom,
                    prenom: prenom,
                    specialite: specialite,
                    matieres: List<String>.from(matieres),
                  );
                  // Create a new user
                  globalUsers.add(newUser);
                  await DataManager().saveUserData(newUser);
                } else {
                  User newUser = User(
                    id: editingUser!.id,
                    civilite: civilite,
                    nom: nom,
                    prenom: prenom,
                    specialite: specialite,
                    matieres: List<String>.from(matieres),
                  );
                  // Update the existing user
                  int index = globalUsers.indexOf(editingUser!);
                  globalUsers[index] = newUser;
                  editingUser = null; // Reset editing state
                  await DataManager().editUser(newUser.id,newUser);
                }
                // Clear the form fields
                setState(() {
                  civilite = null;
                  nom = "";
                  prenom = "";
                  specialite = null;
                  matieres.clear();
                  nomController.clear();
                  prenomController.clear();
                });
              },
              child: Text(editingUser == null ? 'Enregistrer' : 'Modifier'),

            ),

            ElevatedButton(
              onPressed: () {
                // Navigate to the DisplayPage and pass the globalUsers list
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPage(
                      globalUsers,
                      onEdit: (user) {
                        // Set the user for editing when Edit is pressed in DisplayPage
                        setState(() {
                          editingUser = user;
                          civilite = user.civilite;
                          nom = user.nom;
                          prenom = user.prenom;
                          specialite = user.specialite;
                          matieres = List<String>.from(user.matieres);
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Afficher Utilisateurs'),
            ),
          ],
        ),
      ),
    );
  }
}