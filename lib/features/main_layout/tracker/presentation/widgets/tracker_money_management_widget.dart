import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class TrackerMoneyManagementWidget extends StatefulWidget {
  const TrackerMoneyManagementWidget({super.key});

  @override
  State<TrackerMoneyManagementWidget> createState() =>
      _TrackerMoneyManagementWidgetState();
}

class _TrackerMoneyManagementWidgetState
    extends State<TrackerMoneyManagementWidget> {
  // ---------------------------------------------------------------------------
  // CONTROLLERS & FORM STATES
  // ---------------------------------------------------------------------------
  // 1. Capital Allocation
  final _initialCapitalController = TextEditingController(text: '100000');
  final _newCapitalController = TextEditingController(text: '25000');

  // 2. Partner Split
  final _netProfitController = TextEditingController(text: '20000');
  final _primaryRatioController = TextEditingController(text: '60');
  final _secondaryRatioController = TextEditingController(text: '40');

  // 3. Customer Financial Exposure
  final _receivablesController = TextEditingController(text: '35400');
  final _payablesController = TextEditingController(text: '12200');
  final _expensesController = TextEditingController(text: '4800');

  // 4. Stamping Mode
  int _selectedStampingMode = 0; // 0: System Date, 1: Manual, 2: Cleared
  DateTime _selectedDate = DateTime.now();
  final _ledgerNoteController = TextEditingController();

  @override
  void dispose() {
    _initialCapitalController.dispose();
    _newCapitalController.dispose();
    _netProfitController.dispose();
    _primaryRatioController.dispose();
    _secondaryRatioController.dispose();
    _receivablesController.dispose();
    _payablesController.dispose();
    _expensesController.dispose();
    _ledgerNoteController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // CALCULATIONS
  // ---------------------------------------------------------------------------
  double get _initialCapital =>
      double.tryParse(_initialCapitalController.text) ?? 0.0;
  double get _newCapital =>
      double.tryParse(_newCapitalController.text) ?? 0.0;
  double get _totalCapital => _initialCapital + _newCapital;
  double get _growthRate =>
      _initialCapital == 0 ? 0.0 : (_newCapital / _initialCapital) * 100;

  double get _netProfit =>
      double.tryParse(_netProfitController.text) ?? 0.0;
  double get _primaryRatio =>
      double.tryParse(_primaryRatioController.text) ?? 0.0;
  double get _secondaryRatio =>
      double.tryParse(_secondaryRatioController.text) ?? 0.0;

  double get _primaryCapitalShare => _totalCapital * (_primaryRatio / 100);
  double get _primaryProfitShare => _netProfit * (_primaryRatio / 100);

  double get _secondaryCapitalShare => _totalCapital * (_secondaryRatio / 100);
  double get _secondaryProfitShare => _netProfit * (_secondaryRatio / 100);

  double get _receivables =>
      double.tryParse(_receivablesController.text) ?? 0.0;
  double get _payables =>
      double.tryParse(_payablesController.text) ?? 0.0;
  double get _expenses =>
      double.tryParse(_expensesController.text) ?? 0.0;

  double get _netCustomerExposure => _receivables - _payables;
  double get _netOperatingBalance => _receivables - _expenses;

  void _recalculateAll() {
    setState(() {});
  }

  // ---------------------------------------------------------------------------
  // BUILD METHOD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: REdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              // 1. Capital Allocation & Growth Calculator Card [Image 1]
              _buildCapitalCalculatorCard(isDark),

              SizedBox(height: 16.h),

              // 2. Partner Ratio & Equity Split Calculator Card [Image 2]
              _buildPartnerSplitCard(isDark),

              SizedBox(height: 16.h),

              // 3. Customer Financial Exposure Calculator Card [Image 3]
              _buildCustomerExposureCard(isDark),

              SizedBox(height: 16.h),

              // 4. Transaction Date & Period Stamping Card [Image 4]
              _buildDateStampingCard(isDark),

              SizedBox(height: 20.h),

              // Audit Validated Badge
              Container(
                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.darkSurfaceVariant
                      : ColorManager.blueSoftBackground,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16.r,
                      color: isDark
                          ? ColorManager.darkAccentGreen
                          : ColorManager.primaryColor,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Audit Validated • Engine SHA-256 Compliant',
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? ColorManager.darkMutedText
                            : ColorManager.navyText,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Recalculate Button
              OutlinedButton.icon(
                onPressed: _recalculateAll,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Recalculate All Values'),
              ),

              SizedBox(height: 10.h),

              // Save & Apply Button
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Financial calculations applied to ledger!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save & Apply to Ledger'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. CAPITAL ALLOCATION CARD (IMAGE 1)
  // ===========================================================================
  Widget _buildCapitalCalculatorCard(bool isDark) {
    return _buildSectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildCardHeader(
            isDark: isDark,
            icon: Icons.account_balance_outlined,
            title: '1. Capital Allocation & Growth Calculator',
            subtitle: 'Liquid pool expansion & growth rate',
            badgeText: 'Live',
            badgeBg: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.blueSoftBackground,
            badgeTextColor: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
          ),
          SizedBox(height: 14.h),

          // Equation Banner
          _buildEquationBanner(
            isDark: isDark,
            text: 'Total Capital = Initial Capital + New Capital',
          ),
          SizedBox(height: 16.h),

          // Initial Capital Input
          _buildLabel('Initial Capital (\$)'),
          SizedBox(height: 6.h),
          _buildInputField(
            controller: _initialCapitalController,
            prefixIcon: Icons.payments_outlined,
            onChanged: (_) => _recalculateAll(),
          ),
          SizedBox(height: 12.h),

          // New Injected Capital Input
          _buildLabel('New Injected Capital (\$)'),
          SizedBox(height: 6.h),
          _buildInputField(
            controller: _newCapitalController,
            prefixIcon: Icons.add_circle_outline,
            onChanged: (_) => _recalculateAll(),
          ),
          SizedBox(height: 16.h),

          // Live Calculation Output Container
          Container(
            padding: REdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? ColorManager.darkSurfaceVariant
                  : ColorManager.blueSoftBackground,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LIVE CALCULATION OUTPUT',
                  style: GoogleFonts.inter(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: isDark
                        ? ColorManager.darkSlateText
                        : ColorManager.greySecondaryText,
                  ),
                ),
                SizedBox(height: 10.h),

                // Calculated Total Capital Box
                _buildOutputResultBox(
                  isDark: isDark,
                  label: 'Calculated Total Capital',
                  value: '\$${_formatCurrency(_totalCapital)}',
                  valueColor: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.primaryColor,
                ),
                SizedBox(height: 10.h),

                // Growth Rate Box
                _buildOutputResultBox(
                  isDark: isDark,
                  label: 'Growth Rate',
                  value: '+${_growthRate.toStringAsFixed(2)}%',
                  valueColor: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.green,
                  leadingWidget: Icon(
                    Icons.trending_up,
                    color: isDark
                        ? ColorManager.darkAccentGreen
                        : ColorManager.green,
                    size: 20.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. PARTNER RATIO & EQUITY SPLIT CARD (IMAGE 2)
  // ===========================================================================
  Widget _buildPartnerSplitCard(bool isDark) {
    return _buildSectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildCardHeader(
            isDark: isDark,
            icon: Icons.pie_chart_outline,
            title: '2. Partner Ratio & Equity Split Calculator',
            subtitle: 'Entitlement & dividend allocation',
            badgeText: '100% Invariant',
            badgeBg: isDark
                ? ColorManager.darkGreenContainer
                : ColorManager.greenAccent.withOpacity(0.4),
            badgeTextColor: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.green,
          ),
          SizedBox(height: 14.h),

          // Invariant Banner
          Container(
            width: double.infinity,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? ColorManager.darkBrownContainer
                  : ColorManager.lightBeg.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: ColorManager.warningOrange.withOpacity(0.3),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.scale_outlined,
                  size: 18.r,
                  color: ColorManager.warningOrange,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Invariant: Primary Split (%) + Secondary Split (%) = 100%',
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? ColorManager.warningYellow
                          : ColorManager.lightBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Net Profit Input
          _buildLabel('Net Profit to Distribute (\$)'),
          SizedBox(height: 6.h),
          _buildInputField(
            controller: _netProfitController,
            prefixIcon: Icons.attach_money,
            onChanged: (_) => _recalculateAll(),
          ),
          SizedBox(height: 12.h),

          // Ratios Input Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Primary Partner Split (%)'),
                    SizedBox(height: 6.h),
                    _buildInputField(
                      controller: _primaryRatioController,
                      suffixText: '%',
                      onChanged: (val) {
                        final p = double.tryParse(val) ?? 0.0;
                        _secondaryRatioController.text =
                            (100 - p).clamp(0, 100).toStringAsFixed(0);
                        _recalculateAll();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Secondary Partner Split (%)'),
                    SizedBox(height: 6.h),
                    _buildInputField(
                      controller: _secondaryRatioController,
                      suffixText: '%',
                      onChanged: (val) {
                        final s = double.tryParse(val) ?? 0.0;
                        _primaryRatioController.text =
                            (100 - s).clamp(0, 100).toStringAsFixed(0);
                        _recalculateAll();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Partner 1 Card
          _buildPartnerOutputCard(
            isDark: isDark,
            title: 'Partner 1 (${_primaryRatio.toStringAsFixed(0)}% Standard)',
            tag: 'Primary',
            tagBg: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.blueAccent.withOpacity(0.5),
            tagColor: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
            capitalShare: _primaryCapitalShare,
            profitShare: _primaryProfitShare,
          ),

          SizedBox(height: 12.h),

          // Partner 2 Card
          _buildPartnerOutputCard(
            isDark: isDark,
            title: 'Partner 2 (${_secondaryRatio.toStringAsFixed(0)}% Standard)',
            tag: 'Secondary',
            tagBg: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.greyLight,
            tagColor: isDark
                ? ColorManager.darkMutedText
                : ColorManager.greyDark,
            capitalShare: _secondaryCapitalShare,
            profitShare: _secondaryProfitShare,
          ),
        ],
      ),
    );
  }

  // Helper Widget for Partner Cards
  Widget _buildPartnerOutputCard({
    required bool isDark,
    required String title,
    required String tag,
    required Color tagBg,
    required Color tagColor,
    required double capitalShare,
    required double profitShare,
  }) {
    return Container(
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkCardBg
            : ColorManager.blueSoftBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14.r),
        border: Border(
          left: BorderSide(
            color: tagColor,
            width: 4.w,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: REdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: tagColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: REdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorManager.darkSurface
                        : ColorManager.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capital Share',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: isDark
                              ? ColorManager.darkSlateText
                              : ColorManager.greySecondaryText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$${_formatCurrency(capitalShare)}',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  padding: REdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorManager.darkGreenContainer
                        : ColorManager.greenAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profit Share',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: isDark
                              ? ColorManager.darkMutedText
                              : ColorManager.green,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$${_formatCurrency(profitShare)}',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? ColorManager.darkAccentGreen
                              : ColorManager.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3. CUSTOMER FINANCIAL EXPOSURE CARD (IMAGE 3)
  // ===========================================================================
  Widget _buildCustomerExposureCard(bool isDark) {
    final isSafe = _netCustomerExposure >= 0;

    return _buildSectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildCardHeader(
            isDark: isDark,
            icon: Icons.hourglass_empty_rounded,
            title: '3. Customer Financial Exposure Calculator',
            subtitle: 'Receivables, payables & operating margins',
            badgeText: 'Real-Time',
            badgeBg: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.blueSoftBackground,
            badgeTextColor: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
          ),
          SizedBox(height: 14.h),

          // Equation Banner
          _buildEquationBanner(
            isDark: isDark,
            text: 'Net Position = Total Receivables - Total Payables',
          ),
          SizedBox(height: 16.h),

          // Total Receivables
          _buildLabel('Total Receivables / Inflows (\$)'),
          SizedBox(height: 6.h),
          _buildInputField(
            controller: _receivablesController,
            prefixIcon: Icons.north_east,
            prefixIconColor: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.green,
            onChanged: (_) => _recalculateAll(),
          ),
          SizedBox(height: 12.h),

          // Total Payables
          _buildLabel('Total Payables / Obligations (\$)'),
          SizedBox(height: 6.h),
          _buildInputField(
            controller: _payablesController,
            prefixIcon: Icons.south_west,
            prefixIconColor: isDark
                ? ColorManager.redErrorDark
                : ColorManager.red,
            onChanged: (_) => _recalculateAll(),
          ),
          SizedBox(height: 12.h),

          // Operating Expenses
          _buildLabel('Operating Expenses (\$)'),
          SizedBox(height: 6.h),
          _buildInputField(
            controller: _expensesController,
            prefixIcon: Icons.receipt_long_outlined,
            onChanged: (_) => _recalculateAll(),
          ),
          SizedBox(height: 16.h),

          // Exposure Result Box
          Container(
            padding: REdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSafe
                  ? (isDark
                  ? ColorManager.darkGreenContainer
                  : ColorManager.greenAccent.withOpacity(0.35))
                  : (isDark
                  ? ColorManager.darkRedContainer
                  : ColorManager.redLight),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(
                  isSafe ? Icons.verified_user_outlined : Icons.warning_amber_outlined,
                  size: 24.r,
                  color: isSafe
                      ? (isDark ? ColorManager.darkAccentGreen : ColorManager.green)
                      : (isDark ? ColorManager.redErrorDark : ColorManager.red),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Customer Exposure Position',
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isSafe
                              ? (isDark
                              ? ColorManager.darkMutedText
                              : ColorManager.green)
                              : (isDark
                              ? ColorManager.darkMutedText
                              : ColorManager.redDark),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${isSafe ? '+' : ''}\$${_formatCurrency(_netCustomerExposure)}',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isSafe
                              ? (isDark
                              ? ColorManager.darkAccentGreen
                              : ColorManager.green)
                              : (isDark
                              ? ColorManager.redErrorDark
                              : ColorManager.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSafe
                        ? (isDark
                        ? ColorManager.darkAccentGreen
                        : ColorManager.primaryColor)
                        : (isDark
                        ? ColorManager.redErrorDark
                        : ColorManager.red),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    isSafe ? 'Safe Surplus' : 'Deficit Risk',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          // Net Operating Balance Box
          Container(
            padding: REdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? ColorManager.darkSurfaceVariant
                  : ColorManager.blueSoftBackground,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Operating Balance (Inflows - Expenses)',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: isDark
                              ? ColorManager.darkSlateText
                              : ColorManager.greySecondaryText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '+${_formatCurrency(_netOperatingBalance)} (Surplus)',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? ColorManager.darkAccentGreen
                              : ColorManager.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.green,
                  size: 22.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. TRANSACTION DATE STAMPING CARD (IMAGE 4)
  // ===========================================================================
  Widget _buildDateStampingCard(bool isDark) {
    return _buildSectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildCardHeader(
            isDark: isDark,
            icon: Icons.calendar_month_outlined,
            title: '4. Transaction Date & Period Stamping',
            subtitle: 'Chronos mode selection & memo',
          ),
          SizedBox(height: 14.h),

          _buildLabel('Select Stamping Mode'),
          SizedBox(height: 8.h),

          // Option 1: System Date (Today)
          _buildStampingOptionTile(
            isDark: isDark,
            index: 0,
            icon: Icons.check_circle_outline,
            title: 'System Date (${DateFormat('dd MMM yyyy').format(DateTime.now())})',
            onTap: () {
              setState(() {
                _selectedStampingMode = 0;
                _selectedDate = DateTime.now();
              });
            },
          ),
          SizedBox(height: 8.h),

          // Option 2: Manual Override Picker
          _buildStampingOptionTile(
            isDark: isDark,
            index: 1,
            icon: Icons.edit_calendar_outlined,
            title: _selectedStampingMode == 1
                ? 'Selected: ${DateFormat('dd MMM yyyy').format(_selectedDate)}'
                : 'Manual Override Picker',
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _selectedStampingMode = 1;
                  _selectedDate = picked;
                });
              }
            },
          ),
          SizedBox(height: 8.h),

          // Option 3: Cleared
          _buildStampingOptionTile(
            isDark: isDark,
            index: 2,
            icon: Icons.bolt_outlined,
            title: 'Cleared (Immediate settlement)',
            onTap: () {
              setState(() {
                _selectedStampingMode = 2;
              });
            },
          ),
          SizedBox(height: 16.h),

          // Note Field
          _buildLabel('Custom Ledger Note / Memo'),
          SizedBox(height: 6.h),
          TextFormField(
            controller: _ledgerNoteController,
            decoration: const InputDecoration(
              hintText: 'e.g. Q4 Capital adjustment',
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
        ],
      ),
    );
  }

  // Option Builder for Stamping Modes
  Widget _buildStampingOptionTile({
    required bool isDark,
    required int index,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedStampingMode == index;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: REdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
              ? ColorManager.darkSurfaceVariant
              : ColorManager.navyDark)
              : (isDark
              ? ColorManager.darkSurface
              : ColorManager.blueSoftBackground),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? (isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.navyDark)
                : Colors.transparent,
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.r,
              color: isSelected
                  ? ColorManager.white
                  : (isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greyDark),
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? ColorManager.white
                    : (isDark
                    ? ColorManager.darkMutedText
                    : ColorManager.greyDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // COMMON UI HELPER WIDGETS
  // ===========================================================================
  Widget _buildSectionCard({
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? ColorManager.darkSurfaceVariant
              : ColorManager.blueLightTint,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : ColorManager.blueSoftBackground,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCardHeader({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeBg,
    Color? badgeTextColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: REdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.blueSoftBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            size: 22.r,
            color: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? ColorManager.white : ColorManager.navyText,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  color: isDark
                      ? ColorManager.darkMutedText
                      : ColorManager.greySecondaryText,
                ),
              ),
            ],
          ),
        ),
        if (badgeText != null)
          Container(
            padding: REdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              badgeText,
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.bold,
                color: badgeTextColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEquationBanner({
    required bool isDark,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkSurfaceVariant
            : ColorManager.blueSoftBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border(
          left: BorderSide(
            color: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
            width: 4.w,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Σ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? ColorManager.darkAccentGreen
                  : ColorManager.primaryColor,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? ColorManager.white : ColorManager.navyText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark
            ? ColorManager.darkMutedText
            : ColorManager.greyDark,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    IconData? prefixIcon,
    Color? prefixIconColor,
    String? suffixText,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      style: GoogleFonts.inter(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20.r, color: prefixIconColor)
            : Container(
          width: 32.w,
          alignment: Alignment.center,
          child: Text(
            '\$',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        suffixText: suffixText,
      ),
    );
  }

  Widget _buildOutputResultBox({
    required bool isDark,
    required String label,
    required String value,
    required Color valueColor,
    Widget? leadingWidget,
  }) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greySecondaryText,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                SizedBox(width: 6.w),
              ],
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(amount);
  }
}