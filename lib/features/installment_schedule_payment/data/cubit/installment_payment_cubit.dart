import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/utils/helper/payment_status_helper.dart';
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
      emit(InstallmentPaymentError('Customer ID is missing.'));
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
      final String paymentDateString = DateFormat(
        'dd/MM/yyyy',
      ).format(paymentDate);

      final bool hasDownPayment = customer.downPayment > 0;
      final bool isDownPaymentSelected = hasDownPayment && selectedIndex == 0;

      CustomerModel updatedCustomer;

      if (isDownPaymentSelected) {
        if (customer.isDownPaymentPaid) {
          emit(
            InstallmentPaymentError('The down payment has already been paid.'),
          );
          return;
        }

        // Save the exact amount paid toward the down payment.
        // It can be less than or greater than the original amount.
        updatedCustomer = customer.copyWith(
          isDownPaymentPaid: true,
          downPaymentPaidAmount: paidAmount,
          downPaymentPaidAtDate: paymentDateString,
        );
      } else {
        final int scheduleIndex = hasDownPayment
            ? selectedIndex - 1
            : selectedIndex;

        if (scheduleIndex < 0 || scheduleIndex >= customer.schedule.length) {
          emit(InstallmentPaymentError('Invalid installment selected.'));
          return;
        }

        final InstallmentModel selectedInstallment =
            customer.schedule[scheduleIndex];

        if (selectedInstallment.isPaid || selectedInstallment.paidAmount > 0) {
          emit(
            InstallmentPaymentError('This installment has already been paid.'),
          );
          return;
        }

        final List<InstallmentModel> updatedSchedule =
            List<InstallmentModel>.from(customer.schedule);

        // Record the entire amount on this installment only.
        // Do not distribute extra money to other installments.
        updatedSchedule[scheduleIndex] = selectedInstallment.copyWith(
          paidAmount: paidAmount,
          isPaid: true,
          paidAtDate: paymentDateString,
          status: 'paid',
        );

        updatedCustomer = customer.copyWith(
          schedule: updatedSchedule,
          paidValue: customer.paidValue + paidAmount,
        );
      }

      updatedCustomer = PaymentStatusHelper.updateCustomer(updatedCustomer);

      await TaqseetFirestoreServices.saveRecord(
        type: 'customer',
        documentId: updatedCustomer.id,
        data: updatedCustomer.toMap(),
      );

      customer = updatedCustomer;

      emit(InstallmentPaymentSuccess(updatedCustomer));
    } catch (error) {
      emit(InstallmentPaymentError('Could not save the payment: $error'));
    }
  }

  Future<void> editPaymentAmount({
    required int selectedIndex,
    required double newAmount,
  }) async {
    if (state is InstallmentPaymentLoading) return;

    if (newAmount <= 0) {
      emit(
        InstallmentPaymentError('Payment amount must be greater than zero.'),
      );
      return;
    }

    if (customer.id.isEmpty) {
      emit(InstallmentPaymentError('Customer ID is missing.'));
      return;
    }

    emit(InstallmentPaymentLoading());

    try {
      final bool hasDownPayment = customer.downPayment > 0;
      final bool isDownPaymentSelected = hasDownPayment && selectedIndex == 0;

      CustomerModel updatedCustomer;

      if (isDownPaymentSelected) {
        if (!customer.isDownPaymentPaid) {
          emit(
            InstallmentPaymentError('The down payment has not been paid yet.'),
          );
          return;
        }

        updatedCustomer = customer.copyWith(downPaymentPaidAmount: newAmount);
      } else {
        final int scheduleIndex = hasDownPayment
            ? selectedIndex - 1
            : selectedIndex;

        if (scheduleIndex < 0 || scheduleIndex >= customer.schedule.length) {
          emit(InstallmentPaymentError('Invalid installment selected.'));
          return;
        }

        final List<InstallmentModel> updatedSchedule =
            List<InstallmentModel>.from(customer.schedule);

        final InstallmentModel installment = updatedSchedule[scheduleIndex];

        if (!installment.isPaid && installment.paidAmount <= 0) {
          emit(
            InstallmentPaymentError(
              'This installment has no recorded payment to edit.',
            ),
          );
          return;
        }

        // Adjust the customer's installment total by the difference.
        final double difference = newAmount - installment.paidAmount;

        updatedSchedule[scheduleIndex] = installment.copyWith(
          paidAmount: newAmount,
          isPaid: true,
          status: 'paid',
        );

        updatedCustomer = customer.copyWith(
          schedule: updatedSchedule,
          paidValue: (customer.paidValue + difference)
              .clamp(0.0, double.infinity)
              .toDouble(),
        );
      }

      updatedCustomer = PaymentStatusHelper.updateCustomer(updatedCustomer);

      await TaqseetFirestoreServices.saveRecord(
        type: 'customer',
        documentId: updatedCustomer.id,
        data: updatedCustomer.toMap(),
      );

      customer = updatedCustomer;

      emit(InstallmentPaymentSuccess(updatedCustomer));
    } catch (error) {
      emit(InstallmentPaymentError('Could not update the payment: $error'));
    }
  }
}
