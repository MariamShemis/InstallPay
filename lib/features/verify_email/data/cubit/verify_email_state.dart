
abstract class VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailLoading extends VerifyEmailState {}

class VerifyEmailChecking extends VerifyEmailState {}

class VerifyEmailSent extends VerifyEmailState {}

class VerifyEmailVerified extends VerifyEmailState {}

class VerifyEmailNotVerified extends VerifyEmailState {}

class VerifyEmailError extends VerifyEmailState {
  final String message;

  VerifyEmailError(this.message);
}