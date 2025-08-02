import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

// Enums para tipos de campo
enum FieldType { text, email, phone, currency, url, dni, ruc }

enum ValidationState { none, loading, valid, invalid }

// 🚀 ENUM PARA PAÍSES (MEJORADO)
enum CountryCode {
  peru('+51', 9),
  colombia('+57', 10),
  ecuador('+593', 9),
  chile('+56', 9);

  const CountryCode(this.code, this.phoneLength);
  final String code;
  final int phoneLength;
}

// 🚀 CONSTANTES CENTRALIZADAS
class CustomTextFieldConstants {
  static const Duration defaultValidationDelay = Duration(milliseconds: 800);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const double defaultHeight = 40.0;
  static const double defaultBorderRadius = 6.0;
  static const double defaultBorderWidth = 0.5;
  static const int defaultDecimalPlaces = 2;

  // Colores por defecto
  static const Color defaultBackgroundColor = Color.fromARGB(
    255,
    255,
    255,
    255,
  );
  static const Color defaultFocusedBorderColor = Color(0xFFE0E0E0);
  static const Color defaultBorderColor = Color(0xFFF0F0F0);
}

// 🚀 FORMATEADOR DE MONEDA MEJORADO
class CurrencyFormatter extends TextInputFormatter {
  final String symbol;
  final int decimalPlaces;

  CurrencyFormatter({
    this.symbol = 'S/',
    this.decimalPlaces = CustomTextFieldConstants.defaultDecimalPlaces,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Extraer solo números y punto decimal del texto ingresado
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Manejar punto decimal
    List<String> parts = digitsOnly.split('.');
    if (parts.length > 2) {
      parts = [parts[0], parts.sublist(1).join('')];
    }

    // Limitar decimales
    if (parts.length == 2 && parts[1].length > decimalPlaces) {
      parts[1] = parts[1].substring(0, decimalPlaces);
    }

    // Formatear con separador de miles
    String integerPart = parts[0];
    if (integerPart.isNotEmpty) {
      integerPart = _addThousandsSeparator(integerPart);
    }

    String formatted = integerPart;
    if (parts.length == 2) {
      formatted += '.${parts[1]}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _addThousandsSeparator(String number) {
    if (number.length <= 3) return number;

    String reversed = number.split('').reversed.join('');
    String withCommas = '';
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        withCommas += ',';
      }
      withCommas += reversed[i];
    }
    return withCommas.split('').reversed.join('');
  }
}

// 🚀 UTILIDADES DE MONEDA MEJORADAS
class CurrencyUtils {
  static String formatForDisplay(String value, String symbol) {
    if (value.isEmpty) return '';
    return '$symbol $value';
  }

  static String extractNumericValue(String formattedValue, String symbol) {
    if (formattedValue.isEmpty) return '';
    return formattedValue.replaceFirst('$symbol ', '').replaceAll(',', '');
  }

  // 🚀 MÉTODO MEJORADO PARA PARSEAR CON DECIMALES CORRECTOS
  static double parseToDouble(String value) {
    if (value.isEmpty) return 0.0;
    String cleaned = value.replaceAll(',', '');

    // Si no tiene punto decimal, agregar .00
    if (!cleaned.contains('.')) {
      cleaned += '.00';
    } else {
      // Si tiene punto decimal, asegurar que tenga 2 decimales
      List<String> parts = cleaned.split('.');
      if (parts.length == 2) {
        if (parts[1].length == 1) {
          parts[1] += '0'; // Agregar un cero si solo tiene un decimal
        } else if (parts[1].length > 2) {
          parts[1] = parts[1].substring(0, 2); // Limitar a 2 decimales
        }
        cleaned = '${parts[0]}.${parts[1]}';
      }
    }

    return double.tryParse(cleaned) ?? 0.0;
  }

  // 🚀 MÉTODO PARA FORMATEAR VALOR CON DECIMALES CORRECTOS
  static String formatWithDecimals(double value) {
    return value.toStringAsFixed(2);
  }

  // 🚀 MÉTODO PARA OBTENER VALOR COMO STRING CON DECIMALES
  static String getValueAsString(double value) {
    return value.toStringAsFixed(2);
  }

  static bool isValidCurrency(String value) {
    if (value.isEmpty) return false;
    String cleaned = value.replaceAll(',', '');
    return double.tryParse(cleaned) != null;
  }
}

