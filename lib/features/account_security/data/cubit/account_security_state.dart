abstract class AccountSecurityState {}

class AccountSecurityInitial extends AccountSecurityState {}

class AccountSecurityLoading extends AccountSecurityState {
  final String action;

  AccountSecurityLoading(this.action);
}

class AccountSecuritySuccess extends AccountSecurityState {
  final String action;

  AccountSecuritySuccess(this.action);
}

class AccountSecurityError extends AccountSecurityState {
  final String message;

  AccountSecurityError(this.message);
}

class BiometricStatusChanged extends AccountSecurityState {
  final bool enabled;

  BiometricStatusChanged(this.enabled);
}
