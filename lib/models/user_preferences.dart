enum AppAppearance {
  calm('Calmo'),
  light('Claro'),
  dark('Escuro');

  const AppAppearance(this.label);

  final String label;
}

class UserPreferences {
  const UserPreferences({
    required this.displayName,
    required this.appearance,
  });

  final String displayName;
  final AppAppearance appearance;

  UserPreferences copyWith({
    String? displayName,
    AppAppearance? appearance,
  }) {
    return UserPreferences(
      displayName: displayName ?? this.displayName,
      appearance: appearance ?? this.appearance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'appearance': appearance.name,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      displayName: json['displayName'] as String? ?? '',
      appearance: AppAppearance.values.firstWhere(
        (value) => value.name == json['appearance'],
        orElse: () => AppAppearance.calm,
      ),
    );
  }
}
