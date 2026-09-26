import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/domain/validators/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators', () {
    test('email', () {
      expect(AuthValidators.email(''), isNotNull);
      expect(AuthValidators.email('awa@'), isNotNull);
      expect(AuthValidators.email(' awa.konan@exemple.com '), isNull);
    });

    test('mot de passe : 8 caractères minimum', () {
      expect(AuthValidators.newPassword('1234567'), isNotNull);
      expect(AuthValidators.newPassword('12345678'), isNull);
    });

    test('confirmation', () {
      expect(AuthValidators.confirmation('abc', 'abd'), isNotNull);
      expect(AuthValidators.confirmation('abc', 'abc'), isNull);
    });
  });

  test('PasswordStrength.evaluate', () {
    expect(PasswordStrength.evaluate(''), PasswordStrength.empty);
    expect(PasswordStrength.evaluate('abc'), PasswordStrength.weak);
    expect(PasswordStrength.evaluate('cinemaclub'), PasswordStrength.weak);
    expect(PasswordStrength.evaluate('CinemaClub'), PasswordStrength.fair);
    expect(PasswordStrength.evaluate('CinemaClub7'), PasswordStrength.good);
    expect(PasswordStrength.evaluate('CinemaClub7!'), PasswordStrength.strong);
  });

  test('AppUser : prénom et initiales', () {
    const user = AppUser(id: '1', email: 'awa@x.com', fullName: 'Awa Konan');
    expect(user.firstName, 'Awa');
    expect(user.initials, 'AK');
    const anonymous = AppUser(id: '2', email: 'jean.dupont@x.com');
    expect(anonymous.initials, 'JD');
  });
}
