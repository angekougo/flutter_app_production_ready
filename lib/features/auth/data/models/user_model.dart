import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.createdAt,
  });

  factory UserModel.fromSupabase(sb.User user) {
    final name = user.userMetadata?['full_name'];
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: name is String ? name : null,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }
}
