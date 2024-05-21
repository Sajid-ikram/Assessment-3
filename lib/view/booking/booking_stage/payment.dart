/*
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';

import '../../../provider/booking_provider.dart';
import '../../Auth/widgets/custom_button.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController testController = TextEditingController();

  bookTicket() {
    var pro = Provider.of<BookingProvider>(context, listen: false);
    pro.bookFlight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Provider.of<BookingProvider>(context, listen: false)
                          .changeScreenNumber(3);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: kIsWeb ? 30 : 25.sp,
                    )),
                GestureDetector(
                  onTap: () {
                    bookTicket();
                  },
                  child: customButton(
                    "Book",
                    isAddPage: kIsWeb ? 130 : 80.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Text("Flight Details",
              style: GoogleFonts.inter(
                  fontSize: kIsWeb ? 30 : 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(
            width: kIsWeb ? 700 : 340.w,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(testController, "Flight Number"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildDateTimePicker(TextEditingController controller, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
      child: DateTimePicker(
        type: DateTimePickerType.dateTimeSeparate,
        dateMask: 'd MMM, yyyy',
        initialValue: DateTime.now().toString(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        icon: Text(text,
            style: GoogleFonts.inter(
                color: Colors.grey, fontSize: kIsWeb ? 17 : 12.sp)),
        dateLabelText: 'Date',
        timeLabelText: "Hour",
        style: TextStyle(color: Colors.black, fontSize: kIsWeb ? 17 : 12.sp),
        onChanged: (val) {
          controller.text = val ?? "";
        },
        validator: (val) {
          print(val);
          controller.text = val!;
          print("arrivalTimeController.text: ${controller.text}");
          return null;
        },
      ),
    );
  }
}

Padding buildTextField(TextEditingController controller, String text,
    {int maxLine = 1, bool enabled = true}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
    child: TextField(
      enabled: enabled,
      maxLines: maxLine,
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color(0xffC4C4C4).withOpacity(0.2),
        filled: true,
        hintText: text,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // Set desired corner radius
          borderSide: BorderSide.none, // Set border color (optional)
        ),
      ),
    ),
  );
}
*/

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:assessment_3/provider/profile_provider.dart';
import 'package:checkout_screen_ui/checkout_ui.dart';
import 'package:checkout_screen_ui/models/checkout_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Utils/custom_loading.dart';
import '../../../provider/booking_provider.dart';
import '../../Auth/widgets/custom_button.dart';
import '../../Auth/widgets/snackBar.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<void> _nativePayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Native Pay requires setup')));
  }

  Future<void> _cashPayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cash Pay requires setup')));
  }

  final List<PriceItem> _priceItems = [];

  bookTicket() {

    var pro = Provider.of<BookingProvider>(context, listen: false);
    pro.bookFlight().then(
      (value) {
        if (value != "Success") {
          snackBar(context, value);
        } else {
          snackBar(context, "Tickets booked successfully!");
          Provider.of<BookingProvider>(context, listen: false)
              .changeScreenNumber(0);
          Provider.of<BookingProvider>(context, listen: false)
              .changePassengers(0, 0, 0);
        }
      },
    );
  }

  @override
  void initState() {
    var pro = Provider.of<BookingProvider>(context, listen: false);
    for (var element in pro.selectedSeats) {
      _priceItems.add(PriceItem(
          name: "Seat ${element["seatNumber"]}",
          quantity: 1,
          itemCostCents: 10000));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final demoOnlyStuff = DemoOnlyStuff();

    final GlobalKey<CardPayButtonState> _payBtnKey =
        GlobalKey<CardPayButtonState>();

    Future<void> _creditPayClicked(
        CardFormResults results, CheckOutResult checkOutResult) async {
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.processing);

      demoOnlyStuff.callTransactionApi(_payBtnKey);

      print(results);

      for (PriceItem item in checkOutResult.priceItems) {
        print('Item: ${item.name} - Quantity: ${item.quantity}');
      }

      final String subtotal =
          (checkOutResult.subtotalCents / 100).toStringAsFixed(2);
      print('Subtotal: \$$subtotal');

      final String tax = (checkOutResult.taxCents / 100).toStringAsFixed(2);
      print('Tax: \$$tax');

      final String total =
          (checkOutResult.totalCostCents / 100).toStringAsFixed(2);
      print('Total: \$$total');
    }

    const String _payToName = 'Ealing Airline';

    final _isApple = kIsWeb ? false : Platform.isIOS;

    const _footer = CheckoutPageFooter(
      // These are example url links only. Use your own links in live code
      privacyLink: 'https://[Credit Processor].com/privacy',
      termsLink: 'https://[Credit Processor].com/payment-terms/legal',
      note: 'Powered By Ealing Airline',
      noteLink: 'https://[Credit Processor].com/',
    );

    Function? _onBack = Navigator.of(context).canPop()
        ? () => Navigator.of(context).pop()
        : null;

    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: null,
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: kIsWeb ? 600 : 360.w,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Provider.of<BookingProvider>(context, listen: false)
                              .changeScreenNumber(3);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: kIsWeb ? 30 : 25.sp,
                        )),
                    GestureDetector(
                      onTap: () {
                        if(pro.profileName.isNotEmpty){
                          bookTicket();
                        }
                        else{
                          Navigator.of(context).pushNamed("SignIn");
                        }

                      },
                      child: customButton(
                        pro.profileName.isNotEmpty ? "Book" : "Login",
                        isAddPage: kIsWeb ? 130 : 80.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      "This seats will be on hold for 10 minutes. Please complete the payment within this time.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: kIsWeb ? 14 : 10.sp, color: Colors.grey)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CountdownTimerPage(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      "This is a demo payment page. No real transactions will be made. Press 'Book' to confirm the booking.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: kIsWeb ? 14 : 10.sp, color: Colors.grey)),
                ),
              ),
              SizedBox(height: 40.h),
              Expanded(
                child: CheckoutPage(
                  data: CheckoutData(
                    priceItems: _priceItems,
                    payToName: _payToName,
                    displayNativePay: !kIsWeb,
                    onNativePay: (checkoutResults) =>
                        _nativePayClicked(context),
                    //onCashPay: (checkoutResults) => _cashPayClicked(context),
                    isApple: _isApple,
                    onCardPay: (paymentInfo, checkoutResults) =>
                        _creditPayClicked(paymentInfo, checkoutResults),
                    onBack: _onBack,
                    payBtnKey: _payBtnKey,
                    displayTestData: true,
                    taxRate: 0.07,
                  ),
                  footer: _footer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoOnlyStuff {
  bool shouldSucceed = true;

  Future<void> provideSomeTimeBeforeReset(
      GlobalKey<CardPayButtonState> _payBtnKey) async {
    await Future.delayed(const Duration(seconds: 2), () {
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.ready);
      return;
    });
  }

  Future<void> callTransactionApi(
      GlobalKey<CardPayButtonState> _payBtnKey) async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (shouldSucceed) {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.success);
        shouldSucceed = false;
      } else {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.fail);
        shouldSucceed = true;
      }
      provideSomeTimeBeforeReset(_payBtnKey);
      return;
    });
  }
}

class CountdownTimerPage extends StatefulWidget {
  @override
  _CountdownTimerPageState createState() => _CountdownTimerPageState();
}

class _CountdownTimerPageState extends State<CountdownTimerPage> {
  Timer? _timer;
  int _start = 10 * 60; // 10 minutes in seconds

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start < 1) {
          _timer!.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer as soon as the widget is initialized
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;

    return Scaffold(
      body: SizedBox(
        height: 100,
        width: 200,
        child: Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 20),
        )
      ),
    );
  }
}
