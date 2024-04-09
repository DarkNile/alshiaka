import 'package:ahshiaka/models/checkout/amount_aramex_model.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutChangeState extends CheckoutState {}

class ApplyCoupon extends CheckoutState {}

class AddressesState extends CheckoutState {}

class SelectedPaymentState extends CheckoutState {}

class SelectedShippingState extends CheckoutState {}

class CreditCardChangeState extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {}

class CheckoutLoadedState extends CheckoutState {}

class CheckoutErrorState extends CheckoutState {}

// Total
class GetTotalLoadingState extends CheckoutState {}

class GetTotalLoadedState extends CheckoutState {
  final AmountAramexModel amountAramex;

  GetTotalLoadedState(this.amountAramex);
}

class GetTotalErrorState extends CheckoutState {
  final String error;

  GetTotalErrorState(this.error);
}
