import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/data/cubit/installment_payment_state.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/installment_model.dart';

class InstallmentPaymentCubit extends Cubit<InstallmentPaymentState> {
  InstallmentPaymentCubit(this.customer) : super(InstallmentPaymentInitial());

  CustomerModel customer;

  Future<void> confirmPayment({
    required int selectedIndex,
    required DateTime paymentDate,
    required double paidAmount,
  }) async {
    if (state is InstallmentPaymentLoading) return;

    if (customer.id.isEmpty) {
      emit(
        InstallmentPaymentError('Customer ID is missing. Cannot save payment.'),
      );
      return;
    }

    if (paidAmount <= 0) {
      emit(
        InstallmentPaymentError('Payment amount must be greater than zero.'),
      );
      return;
    }

    emit(InstallmentPaymentLoading());

    try {
      final hasDownPayment = customer.downPayment > 0;
      final isDownPaymentSelected = hasDownPayment && selectedIndex == 0;

      final dateString = DateFormat('dd/MM/yyyy').format(paymentDate);

      CustomerModel updatedCustomer;

      if (isDownPaymentSelected) {
        if (customer.isDownPaymentPaid) {
          throw Exception('The down payment has already been paid.');
        }

        // The current model cannot store partial down-payment amounts.
        if (paidAmount != customer.downPayment) {
          throw Exception('Please pay the full down payment amount.');
        }

        updatedCustomer = customer.copyWith(
          isDownPaymentPaid: true,
          downPaymentPaidAtDate: dateString,
        );
      } else {
        final scheduleIndex = hasDownPayment
            ? selectedIndex - 1
            : selectedIndex;

        if (scheduleIndex < 0 || scheduleIndex >= customer.schedule.length) {
          throw Exception('Invalid installment selection.');
        }

        final updatedSchedule = List<InstallmentModel>.from(customer.schedule);

        final installment = updatedSchedule[scheduleIndex];
        if (installment.isPaid) {
          throw Exception('This installment has already been paid.');
        }
        final newPaidAmount = installment.paidAmount + paidAmount;
        final isFullyPaid = newPaidAmount >= installment.amount;

        updatedSchedule[scheduleIndex] = installment.copyWith(
          paidAmount: newPaidAmount,
          isPaid: isFullyPaid,
          paidAtDate: dateString,
        );
        updatedCustomer = customer.copyWith(
          schedule: updatedSchedule,
          paidValue: customer.paidValue + paidAmount,
        );
      }

      // Choose the next outstanding due date.
      String nextDueDate = '';

      if (updatedCustomer.downPayment > 0 &&
          !updatedCustomer.isDownPaymentPaid) {
        nextDueDate = updatedCustomer.contractDate;
      } else {
        for (final installment in updatedCustomer.schedule) {
          if (!installment.isPaid) {
            nextDueDate = installment.dueDate;
            break;
          }
        }
      }

      if (nextDueDate.isEmpty) {
        nextDueDate = updatedCustomer.nextDueDate;
      }

      final updatedStatus = updatedCustomer.remainingValue <= 0
          ? 'Completed'
          : _calculateStatus(nextDueDate);

      updatedCustomer = updatedCustomer.copyWith(
        nextDueDate: nextDueDate,
        status: updatedStatus,
      );

      // Save the complete updated customer to Firestore.
      await TaqseetFirestoreServices.saveRecord(
        type: 'customer',
        documentId: updatedCustomer.id,
        data: updatedCustomer.toMap(),
      );

      customer = updatedCustomer;
      emit(InstallmentPaymentSuccess(updatedCustomer));
    } catch (error) {
      final message = error.toString().replaceFirst('Exception: ', '');
      emit(InstallmentPaymentError(message));
    }
  }

  String _calculateStatus(String dueDate) {
    final parsedDate = _parseDate(dueDate);

    if (parsedDate == null) return 'Up to Date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (parsedDate.isBefore(today)) return 'Overdue';
    if (parsedDate.isAtSameMomentAs(today)) return 'Due Now';

    return 'Up to Date';
  }

  DateTime? _parseDate(String value) {
    final date = value.trim();

    if (date.isEmpty) return null;

    final parsed = DateTime.tryParse(date);
    if (parsed != null) {
      return DateTime(parsed.year, parsed.month, parsed.day);
    }

    final formats = <String>[
      'dd/MM/yyyy',
      'd/M/yyyy',
      'dd MMM yyyy',
      'd MMM yyyy',
    ];

    for (final format in formats) {
      try {
        final result = DateFormat(format, 'en').parseStrict(date);
        return DateTime(result.year, result.month, result.day);
      } catch (_) {
        // Try the next supported format.
      }
    }

    return null;
  }
}
