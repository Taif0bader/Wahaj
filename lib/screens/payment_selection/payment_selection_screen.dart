import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/pay.dart';

import '/blocs/blocs.dart';
import '/widgets/widgets.dart';
import '/models/models.dart';

class PaymentSelection extends StatelessWidget {
  static const String routeName = '/payment-selection';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => PaymentSelection(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Payment Selection'),
      bottomNavigationBar: CustomNavBar(screen: routeName),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF94B49F),
              ),
            );
          }
          if (state is PaymentLoaded) {
            return ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                Platform.isIOS
                    ? RawApplePayButton(
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.inStore,
                  onPressed: () {
                    context.read<PaymentBloc>().add(
                      SelectPaymentMethod(
                          paymentMethod: PaymentMethod.apple_pay),
                    );
                    Navigator.pop(context);
                  },
                )
                    : SizedBox(),
                const SizedBox(height: 10),
                Platform.isAndroid
                    ? RawGooglePayButton(
                  //style: GooglePayButtonStyle.black,
                  type: GooglePayButtonType.pay,
                  onPressed: () {
                    context.read<PaymentBloc>().add(
                      SelectPaymentMethod(
                          paymentMethod: PaymentMethod.google_pay),
                    );
                    Navigator.pop(context);
                  },
                )
                    : SizedBox(),
          ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF94B49F),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(75.0)),
          ),
          onPressed: () {
          context.read<PaymentBloc>().add(
          SelectPaymentMethod(
          paymentMethod: PaymentMethod.credit_card),
          );
          Navigator.pop(context);
          },
          child: Text(
          'Pay with Credit Card',
          style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          ),
          ),
          ),

              ],
            );
          } else {
            return Text('Something went wrong');
          }
        },
      ),
    );
  }
}