// 🚀 UTILIDADES DE TELÉFONO MEJORADAS (SOLO VERSIÓN ENUM)
class PhoneUtils {
  static String getPhoneForDatabase(String value, CountryCode country) {
    if (value.isEmpty) return '';
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    return '${country.code}$digitsOnly';
  }

  static bool isValidPhone(String value, CountryCode country) {
    if (value.isEmpty) return false;
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length == country.phoneLength;
  }

  static String formatFromDatabase(String dbValue, CountryCode country) {
    if (dbValue.isEmpty) return '';
    String digitsOnly = dbValue
        .replaceFirst(country.code, '')
        .replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length == country.phoneLength) {
      switch (country) {
        case CountryCode.peru:
        case CountryCode.ecuador:
        case CountryCode.chile:
          return '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6)}';
        case CountryCode.colombia:
          return '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 3 + 3)} ${digitsOnly.substring(6)}';
      }
    }
    return digitsOnly;
  }
}

// 🚀 FORMATEADOR DE TELÉFONO
class PhoneFormatterDynamic extends TextInputFormatter {
  final CountryCode country;
  final int maxDigits;

  PhoneFormatterDynamic({required this.country})
    : maxDigits = country.phoneLength;

  factory PhoneFormatterDynamic.fromCountry(CountryCode country) =>
      PhoneFormatterDynamic(country: country);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // 🚀 USAR maxDigits dinámico en lugar de hardcoded
    if (digitsOnly.length > maxDigits) {
      digitsOnly = digitsOnly.substring(0, maxDigits);
    }

    // Formatear según el país
    String formatted = _formatByCountry(digitsOnly);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatByCountry(String digits) {
    switch (country) {
      case CountryCode.peru:
      case CountryCode.ecuador:
      case CountryCode.chile:
        if (digits.length <= 3) {
          return digits;
        } else if (digits.length <= 6) {
          return '${digits.substring(0, 3)} ${digits.substring(3)}';
        } else {
          return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
        }
      case CountryCode.colombia:
        if (digits.length <= 3) {
          return digits;
        } else if (digits.length <= 6) {
          return '${digits.substring(0, 3)} ${digits.substring(3)}';
        } else {
          return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
        }
    }
  }
}

// 🚀 FORMATEADOR DE DNI
class DniFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Solo permitir números
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Limitar a 8 dígitos
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

// 🚀 FORMATEADOR DE RUC
class RucFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Solo permitir números
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Limitar a 11 dígitos
    if (digitsOnly.length > 11) {
      digitsOnly = digitsOnly.substring(0, 11);
    }

    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

// 🚀 VALIDADORES MEJORADOS (SOLO UNA VERSIÓN)
class FieldValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';

    // Validación más estricta
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return 'Email inválido';

    // Validaciones adicionales
    if (value.length > 254) return 'Email demasiado largo';
    if (value.contains('..')) return 'Email inválido';

    return null;
  }

  static String? validatePhone(String? value, {required CountryCode country}) {
    if (value == null || value.isEmpty) return 'Campo requerido';

    if (!PhoneUtils.isValidPhone(value, country)) {
      return 'Teléfono debe tener ${country.phoneLength} dígitos';
    }

    return null;
  }

  static String? validateCurrency(
    String? value, {
    double? minAmount,
    double? maxAmount,
  }) {
    if (value == null || value.isEmpty) return 'Campo requerido';

    if (!CurrencyUtils.isValidCurrency(value)) {
      return 'Monto inválido';
    }

    double amount = CurrencyUtils.parseToDouble(value);

    if (amount <= 0) return 'El monto debe ser mayor a 0';

    if (minAmount != null && amount < minAmount) {
      return 'Monto mínimo: S/ ${minAmount.toStringAsFixed(2)}';
    }

    if (maxAmount != null && amount > maxAmount) {
      return 'Monto máximo: S/ ${maxAmount.toStringAsFixed(2)}';
    }

    return null;
  }

  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    final urlRegex = RegExp(
      r'^https?://[\w\-]+(\.[\w\-]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
    );
    if (!urlRegex.hasMatch(value)) return 'URL inválida';
    return null;
  }

  // 🚀 VALIDADORES PARA DNI Y RUC
  static String? validateDni(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';

    // Solo números
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length != 8) {
      return 'DNI debe tener 8 dígitos';
    }

    return null;
  }

  static String? validateRuc(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';

    // Solo números
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length != 11) {
      return 'RUC debe tener 11 dígitos';
    }

    return null;
  }
}

