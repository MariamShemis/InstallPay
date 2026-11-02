import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/installment_model.dart';

class PaymentStatusHelper {
  static const String paid = 'paid';
  static const String unpaid = 'unpaid';
  static const String due = 'due';
  static const String overdue = 'overdue';

  static DateTime? parseDate(String value) {
    final text = value.trim();

    if (text.isEmpty) return null;

    final parsed = DateTime.tryParse(text);

    if (parsed != null) {
      return DateTime(parsed.year, parsed.month, parsed.day);
    }

    final parts = text.split('/');

    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day != null && month != null && year != null) {
        final date = DateTime(year, month, day);

        if (date.year == year && date.month == month && date.day == day) {
          return date;
        }
      }
    }

    final words = text.split(' ');

    if (words.length == 3) {
      final day = int.tryParse(words[0]);
      final year = int.tryParse(words[2]);

      const months = {
        'jan': 1,
        'feb': 2,
        'mar': 3,
        'apr': 4,
        'may': 5,
        'jun': 6,
        'jul': 7,
        'aug': 8,
        'sep': 9,
        'oct': 10,
        'nov': 11,
        'dec': 12,
      };

      final monthText = words[1].toLowerCase();
      final month =
          months[monthText.substring(
            0,
            monthText.length >= 3 ? 3 : monthText.length,
          )];

      if (day != null && month != null && year != null) {
        final date = DateTime(year, month, day);

        if (date.year == year && date.month == month && date.day == day) {
          return date;
        }
      }
    }

    return null;
  }

  static String installmentStatus(InstallmentModel installment) {
    if (installment.isPaid || installment.remainingAmount <= 0) {
      return paid;
    }

    return statusForDate(installment.dueDate);
  }

  static String statusForDate(String dateText) {
    final date = parseDate(dateText);

    if (date == null) return unpaid;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (date.isBefore(today)) return overdue;
    if (date.isAtSameMomentAs(today)) return due;

    return unpaid;
  }

  static CustomerModel updateCustomer(CustomerModel customer) {
    final updatedSchedule = <InstallmentModel>[];

    // Update the status and payment flag of every installment.
    for (final installment in customer.schedule) {
      final isFullyPaid =
          installment.isPaid || installment.remainingAmount <= 0;

      updatedSchedule.add(
        installment.copyWith(
          isPaid: isFullyPaid,
          status: isFullyPaid ? paid : statusForDate(installment.dueDate),
        ),
      );
    }

    final updatedCustomer = customer.copyWith(schedule: updatedSchedule);

    // The customer is fully paid only when the actual remaining
    // contract amount is zero.
    if (updatedCustomer.remainingValue <= 0) {
      return updatedCustomer.copyWith(status: paid, nextDueDate: '');
    }

    final outstandingDates = <String>[];

    // An unpaid down payment is also an outstanding payment.
    if (updatedCustomer.downPayment > 0 && !updatedCustomer.isDownPaymentPaid) {
      outstandingDates.add(updatedCustomer.contractDate);
    }

    // Include only installments that still have an amount to pay.
    for (final installment in updatedSchedule) {
      if (!installment.isPaid && installment.remainingAmount > 0) {
        outstandingDates.add(installment.dueDate);
      }
    }

    // Ignore invalid dates.
    outstandingDates.removeWhere((date) => parseDate(date) == null);

    // Sort from the earliest due date to the latest.
    outstandingDates.sort((first, second) {
      return parseDate(first)!.compareTo(parseDate(second)!);
    });

    if (outstandingDates.isEmpty) {
      return updatedCustomer.copyWith(status: unpaid, nextDueDate: '');
    }

    final nextDueDate = outstandingDates.first;
    var customerStatus = unpaid;

    // Overdue has priority over Due, which has priority over Unpaid.
    for (final date in outstandingDates) {
      final dateStatus = statusForDate(date);

      if (dateStatus == overdue) {
        customerStatus = overdue;
        break;
      }

      if (dateStatus == due) {
        customerStatus = due;
      }
    }

    return updatedCustomer.copyWith(
      status: customerStatus,
      nextDueDate: nextDueDate,
    );
  }
}
