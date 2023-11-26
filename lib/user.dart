class User {
  static int _nextId = 1;

  int id;
  String? civilite;
  String nom;
  String prenom;
  String? specialite;
  List<String> matieres;

  User({
    required this.id,
    this.civilite,
    required this.nom,
    required this.prenom,
    this.specialite,
    required this.matieres,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      civilite: json['civilite'],
      nom: json['nom'],
      prenom: json['prenom'],
      specialite: json['specialite'],
      matieres: List<String>.from(json['matieres']),
    );
  }

  @override
  String toString() {
    return 'User{id: $id, civilite: $civilite, nom: $nom, prenom: $prenom, specialite: $specialite, matieres: $matieres}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'civilite': civilite,
      'nom': nom,
      'prenom': prenom,
      'specialite': specialite,
      'matieres': matieres,
    };
  }

  static User createNewUser({
    String? civilite,
    required String nom,
    required String prenom,
    String? specialite,
    required List<String> matieres,
  }) {
    // Create a new user with the next available ID
    User newUser = User(
      id: _nextId,
      civilite: civilite,
      nom: nom,
      prenom: prenom,
      specialite: specialite,
      matieres: matieres,
    );

    // Increment the next available ID for the next user
    _nextId++;

    return newUser;
  }
  static void adjustNextId(List<User> users) {
    if (users.isNotEmpty) {
      // Find the maximum id value among the existing users
      int maxId = users.map((user) => user.id).reduce((value, element) => value > element ? value : element);

      // Set the nextId to be one greater than the maximum id
      _nextId = maxId + 1;
    }
  }
}