// 🚀 WIDGET PRINCIPAL
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final Color? colorIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool filled;
  final FocusNode? focusNode;
  final double? height;
  final double? borderWidth;

  // Propiedades de validación y formateo
  final FieldType fieldType;
  final bool showValidationIndicator;
  final Duration validationDelay;
  final Future<String?> Function(String)? asyncValidator;
  final CountryCode country;
  final String currencySymbol;
  final bool enableRealTimeValidation;
  

   const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.backgroundColor = CustomTextFieldConstants.defaultBackgroundColor,
    this.borderColor,
    this.borderRadius = CustomTextFieldConstants.defaultBorderRadius,
    this.colorIcon,
    this.contentPadding,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.filled = true,
    this.focusNode,
    this.height = CustomTextFieldConstants.defaultHeight,
    this.borderWidth = CustomTextFieldConstants.defaultBorderWidth,
    this.fieldType = FieldType.text,
    this.showValidationIndicator = true,
    this.validationDelay = CustomTextFieldConstants.defaultValidationDelay,
    this.asyncValidator,
    this.country = CountryCode.peru,
    this.currencySymbol = 'S/',
    this.enableRealTimeValidation = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  bool _hasText = false;
  bool _isObscured = false;
  ValidationState _validationState = ValidationState.none;
  String? _validationError;

  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _shadowAnimation;
  late Animation<double> _scaleAnimation;

  Timer? _validationTimer;

  // 🚀 CACHE PARA OPTIMIZACIÓN
  Color? _cachedBorderColor;
  Color? _cachedShadowColor;
  TextStyle? _cachedTextStyle;
  TextStyle? _cachedHintStyle;
  TextStyle? _cachedLabelStyle;
  BorderRadius? _cachedBorderRadius;
  EdgeInsetsGeometry? _cachedContentPadding;
  List<TextInputFormatter>? _cachedInputFormatters;
  TextInputType? _cachedKeyboardType;
  Widget? _cachedPrefixIcon;
  String? _cachedPrefixText;
  List<BoxShadow>? _cachedShadows;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    _animationController = AnimationController(
      duration: CustomTextFieldConstants.defaultAnimationDuration,
      vsync: this,
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    if (widget.controller != null) {
      _hasText = widget.controller!.text.isNotEmpty;
      widget.controller!.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _validationTimer?.cancel();
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    if (widget.controller != null) {
      widget.controller!.removeListener(_onTextChanged);
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChanged() {
    final hasText = widget.controller!.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }

    if (widget.enableRealTimeValidation &&
        widget.showValidationIndicator &&
        hasText) {
      _startValidation();
    } else if (!widget.enableRealTimeValidation || !hasText) {
      _clearValidationState();
    }
  }

  void _clearValidationState() {
    _validationTimer?.cancel();
    if (_validationState != ValidationState.none) {
      setState(() {
        _validationState = ValidationState.none;
        _validationError = null;
      });
    }
  }

  void _startValidation() {
    _validationTimer?.cancel();

    setState(() {
      _validationState = ValidationState.loading;
    });

    _validationTimer = Timer(widget.validationDelay, () async {
      await _performValidation();
    });
  }

  Future<void> _performValidation() async {
    if (!mounted) return;

    final value = widget.controller?.text ?? '';
    String? error;

    // Validación síncrona predefinida
    switch (widget.fieldType) {
      case FieldType.email:
        error = FieldValidators.validateEmail(value);
        break;
      case FieldType.phone:
        error = FieldValidators.validatePhone(value, country: widget.country);
        break;
      case FieldType.currency:
        error = FieldValidators.validateCurrency(value);
        break;
      case FieldType.url:
        error = FieldValidators.validateUrl(value);
        break;
      case FieldType.dni:
        error = FieldValidators.validateDni(value);
        break;
      case FieldType.ruc:
        error = FieldValidators.validateRuc(value);
        break;
      default:
        break;
    }

    if (error == null && widget.validator != null) {
      error = widget.validator!(value);
    }

    if (error == null && widget.asyncValidator != null) {
      try {
        error = await widget.asyncValidator!(value);
      } catch (e) {
        error = 'Error de validación';
      }
    }

    if (mounted) {
      setState(() {
        _validationState = error == null
            ? ValidationState.valid
            : ValidationState.invalid;
        _validationError = error;
      });
    }
  }

  Future<bool> validateManually() async {
    if (!widget.enableRealTimeValidation) {
      await _performValidation();
      return _validationState == ValidationState.valid;
    }
    return _validationState == ValidationState.valid;
  }

  // Métodos públicos para obtener valores
  double get currencyValue {
    if (widget.fieldType != FieldType.currency) return 0.0;
    final value = widget.controller?.text ?? '';
    return CurrencyUtils.parseToDouble(value);
  }

  String get currencyValueAsString {
    if (widget.fieldType != FieldType.currency) return '';
    final value = widget.controller?.text ?? '';
    return CurrencyUtils.extractNumericValue(value, widget.currencySymbol);
  }

  void setCurrencyValue(double value) {
    if (widget.fieldType != FieldType.currency) return;
    final formatted = value.toStringAsFixed(2);
    widget.controller?.text = formatted;
  }

  String get phoneValue {
    if (widget.fieldType != FieldType.phone) return '';
    final value = widget.controller?.text ?? '';
    return PhoneUtils.getPhoneForDatabase(value, widget.country);
  }

  void setPhoneValue(String phoneNumber) {
    if (widget.fieldType != FieldType.phone) return;
    final formatted = PhoneUtils.formatFromDatabase(
      phoneNumber,
      widget.country,
    );
    widget.controller?.text = formatted;
  }

  // 🚀 MÉTODOS OPTIMIZADOS CON CACHE
  TextInputType _getCachedKeyboardType() {
    return _cachedKeyboardType ??= _getKeyboardType();
  }

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.currency:
        return const TextInputType.numberWithOptions(decimal: true);
      case FieldType.url:
        return TextInputType.url;
      case FieldType.dni:
      case FieldType.ruc:
        return TextInputType.number;
      default:
        return widget.keyboardType;
    }
  }

  List<TextInputFormatter> _getCachedInputFormatters() {
    return _cachedInputFormatters ??= _getInputFormatters();
  }

  List<TextInputFormatter> _getInputFormatters() {
    List<TextInputFormatter> formatters = widget.inputFormatters ?? [];

    switch (widget.fieldType) {
      case FieldType.phone:
        // 🚀 USAR FORMATTER DINÁMICO
        formatters.insert(0, PhoneFormatterDynamic.fromCountry(widget.country));
        break;
      case FieldType.currency:
        formatters.insert(0, CurrencyFormatter(symbol: widget.currencySymbol));
        break;
      case FieldType.email:
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'\s')));
        break;
      case FieldType.dni:
        formatters.insert(0, DniFormatter());
        break;
      case FieldType.ruc:
        formatters.insert(0, RucFormatter());
        break;
      default:
        break;
    }

    return formatters;
  }

  Widget? _getCachedPrefixIcon() {
    return _cachedPrefixIcon ??= _getPrefixIcon();
  }

  Widget? _getPrefixIcon() {
    if (widget.prefixIcon != null) {
      return _buildIconWrapper(widget.prefixIcon!);
    }

    IconData? icon;
    switch (widget.fieldType) {
      case FieldType.email:
        icon = Icons.email_outlined;
        break;
      case FieldType.phone:
        icon = Icons.phone_outlined;
        break;
      case FieldType.currency:
        icon = Icons.attach_money_outlined;
        break;
      case FieldType.url:
        icon = Icons.link_outlined;
        break;
      case FieldType.dni:
        icon = Icons.badge_outlined;
        break;
      case FieldType.ruc:
        icon = Icons.business_outlined;
        break;
      default:
        return null;
    }

    return _buildIconWrapper(Icon(icon));
  }

  String? _getCachedPrefixText() {
    return _cachedPrefixText ??= _getPrefixText();
  }

  String? _getPrefixText() {
    if (widget.prefixText != null) return widget.prefixText;

    // Solo mostrar prefijo cuando tiene foco
    if (_isFocused) {
      switch (widget.fieldType) {
        case FieldType.currency:
          return '${widget.currencySymbol} ';
        case FieldType.phone:
          return '${widget.country.code} ';
        default:
          break;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final showCounter = widget.maxLength != null && widget.controller != null;
    final counterText = showCounter
        ? '${widget.controller!.text.length}/${widget.maxLength}'
        : '';

    Widget textField = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.filled
                  ? widget.backgroundColor
                  : Colors.transparent,
              borderRadius: _getCachedBorderRadius(),
              boxShadow: widget.filled ? _getCachedShadows() : null,
              border: Border.all(
                color: _getCachedBorderColor(),
                width: widget.borderWidth ?? 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: _getCachedBorderRadius(),
              child: TextFormField(                
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: _getCachedKeyboardType(),
                obscureText: _isObscured,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                inputFormatters: _getCachedInputFormatters(),
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  if (showCounter) setState(() {}); // Actualiza el contador
                },
                onFieldSubmitted: widget.onSubmitted,
                validator: widget.enableRealTimeValidation
                    ? null
                    : widget.validator,
                style: _getCachedTextStyle(),
                decoration: InputDecoration(                  
                  isDense: true,
                  hintText: widget.hintText,
                  prefixIcon: _getCachedPrefixIcon(),
                  suffixIcon: _buildSuffixIcon(),
                  prefixText: _getCachedPrefixText(),
                  suffixText: widget.suffixText,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: _getCachedContentPadding(),
                  hintStyle: _getCachedHintStyle(),
                  counterText: '', // Oculta el contador por defecto
                ),
              ),
            ),
          ),
        );
      },
    );

    if (showCounter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              textField,
              Positioned(
                right: 8,
                bottom: 1,
                child: Text(
                  counterText,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
          if (widget.enableRealTimeValidation &&
              _validationState == ValidationState.invalid &&
              _validationError != null) ...[
            const SizedBox(height: 6),
            Text(
              _validationError!,
              style: const TextStyle(
                color: AppColors.red,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: _getCachedLabelStyle()),
          const SizedBox(height: 2),
        ],
        textField,
        if (widget.enableRealTimeValidation &&
            _validationState == ValidationState.invalid &&
            _validationError != null) ...[
          const SizedBox(height: 3),
          Text(
            _validationError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  // 🚀 MÉTODOS CACHEADOS
  Color _getCachedBorderColor() {
    return _cachedBorderColor ??= _getBorderColor();
  }

  Color _getBorderColor() {
    return widget.borderColor ??
        (_isFocused
            ? CustomTextFieldConstants.defaultFocusedBorderColor
            : CustomTextFieldConstants.defaultBorderColor);
  }

  TextStyle _getCachedTextStyle() {
    return _cachedTextStyle ??=
        widget.textStyle ??
        TextStyle(
          color: widget.enabled ? Colors.black87 : Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.2,
        );
  }

  TextStyle _getCachedHintStyle() {
    return _cachedHintStyle ??=
        widget.hintStyle ??
        TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.2,
        );
  }

  TextStyle _getCachedLabelStyle() {
    return _cachedLabelStyle ??=
        widget.labelStyle ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.blue,
        );
  }

  BorderRadius _getCachedBorderRadius() {
    return _cachedBorderRadius ??= BorderRadius.circular(widget.borderRadius);
  }

  EdgeInsetsGeometry _getCachedContentPadding() {
    return _cachedContentPadding ??=
        widget.contentPadding ?? _getDefaultContentPadding();
  }

  List<BoxShadow> _getCachedShadows() {
    return _cachedShadows ??= _buildShadows();
  }

  Widget _buildIconWrapper(Widget icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: IconTheme(
        data: IconThemeData(
          color:
              widget.colorIcon ??
              widget.borderColor ??
              (_isFocused ? const Color(0xFF666666) : Colors.grey[600]),
          size: 20,
        ),
        child: icon,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.enableRealTimeValidation &&
        widget.showValidationIndicator &&
        _hasText) {
      Widget validationIcon = _buildValidationIndicator();

      if (widget.obscureText) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            validationIcon,
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                _isObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
              color: _isFocused ? const Color(0xFF666666) : Colors.grey[600],
              iconSize: 20,
              splashRadius: 20,
              tooltip: _isObscured
                  ? 'Mostrar contraseña'
                  : 'Ocultar contraseña',
            ),
          ],
        );
      }

      return validationIcon;
    }

    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
        color: _isFocused ? const Color(0xFF666666) : Colors.grey[600],
        iconSize: 20,
        splashRadius: 20,
        tooltip: _isObscured ? 'Mostrar contraseña' : 'Ocultar contraseña',
      );
    }

    if (widget.suffixIcon != null) {
      return _buildIconWrapper(widget.suffixIcon!);
    }

    return null;
  }

  Widget _buildValidationIndicator() {
    switch (_validationState) {
      case ValidationState.loading:
        return SizedBox(
          width: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        );
      case ValidationState.valid:
        return Container(
          margin: const EdgeInsets.only(right: 12),
          child: const Icon(Icons.check_circle, color: Colors.green, size: 16),
        );
      case ValidationState.invalid:
        return Container(
          margin: const EdgeInsets.only(right: 12),
          child: const Icon(Icons.error, color: Colors.red, size: 16),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  EdgeInsetsGeometry _getDefaultContentPadding() {
    if (widget.height != null) {
      double verticalPadding = (widget.height! - 20) / 2;
      verticalPadding = verticalPadding.clamp(8.0, 20.0);

      return EdgeInsets.symmetric(
        horizontal: (_getCachedPrefixIcon() != null) ? 12 : 16,
        vertical: verticalPadding,
      );
    }

    return EdgeInsets.symmetric(
      horizontal: (_getCachedPrefixIcon() != null) ? 12 : 16,
      vertical: widget.maxLines == 1 ? 14 : 12,
    );
  }

  List<BoxShadow> _buildShadows() {
    final double intensity = _shadowAnimation.value;
    final Color currentBorderColor = _getCachedBorderColor();
    Color shadowColor = _getCachedShadowColor(currentBorderColor);

    if (_isFocused) {
      return [
        BoxShadow(
          color: currentBorderColor.withValues(alpha: 0.3 + (intensity * 0.2)),
          offset: const Offset(0, 3),
          blurRadius: 4 + (intensity * 2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.6),
          offset: const Offset(-1, -1),
          blurRadius: 2,
          spreadRadius: -1,
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.18),
          offset: const Offset(4, 4),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: currentBorderColor.withValues(alpha: 0.15),
          offset: const Offset(1, 1),
          blurRadius: 4,
          spreadRadius: -1,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.8),
          offset: const Offset(-2, -2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ];
    }
  }

  Color _getCachedShadowColor(Color borderColor) {
    return _cachedShadowColor ??= _getShadowColorFromBorder(borderColor);
  }

  Color _getShadowColorFromBorder(Color borderColor) {
    if (borderColor == AppColors.blue ||
        borderColor == const Color(0xFF1976D2)) {
      return const Color(0xFF0D47A1);
    } else if (borderColor == Colors.red ||
        borderColor == const Color(0xFFD32F2F)) {
      return const Color(0xFF8D1E1E);
    } else if (borderColor == Colors.green ||
        borderColor == const Color(0xFF4CAF50)) {
      return const Color(0xFF1B5E20);
    } else if (borderColor == Colors.purple ||
        borderColor == const Color(0xFF9C27B0)) {
      return const Color(0xFF4A148C);
    } else {
      HSLColor hsl = HSLColor.fromColor(borderColor);
      return HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        (hsl.saturation * 0.9).clamp(0.0, 1.0),
        (hsl.lightness * 0.25).clamp(0.0, 0.4),
      ).toColor();
    }
  }
}

// 🚀 EXTENSIÓN PARA TextEditingController
extension CustomTextFieldControllerExtension on TextEditingController {
  // MÉTODOS PARA MONEDA MEJORADOS
  double get currencyValue => CurrencyUtils.parseToDouble(text);
  String get currencyString => CurrencyUtils.extractNumericValue(text, 'S/');
  void setCurrencyValue(double value) =>
      text = CurrencyUtils.formatWithDecimals(value);
  bool get isValidCurrency => CurrencyUtils.isValidCurrency(text);

  // 🚀 NUEVOS MÉTODOS PARA MONEDA
  String get currencyValueAsString =>
      CurrencyUtils.getValueAsString(currencyValue);
  void setCurrencyValueAsString(String value) => text = value;

  // MÉTODOS PARA TELÉFONO
  String phoneValue(CountryCode country) =>
      PhoneUtils.getPhoneForDatabase(text, country);
  void setPhoneValue(String phoneFromDB, CountryCode country) =>
      text = PhoneUtils.formatFromDatabase(phoneFromDB, country);
  bool isValidPhone(CountryCode country) =>
      PhoneUtils.isValidPhone(text, country);
  String get phoneDigits => text.replaceAll(RegExp(r'[^\d]'), '');

  // MÉTODOS MEJORADOS CON ENUM
  String phoneValueEnhanced(CountryCode country) =>
      PhoneUtils.getPhoneForDatabase(text, country);
  void setPhoneValueEnhanced(String phoneFromDB, CountryCode country) =>
      text = PhoneUtils.formatFromDatabase(phoneFromDB, country);
  bool isValidPhoneEnhanced(CountryCode country) =>
      PhoneUtils.isValidPhone(text, country);
}

extension CountryCodeExtension on CountryCode {
  static CountryCode fromCode(String code) {
    switch (code) {
      case '+51':
        return CountryCode.peru;
      case '+57':
        return CountryCode.colombia;
      case '+593':
        return CountryCode.ecuador;
      case '+56':
        return CountryCode.chile;
      default:
        return CountryCode.peru; // Default
    }
  }
}

// 🚀 HELPERS PARA CREAR CAMPOS COMUNES FÁCILMENTE
class CustomTextFieldHelpers {
  /// Crea un campo de moneda con validaciones automáticas
  static CustomTextField currency({
    required String label,
    required TextEditingController controller,
    String? hintText,
    String currencySymbol = 'S/',
    double? minAmount,
    double? maxAmount,
    Color? borderColor,
    Function(String)? onChanged,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText ?? '0.00',
      controller: controller,
      fieldType: FieldType.currency,
      currencySymbol: currencySymbol,
      borderColor: borderColor,
      enableRealTimeValidation: enableRealTimeValidation,
      validator: (value) => FieldValidators.validateCurrency(
        value,
        minAmount: minAmount,
        maxAmount: maxAmount,
      ),
      onChanged: onChanged,
    );
  }

  /// Crea un campo de teléfono con formato automático
  static CustomTextField phone({
    required String label,
    required TextEditingController controller,
    String? hintText,
    CountryCode country = CountryCode.peru,
    Color? borderColor,
    Function(String)? onChanged,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText ?? 'Número de teléfono',
      controller: controller,
      fieldType: FieldType.phone,
      country: country,
      borderColor: borderColor,
      enableRealTimeValidation: enableRealTimeValidation,
      validator: (value) =>
          FieldValidators.validatePhone(value, country: country),
      onChanged: onChanged,
    );
  }

  /// Crea un campo de email con validación estricta
  static CustomTextField email({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Color? borderColor,
    Function(String)? onChanged,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText ?? 'correo@ejemplo.com',
      controller: controller,
      fieldType: FieldType.email,
      borderColor: borderColor,
      enableRealTimeValidation: enableRealTimeValidation,
      validator: FieldValidators.validateEmail,
      onChanged: onChanged,
    );
  }

  /// Crea un campo de URL con validación
  static CustomTextField url({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Color? borderColor,
    Function(String)? onChanged,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText ?? 'https://ejemplo.com',
      controller: controller,
      fieldType: FieldType.url,
      borderColor: borderColor,
      enableRealTimeValidation: enableRealTimeValidation,
      validator: FieldValidators.validateUrl,
      onChanged: onChanged,
    );
  }

  /// Crea un campo de DNI con validación automática
  static CustomTextField dni({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Color? borderColor,
    Function(String)? onChanged,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText ?? '12345678',
      controller: controller,
      fieldType: FieldType.dni,
      maxLength: 8,
      borderColor: borderColor,
      enableRealTimeValidation: enableRealTimeValidation,
      validator: FieldValidators.validateDni,
      onChanged: onChanged,
    );
  }

  /// Crea un campo de RUC con validación automática
  static CustomTextField ruc({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Color? borderColor,
    Function(String)? onChanged,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText ?? '12345678901',
      controller: controller,
      fieldType: FieldType.ruc,
      maxLength: 11,
      borderColor: borderColor,
      enableRealTimeValidation: enableRealTimeValidation,
      validator: FieldValidators.validateRuc,
      onChanged: onChanged,
    );
  }

  /// Crea un campo de texto normal con opciones comunes
  static CustomTextField text({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Color? borderColor,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    bool obscureText = false,
    int maxLines = 1,
    int? maxLength,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText,
      controller: controller,
      fieldType: FieldType.text,
      borderColor: borderColor,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      enableRealTimeValidation: enableRealTimeValidation,
      validator: validator,
      onChanged: onChanged,
    );
  }

  /// Crea un campo de contraseña con toggle de visibilidad
  static CustomTextField password({
    required String label,
    required TextEditingController controller,
    String? hintText,
    Color? borderColor,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    bool enableRealTimeValidation = true,
  }) {
    return CustomTextField(
      label: label,
      hintText: hintText ?? 'Ingresa tu contraseña',
      controller: controller,
      fieldType: FieldType.text,
      borderColor: borderColor,
      obscureText: true,
      enableRealTimeValidation: enableRealTimeValidation,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) return 'Campo requerido';
            if (value.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
      onChanged: onChanged,
    );
  }
}

// // 🚀 EJEMPLO DE USO COMPLETO
// class CustomTextFieldExampleUsage extends StatefulWidget {
//   @override
//   _CustomTextFieldExampleUsageState createState() => _CustomTextFieldExampleUsageState();
// }

// class _CustomTextFieldExampleUsageState extends State<CustomTextFieldExampleUsage> {
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _phoneController.dispose();
//     _priceController.dispose();
//     _nameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _handleSubmit() {
//     // 🚀 OBTENER VALORES PARA ENVIAR A API
//     Map<String, dynamic> formData = {
//       'name': _nameController.text,
//       'email': _emailController.text,
//       'phone': _phoneController.phoneValue(CountryCode.peru), // +51987654321
//       'price': _priceController.currencyValue, // 1250.75
//       'password': _passwordController.text,
//     };
    
//     print('Datos del formulario: $formData');
    
//     // Enviar a tu API
//     // await apiService.submitForm(formData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Formulario Completo')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // 🚀 USANDO HELPERS PARA CAMPOS COMUNES
//               CustomTextFieldHelpers.text(
//                 label: 'Nombre completo',
//                 controller: _nameController,
//                 hintText: 'Ingresa tu nombre',
//                 borderColor: Colors.blue,
//                 validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
//               ),
              
//               SizedBox(height: 16),
              
//               CustomTextFieldHelpers.email(
//                 label: 'Correo electrónico',
//                 controller: _emailController,
//                 borderColor: Colors.green,
//                 onChanged: (value) => print('Email: $value'),
//               ),
              
//               SizedBox(height: 16),
              
//               CustomTextFieldHelpers.phone(
//                 label: 'Teléfono',
//                 controller: _phoneController,
//                 country: CountryCode.peru,
//                 borderColor: Colors.orange,
//                 onChanged: (value) {
//                   String phoneDB = _phoneController.phoneValue(CountryCode.peru);
//                   print('Teléfono para BD: $phoneDB');
//                 },
//               ),
              
//               SizedBox(height: 16),
              
//               CustomTextFieldHelpers.currency(
//                 label: 'Precio',
//                 controller: _priceController,
//                 currencySymbol: 'PEN',
//                 minAmount: 1.0,
//                 maxAmount: 99999.99,
//                 borderColor: Colors.red,
//                 onChanged: (value) {
//                   double price = _priceController.currencyValue;
//                   print('Precio: $price');
//                 },
//               ),
              
//               SizedBox(height: 16),
              
//               CustomTextFieldHelpers.password(
//                 label: 'Contraseña',
//                 controller: _passwordController,
//                 borderColor: Colors.purple,
//               ),
              
//               SizedBox(height: 32),
              
//               // Botón de envío
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _handleSubmit,
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text('Enviar Formulario'),
//                 ),
//               ),
              
//               SizedBox(height: 20),
              
//               // 🚀 USO MANUAL PARA CASOS ESPECÍFICOS
//               CustomTextField(
//                 label: 'Campo personalizado',
//                 controller: TextEditingController(),
//                 fieldType: FieldType.text,
//                 borderColor: Colors.teal,
//                 prefixIcon: Icon(Icons.star),
//                 suffixIcon: Icon(Icons.favorite),
//                 validator: (value) {
//                   // Tu validación custom aquí
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }