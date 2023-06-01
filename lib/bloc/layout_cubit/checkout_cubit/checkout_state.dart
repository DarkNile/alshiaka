abstract class CheckoutState{}
class CheckoutInitial extends CheckoutState{}

class CheckoutChangeState extends CheckoutState{}
class ApplyCoupon extends CheckoutState{}
class AddressesState extends CheckoutState{}
class SelectedPaymentState extends CheckoutState{}
class SelectedShippingState extends CheckoutState{}

class CreditCardChangeState extends CheckoutState{}

class CheckoutLoadingState extends CheckoutState{}
class CheckoutLoadedState extends CheckoutState{}
class CheckoutErrorState extends CheckoutState{}
