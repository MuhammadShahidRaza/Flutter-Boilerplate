import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool isLoading = false;
  bool isProcessing = false;
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod? selectedPaymentMethod;
  String? orderId;
  double invoiceValue = 0.0;

  // Replace with your MyFatoorah API key
  final String apiKey =
      'SK_KWT_jLoDR4tjTCIfqhhgqo6R7E4ZRDIxkegzCeyyS6f5eu9aKmtatDiKgWSknj1YD751';
  final String apiBase = 'https://apitest.myfatoorah.com/v2';
  // For production, use:
  // final String apiBase = 'https://api.myfatoorah.com/v2';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = context.getExtra();
    if (extra != null) {
      orderId = extra['orderId'] as String?;
      invoiceValue = (extra['amount'] as num?)?.toDouble() ?? 115.0;
    }
    if (paymentMethods.isEmpty) {
      _loadPaymentMethods();
    }
  }

  Future<void> _loadPaymentMethods() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$apiBase/InitiatePayment'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"InvoiceAmount": invoiceValue, "CurrencyIso": "KWD"}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['IsSuccess'] == true && data['Data'] != null) {
          final List<dynamic> methodsData = data['Data']['PaymentMethods'];

          setState(() {
            paymentMethods = methodsData
                .map((method) => PaymentMethod.fromJson(method))
                .toList();
          });
        } else {
          _showError(data['Message'] ?? 'Failed to load payment methods');
        }
      } else {
        _showError('Failed to connect to payment gateway');
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _executePayment() async {
    if (selectedPaymentMethod == null) {
      AppToast.showToast('Please select a payment method');
      return;
    }

    setState(() => isProcessing = true);

    try {
      final response = await http.post(
        Uri.parse('$apiBase/ExecutePayment'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "PaymentMethodId": selectedPaymentMethod!.paymentMethodId,
          "InvoiceValue": invoiceValue,
          "CustomerName": "John Doe",
          "CustomerEmail": "customer@example.com",
          "CustomerMobile": "96512345678",
          "CallBackUrl": "https://your-app.com/payment/callback",
          "ErrorUrl": "https://your-app.com/payment/error",
          "Language": "en",
          "CustomerReference": orderId ?? "",
          "DisplayCurrencyIso": "KWD",
          "MobileCountryCode": "+965",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['IsSuccess'] == true) {
          final paymentUrl = data['Data']['PaymentURL'];

          if (paymentUrl != null && mounted) {
            setState(() => isProcessing = false);

            // Navigate to WebView for payment
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentWebView(
                  paymentUrl: paymentUrl,
                  onPaymentComplete: (status) {
                    Navigator.of(context).pop(status);
                  },
                ),
              ),
            );

            if (result != null && mounted) {
              _handlePaymentResult(result as String);
            }
          }
        } else {
          _showError(data['Message'] ?? 'Payment initiation failed');
        }
      } else {
        _showError('Failed to process payment');
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  void _handlePaymentResult(String status) {
    if (status == 'success') {
      AppDialog.show(
        context,
        title: 'Payment Successful',
        content: AppText(
          'Your payment has been processed successfully.',
          textAlign: TextAlign.center,
        ),
        primaryButtonText: 'Done',
        onPrimaryPressed: () {
          context.go(AppRoutes.orders);
        },
      );
    } else if (status == 'failed') {
      AppDialog.show(
        context,
        title: 'Payment Failed',
        content: AppText(
          'Your payment could not be processed. Please try again.',
          textAlign: TextAlign.center,
        ),
        primaryButtonText: 'Try Again',
        onPrimaryPressed: () {
          context.pop();
        },
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    AppToast.showToast(message);
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      appBar: AppBar(
        title: AppText(
          'Select Payment Method',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.back(),
        ),
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Amount Display
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.spacingLarge),
                  margin: EdgeInsets.all(Dimens.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimens.radiusM),
                  ),
                  child: Column(
                    children: [
                      AppText(
                        'Total Amount',
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: Dimens.spacingXS),
                      AppText(
                        '${invoiceValue.toStringAsFixed(3)} KWD',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Payment Methods List
                Expanded(
                  child: paymentMethods.isEmpty
                      ? Center(child: AppText('No payment methods available'))
                      : ListView.builder(
                          padding: EdgeInsets.all(Dimens.spacingM),
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            final method = paymentMethods[index];
                            final isSelected =
                                selectedPaymentMethod?.paymentMethodId ==
                                method.paymentMethodId;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPaymentMethod = method;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: Dimens.spacingM,
                                ),
                                padding: EdgeInsets.all(Dimens.spacingM),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : AppColors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.gray.withValues(alpha: 0.3),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Dimens.radiusM,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Payment Method Icon
                                    Container(
                                      width: 60,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(
                                          Dimens.radiusS,
                                        ),
                                        border: Border.all(
                                          color: AppColors.gray.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: method.imageUrl.isNotEmpty
                                          ? Image.network(
                                              method.imageUrl,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stack) =>
                                                      Icon(
                                                        Icons.payment,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                            )
                                          : Icon(
                                              Icons.payment,
                                              color: AppColors.primary,
                                            ),
                                    ),
                                    SizedBox(width: Dimens.spacingM),

                                    // Payment Method Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            method.paymentMethodEn,
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          if (method.serviceCharge > 0)
                                            AppText(
                                              'Service charge: ${method.serviceCharge.toStringAsFixed(3)} KWD',
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: AppColors.gray,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Selection Indicator
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Pay Button
                Container(
                  padding: EdgeInsets.all(Dimens.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: AppButton(
                    title: isProcessing ? 'Processing...' : 'Pay Now',
                    onPressed: isProcessing || selectedPaymentMethod == null
                        ? null
                        : _executePayment,
                    backgroundColor: selectedPaymentMethod == null
                        ? AppColors.gray
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
    );
  }
}

class PaymentMethod {
  final int paymentMethodId;
  final String paymentMethodEn;
  final String paymentMethodAr;
  final String imageUrl;
  final double serviceCharge;
  final double totalAmount;
  final String currencyIso;

  PaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethodEn,
    required this.paymentMethodAr,
    required this.imageUrl,
    required this.serviceCharge,
    required this.totalAmount,
    required this.currencyIso,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodId: json['PaymentMethodId'] ?? 0,
      paymentMethodEn: json['PaymentMethodEn'] ?? '',
      paymentMethodAr: json['PaymentMethodAr'] ?? '',
      imageUrl: json['ImageUrl'] ?? '',
      serviceCharge: (json['ServiceCharge'] ?? 0.0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0.0).toDouble(),
      currencyIso: json['CurrencyIso'] ?? 'KWD',
    );
  }
}

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final Function(String status) onPaymentComplete;

  const PaymentWebView({
    super.key,
    required this.paymentUrl,
    required this.onPaymentComplete,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late WebViewController controller;
  bool isLoading = true;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() => isLoading = true);
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() => isLoading = false);
            }
          },
          onNavigationRequest: (request) {
            if (_hasCompleted) return NavigationDecision.prevent;

            final url = request.url.toLowerCase();

            // Check for success callback
            if (url.contains('payment/callback') || url.contains('success')) {
              _hasCompleted = true;
              widget.onPaymentComplete('success');
              return NavigationDecision.prevent;
            }

            // Check for error/failure callback
            if (url.contains('payment/error') ||
                url.contains('failed') ||
                url.contains('cancel')) {
              _hasCompleted = true;
              widget.onPaymentComplete('failed');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText('Complete Payment'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            if (!_hasCompleted) {
              _hasCompleted = true;
              widget.onPaymentComplete('cancelled');
            }
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
