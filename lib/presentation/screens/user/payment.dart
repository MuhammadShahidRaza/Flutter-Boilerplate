import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/data/models/order.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final HomeRepository _homeRepository = HomeRepository();
  bool isLoading = false;
  bool isProcessing = false;
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod? selectedPaymentMethod;
  OrderModel? order;
  double invoiceValue = 0.0;
  late final bool isTestMode;
  late final String currency;

  String _lastInvoiceId = '';
  // MyFatoorah API key
  final String apiKey = Environment.myFatoorahApiKey;
  @override
  void initState() {
    super.initState();
    isTestMode = Environment.myFatoorahTestMode.toLowerCase() == 'true';
    // currency = isTestMode
    //     ? MFCurrencyISO.KUWAIT_KWD
    //     : MFCurrencyISO.SAUDIARABIA_SAR;
    currency = MFCurrencyISO.SAUDIARABIA_SAR;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = context.getExtra();
    if (extra != null) {
      order = extra['order'] as OrderModel?;
      invoiceValue = (extra['amount'] as num?)?.toDouble() ?? 0.0;
    }
    _initMyFatoorahSdk().then((_) {
      if (paymentMethods.isEmpty) {
        _initiatePaymentSdk();
      }
    });
  }

  Future<void> _initMyFatoorahSdk() async {
    try {
      await MFSDK.init(
        apiKey,
        isTestMode ? MFCountry.KUWAIT : MFCountry.SAUDIARABIA,
        isTestMode ? MFEnvironment.TEST : MFEnvironment.LIVE,
      );
    } catch (e) {
      _showError('SDK init error: ${e.toString()}');
    }
  }

  Future<void> _initiatePaymentSdk() async {
    setState(() => isLoading = true);
    try {
      final request = MFInitiatePaymentRequest(
        invoiceAmount: invoiceValue,
        currencyIso: currency,
      );
      final response = await MFSDK.initiatePayment(request, MFLanguage.ENGLISH);

      final methods = response.paymentMethods;
      if (methods != null) {
        final mapped = methods.map<PaymentMethod>((m) {
          final id = m.paymentMethodId ?? 0;
          final en = m.paymentMethodEn ?? '';
          final ar = m.paymentMethodAr ?? '';
          final img = m.imageUrl ?? '';
          final sc = (m.serviceCharge ?? 0.0).toDouble();
          final ta = (m.totalAmount ?? invoiceValue).toDouble();
          final cur = m.currencyIso ?? (isTestMode ? 'KWD' : 'SAR');
          return PaymentMethod(
            paymentMethodId: id,
            paymentMethodEn: en,
            paymentMethodAr: ar,
            imageUrl: img,
            serviceCharge: sc,
            totalAmount: ta,
            currencyIso: cur,
            isTestMode: isTestMode,
          );
        }).toList();

        // Filter platform-specific wallets: hide Google Pay on iOS, Apple Pay on Android
        final filtered = mapped.where((m) {
          final name = m.paymentMethodEn.toLowerCase();
          if (Platform.isIOS && name.contains('google')) return false;
          if (Platform.isAndroid && name.contains('apple')) return false;
          return true;
        }).toList();

        filtered.sort((a, b) {
          if (a.paymentMethodEn == 'VISA/MASTER') return -1;
          if (b.paymentMethodEn == 'VISA/MASTER') return 1;
          return 0;
        });

        setState(() {
          paymentMethods = filtered;
          selectedPaymentMethod = filtered.isNotEmpty ? filtered.first : null;
        });
      } else {
        _showError('No payment methods returned by SDK');
      }
    } catch (e) {
      _showError('Initiate payment error: ${e.toString()}');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _sanitizeEmail(String? email) {
    final e = (email ?? '').trim();
    if (e.isEmpty || !e.contains('@')) return 'customer@example.com';
    return e;
  }

  String _sanitizeMobile(String? mobile) {
    final digits = (mobile ?? '').replaceAll(RegExp(r'\D'), '');
    if (isTestMode) {
      // Kuwait uses local 8-digit format (no country code)
      if (digits.length == 8) return digits;
      return '51234567';
    } else {
      // Saudi uses local 9-digit format (no country code)
      if (digits.length == 9) return digits;
      return '512345678';
    }
  }

  Future<void> _executePayment() async {
    if (selectedPaymentMethod == null) {
      AppToast.showToast('Please select a payment method');
      return;
    }

    setState(() => isProcessing = true);
    final isArabic = await AuthService.loadLanguage() == 'ar';

    try {
      final execReq = MFExecutePaymentRequest(
        invoiceValue: invoiceValue,
        paymentMethodId: selectedPaymentMethod!.paymentMethodId,
        displayCurrencyIso: currency,
        customerName: Utils.getfullName(order?.user),
        customerEmail: _sanitizeEmail(order?.user?.email),
        customerMobile: _sanitizeMobile(order?.user?.phone),
        customerReference: order?.id.toString() ?? '',
        language: isArabic ? MFLanguage.ARABIC : MFLanguage.ENGLISH,
      );
      final statusResponse = await MFSDK.executePayment(
        execReq,
        isArabic ? MFLanguage.ARABIC : MFLanguage.ENGLISH,
        (String invoiceId) {
          _lastInvoiceId = invoiceId;
        },
      );

      final invoiceStatus = (statusResponse.invoiceStatus)
          ?.toString()
          .toLowerCase();
      if (invoiceStatus == 'paid') {
        _handlePaymentResult('success');
      } else {
        _handlePaymentResult('failed');
      }
    } catch (e) {
      setState(() => isProcessing = false);
      final msg = (e is MFError && e.message != null)
          ? e.message
          : e.toString();
      debugPrint('MyFatoorah execute error: $msg');

      if (msg == 'User clicked cancel button') {
        return;
      }
      _showError('Payment error: $msg');
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _handlePaymentResult(String status) async {
    if (!mounted) return;
    if (status == 'success') {
      final payload = {
        "_method": "PATCH",
        "payment_method": selectedPaymentMethod?.paymentMethodEn ?? '',
        "transaction_id": _lastInvoiceId,
        "booking_id": order?.id.toString() ?? '',
      };
      final response = await _homeRepository.updatePayment(payload: payload);
      if (response == true) {
        if (!mounted) return;
        AppDialog.show(
          context,
          title: Common.paymentSuccessful,
          imagePath: AppAssets.allSet,
          borderColor: AppColors.primary,
          borderWidth: 4,
          dismissible: false,
          borderRadius: Dimens.radiusL,
          imageSize: 150,
          content: AppText(
            Common.yourPaymentProcessedSuccessfully,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          primaryButtonText: Common.okay,
          onPrimaryPressed: () => {
            if (mounted) {context.replacePage(AppRoutes.orders)},
          },
          backgroundColor: AppColors.lightWhite,
          crossAxisAlignment: CrossAxisAlignment.center,
          insetPadding: EdgeInsets.all(Dimens.spacingXXL),
        );
      } else {
        _showError(Common.failedToUpdatePaymentStatus);
      }
    } else {
      AppDialog.show(
        context,
        title: Common.paymentFailed,
        content: AppText(
          Common.yourPaymentCouldNotBeProcessedPleaseTryAgain,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        primaryButtonText: Common.tryAgain,
        onPrimaryPressed: () => {context.back(), _executePayment()},
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
      heading: Common.payment,
      showBackButton: true,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.spacingLarge),
                  margin: EdgeInsets.all(Dimens.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimens.radiusM),
                  ),
                  child: Column(
                    spacing: Dimens.spacingXS,
                    children: [
                      AppText(
                        Common.totalAmount,
                        style: context.textTheme.bodyMedium,
                      ),
                      if (order != null)
                        AppText(
                          '${context.tr(Common.orderId)} #: ${order?.orderNumber ?? ''}',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      AppText(
                        '${invoiceValue.toStringAsFixed(2)} $currency',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: paymentMethods.isEmpty
                      ? const Center(child: AppText(Common.noDataAvailable))
                      : ListView.builder(
                          padding: EdgeInsets.all(Dimens.spacingM),
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            final method = paymentMethods[index];
                            final isSelected =
                                selectedPaymentMethod?.paymentMethodId ==
                                method.paymentMethodId;
                            return GestureDetector(
                              onTap: () => setState(
                                () => selectedPaymentMethod = method,
                              ),
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
                                  spacing: Dimens.spacingM,
                                  children: [
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
                                              'Service charge: ${method.serviceCharge.toStringAsFixed(2)} ${method.currencyIso}',
                                              style: context
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: AppColors.gray,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
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
                AppButton(
                  isEnabled: order?.id != null,
                  title: Common.payNow,
                  isLoading: isProcessing,
                  onPressed: isProcessing || selectedPaymentMethod == null
                      ? null
                      : _executePayment,
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
  final bool isTestMode;

  PaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethodEn,
    required this.paymentMethodAr,
    required this.imageUrl,
    required this.serviceCharge,
    required this.totalAmount,
    required this.currencyIso,
    required this.isTestMode,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodId: json['PaymentMethodId'] ?? 0,
      paymentMethodEn: json['PaymentMethodEn'] ?? '',
      paymentMethodAr: json['PaymentMethodAr'] ?? '',
      imageUrl: json['ImageUrl'] ?? '',
      serviceCharge: (json['ServiceCharge'] ?? 0.0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0.0).toDouble(),
      currencyIso: json['CurrencyIso'] ?? (json['isTestMode'] ? 'KWD' : 'SAR'),
      isTestMode: json['isTestMode'] ?? false,
    );
  }
}

// Legacy WebView-based payment flow removed. SDK-only implementation is used.
