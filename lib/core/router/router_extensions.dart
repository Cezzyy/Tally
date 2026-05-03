import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RouterExtensions on BuildContext {
  void goHome() => go('/');

  void goToTickets() => go('/tickets');

  void goToTicketDetail(String ticketId) => go('/tickets/$ticketId');

  void goToLogin() => go('/login');

  void goToSignup() => go('/signup');

  void goBack() {
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}
