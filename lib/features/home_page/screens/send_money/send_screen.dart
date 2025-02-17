import 'package:circle_flags/circle_flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMoneyForm extends StatefulWidget {
  const SendMoneyForm({super.key});

  @override
  State<SendMoneyForm> createState() => _SendMoneyFormState();
}

class _SendMoneyFormState extends State<SendMoneyForm> {
  String fromCurrency = "";
  String toCurrency = "";
  String exchangeRate = "1.37310";

  String? selectedOutlet;
  double? sendRate;
  String? localCurrency;
  String? foreignCurrency;
  String? selectedCurrency;
  double? buyRate;
  double? sellRate;
  String? outletId;
  String searchKeyword = '';
  final TextEditingController _sendController = TextEditingController();
  final TextEditingController _receiveController = TextEditingController();
  String? _currencyError;
  List<DropdownMenuItem<String>> _outletItems = [];
  List<Map<String, String>> _outletDisplayList = [];
  List<String> currencyCodes = [];
  List<Map<String, String>> _currencyDisplayList = [];

  TextEditingController searchOutletController = TextEditingController();
  List<Map<String, String>> filteredOutletList = []; // 🔥 Khai báo ở ngoài hàm

  final TextEditingController locationController = TextEditingController();
  Map<String, String> currencyToCountryCode = {
    'USD': 'us',
    'EUR': 'eu',
    'JPY': 'jp',
    'GBP': 'gb',
    'AUD': 'au',
    'CAD': 'ca',
    'CHF': 'ch',
    'CNY': 'cn',
    'SEK': 'se',
    'NZD': 'nz',
    'VND': 'vn',
    'THB': 'th',
    'SGD': 'sg',
    'MXN': 'mx',
    'BRL': 'br',
    'ZAR': 'za',
    'RUB': 'ru',
    'INR': 'in',
    'KRW': 'kr',
    'HKD': 'hk',
    'MYR': 'my',
    'PHP': 'ph',
    'IDR': 'id',
    'TRY': 'tr',
    'PLN': 'pl',
    'HUF': 'hu',
    'CZK': 'cz',
    'DKK': 'dk',
    'NOK': 'no',
    'ILS': 'il',
    'SAR': 'sa',
    'AED': 'ae',
    'EGP': 'eg',
    'ARS': 'ar',
    'CLP': 'cl',
    'COP': 'co',
    'PEN': 'pe',
    'PKR': 'pk',
    'BDT': 'bd',
    'LKR': 'lk',
    'KWD': 'kw',
    'BHD': 'bh',
    'OMR': 'om',
    'QAR': 'qa',
    'JOD': 'jo',
    'XOF': 'bj',
    'XAF': 'cm',
    'XCD': 'ag',
    'XPF': 'pf',
    'MAD': 'ma',
    'DZD': 'dz',
    'TND': 'tn',
    'LBP': 'lb',
    'JMD': 'jm',
    'TTD': 'tt',
    'NGN': 'ng',
    'GHS': 'gh',
    'KES': 'ke',
    'UGX': 'ug',
    'TZS': 'tz',
    'ETB': 'et',
    'ZMW': 'zm',
    'MZN': 'mz',
    'BWP': 'bw',
    'NAD': 'na',
    'SCR': 'sc',
    'MUR': 'mu',
    'BBD': 'bb',
    'BSD': 'bs',
    'FJD': 'fj',
    'SBD': 'sb',
    'PGK': 'pg',
    'TOP': 'to',
    'WST': 'ws',
    'KZT': 'kz',
    'UZS': 'uz',
    'TJS': 'tj',
    'KGS': 'kg',
    'MMK': 'mm',
    'LAK': 'la',
    'KHR': 'kh',
    'MNT': 'mn',
    'NPR': 'np',
    'BND': 'bn',
    'XAU': 'xau',
    'XAG': 'xag',
    'XPT': 'xpt',
    'XPD': 'xpd',
    'HTG': 'ht', // Haitian Gourde
    'LRD': 'lr', // Liberian Dollar
    'BIF': 'bi', // Burundian Franc
    'IQD': 'iq', // Iraqi Dinar
    'MGA': 'mg', // Malagasy Ariary
    'LSL': 'ls', // Lesotho Loti
    'AFA': 'af', // Afghan Afghani (cũ, thay bằng AFN)
    'CVE': 'cv', // Cape Verdean Escudo
    'BGN': 'bg', // Bulgarian Lev
    'LYD': 'ly', // Libyan Dinar
    'AWG': 'aw', // Aruban Florin
    'HRK': 'hr', // Croatian Kuna (đã đổi sang EUR từ 2023)
    'BZD': 'bz', // Belize Dollar
    'HNL': 'hn', // Honduran Lempira
    'MVR': 'mv', // Maldivian Rufiyaa
    'GYD': 'gy', // Guyanese Dollar
    'SVC': 'sv', // Salvadoran Colón
    'ISK': 'is', // Icelandic Króna
    'GNF': 'gn', // Guinean Franc
    'IRR': 'ir', // Iranian Rial
    'KYD': 'ky', // Cayman Islands Dollar
    'DJF': 'dj', // Djiboutian Franc
    'MWK': 'mw', // Malawian Kwacha
    'BOB': 'bo', // Bolivian Boliviano
    'LTL': 'lt', // Lithuanian Litas (đã đổi sang EUR)
    'AMD': 'am', // Armenian Dram
    'CRC': 'cr', // Costa Rican Colón
    'KMF': 'km', // Comorian Franc
    'AOR': 'ao', // Angolan Kwanza (cũ, thay bằng AOA)
    'ALL': 'al', // Albanian Lek
    'ERN': 'er', // Eritrean Nakfa
    'EEK': 'ee', // Estonian Kroon (đã đổi sang EUR)
    'GMD': 'gm', // Gambian Dalasi
    'GIP': 'gi', // Gibraltar Pound
    'CUP': 'cu', // Cuban Peso
    'BMD': 'bm', // Bermudian Dollar
    'FKP': 'fk', // Falkland Islands Pound
    'CDF': 'cd', // Congolese Franc
    'LVL': 'lv', // Latvian Lats (đã đổi sang EUR)
    'MKD': 'mk', // Macedonian Denar
    'GTQ': 'gt', // Guatemalan Quetzal
    'AZN': 'az', // Azerbaijani Manat
    'DOP': 'do', // Dominican Peso
    'BYN': 'by', // Belarusian Ruble
    'GEL': 'ge', // Georgian Lari
    'BTN': 'bt', // Bhutanese Ngultrum
    'MOP': 'mo', // Macanese Pataca
  };

  bool isSenderActive = true;
  bool isRecipientActive = true;
  String? _numericError;
  @override
  void initState() {
    super.initState();
    fetchOutlets();
    fetchCurrencyCodes();
    _setupTextFieldCurrencyListeners();
    _loadSavedInputs();
  }

  Future<void> _loadSavedInputs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lấy giá trị từ SharedPreferences
    _sendController.text = prefs.getString('sendAmount') ?? '';
    _receiveController.text = prefs.getString('receiveAmount') ?? '';

    // Lấy outletId từ SharedPreferences (lưu ID chứ không phải tên)
    String selectedOutletId = prefs.getString('selectedOutlet') ?? '';

    // Kiểm tra xem outletId đã được lưu trong SharedPreferences chưa
    print("📥 Đã lưu selectedOutletId: $selectedOutletId");

    // Tìm outletName từ outletId
    String outletName = _outletDisplayList.firstWhere(
            (item) => item['outletId'] == selectedOutletId,
            orElse: () => {'outletName': 'No outlet selected'})['outletName'] ??
        'No outlet selected';

    // Lưu outletName vào SharedPreferences (Nếu cần thiết, có thể lưu cả ID)
    await prefs.setString('selectedOutlet', selectedOutletId);

    // Cập nhật filteredOutletList khi tải lại giá trị
    String savedSearchKeyword = searchOutletController.text.toLowerCase();

    setState(() {
      filteredOutletList = _outletDisplayList.where((item) {
        final outletName = item['outletName']!.toLowerCase();
        return outletName.contains(savedSearchKeyword);
      }).toList();
    });

    // Lưu outletName vào SharedPreferences
    await prefs.setString('selectedOutletName', outletName);

    // In giá trị outletName ra console để kiểm tra
    print("📥 Đã lưu outletName: $outletName");

    await prefs.setString('sellRate', sellRate?.toString() ?? '0.0');
    await prefs.setString('sendRate', sendRate?.toString() ?? '0.0');

    double sendAmount = double.tryParse(_sendController.text) ?? 0.0;
    double totalPay = sendAmount + (sendRate ?? 0.0);

    // Lưu totalPay vào SharedPreferences
    await prefs.setString('totalPay', totalPay.toStringAsFixed(2));

    // In giá trị sendRate và sellRate ra console để kiểm tra
    print("📥 Đã lưu sendRate: $sendRate");
    print("📥 Đã lưu sellRate: $sellRate");
    print("📥 Đã lưu totalPay: $totalPay");
  }

  void _setupTextFieldCurrencyListeners() {
    // Lắng nghe thay đổi trên _sendController
    _sendController.addListener(() async {
      if (_validateNumeric(_sendController) && isSenderActive) {
        double sendAmount = double.tryParse(_sendController.text) ?? 0.0;
        double receiveAmount =
            (buyRate != null && buyRate! > 0) ? sendAmount / buyRate! : 0.0;

        // Lưu tạm thời giá trị khi người dùng nhập
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('sendAmount', _sendController.text);
        await prefs.setString('receiveAmount',
            receiveAmount.toStringAsFixed(2)); // 🔥 Thêm dòng này

        // Tạm ngắt Listener để tránh vòng lặp
        isRecipientActive = false;
        _receiveController.text = receiveAmount.toStringAsFixed(2);
        isRecipientActive = true;
      }
    });

    // Lắng nghe thay đổi trên _receiveController
    _receiveController.addListener(() async {
      if (_validateNumeric(_receiveController) && isRecipientActive) {
        double receiveAmount = double.tryParse(_receiveController.text) ?? 0.0;
        double sendAmount =
            (buyRate != null && buyRate! > 0) ? receiveAmount * buyRate! : 0.0;

        // Lưu tạm thời giá trị khi người dùng nhập
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('receiveAmount',
            _receiveController.text); // 🔥 Đảm bảo lưu giá trị tại đây
        await prefs.setString('sendAmount', sendAmount.toStringAsFixed(2));

        // Tạm ngắt Listener để tránh vòng lặp
        isSenderActive = false;
        _sendController.text = sendAmount.toStringAsFixed(2);
        isSenderActive = true;
      }
    });
  }

  String _calculateTotalPay() {
    double sendAmount = double.tryParse(_sendController.text) ?? 0.0;
    double totalPay = sendAmount + (sendRate ?? 0.0);
    return totalPay.toStringAsFixed(2);
  }

  void addOutletRates() async {
    CollectionReference outletRates =
        FirebaseFirestore.instance.collection('outletRates');

    List<Map<String, dynamic>> ratesData = [
      {
        'buyRate': 25000,
        'foreignCurrency': 'EUR',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_1',
        'sellRate': 25150,
        'sendRate': 25200
      },
      {
        'buyRate': 23000,
        'foreignCurrency': 'USD',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_2',
        'sellRate': 23150,
        'sendRate': 23200
      },
      {
        'buyRate': 180,
        'foreignCurrency': 'JPY',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_3',
        'sellRate': 181,
        'sendRate': 182
      },
      {
        'buyRate': 31000,
        'foreignCurrency': 'GBP',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_4',
        'sellRate': 31150,
        'sendRate': 31200
      },
      {
        'buyRate': 1500,
        'foreignCurrency': 'KRW',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_5',
        'sellRate': 1510,
        'sendRate': 1520
      },
      {
        'buyRate': 27000,
        'foreignCurrency': 'AUD',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_6',
        'sellRate': 27150,
        'sendRate': 27200
      },
      {
        'buyRate': 6000,
        'foreignCurrency': 'CNY',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_7',
        'sellRate': 6050,
        'sendRate': 6100
      },
      {
        'buyRate': 3500,
        'foreignCurrency': 'SGD',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_8',
        'sellRate': 3550,
        'sendRate': 3600
      },
      {
        'buyRate': 3000,
        'foreignCurrency': 'HKD',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_9',
        'sellRate': 3050,
        'sendRate': 3100
      },
      {
        'buyRate': 500,
        'foreignCurrency': 'THB',
        'localCurrency': 'VND',
        'outletId': '3kf82kd91s',
        'outletRateId': 'rate_3kf82kd91s_10',
        'sellRate': 510,
        'sendRate': 520
      }
    ];

    for (var rate in ratesData) {
      await outletRates.add(rate);
      print(
          "✅ Added outletRate: ${rate['foreignCurrency']} - ${rate['localCurrency']}");
    }
  }

  void addOutlets() async {
    CollectionReference outlets =
        FirebaseFirestore.instance.collection('outlets');

    List<Map<String, dynamic>> outletData = [
      {
        'outletAddress': '123 Đường ABC, Hà Nội',
        'outletCode': 'OUT123',
        'outletId': '1a2b3c4d5e',
        'outletName': 'Outlet ABC'
      },
      {
        'outletAddress': '456 Đường XYZ, Hà Nội',
        'outletCode': 'OUT456',
        'outletId': '3hfu29sjd92',
        'outletName': 'Outlet XYZ'
      },
      {
        'outletAddress': '789 Đường PQR, TP.HCM',
        'outletCode': 'OUT789',
        'outletId': '9df8s7a6g5',
        'outletName': 'Outlet PQR'
      },
      {
        'outletAddress': '101 Đường LMN, Đà Nẵng',
        'outletCode': 'OUT101',
        'outletId': '8fj29dk30s',
        'outletName': 'Outlet LMN'
      },
      {
        'outletAddress': '202 Đường UVW, Cần Thơ',
        'outletCode': 'OUT202',
        'outletId': '4hf8s6a2g1',
        'outletName': 'Outlet UVW'
      },
      {
        'outletAddress': '303 Đường STU, Hải Phòng',
        'outletCode': 'OUT303',
        'outletId': '5js92kdj38',
        'outletName': 'Outlet STU'
      },
      {
        'outletAddress': '404 Đường GHI, Nha Trang',
        'outletCode': 'OUT404',
        'outletId': '2jsk8d92hd',
        'outletName': 'Outlet GHI'
      },
      {
        'outletAddress': '505 Đường MNO, Vũng Tàu',
        'outletCode': 'OUT505',
        'outletId': '3kf82kd91s',
        'outletName': 'Outlet MNO'
      },
      {
        'outletAddress': '606 Đường DEF, Huế',
        'outletCode': 'OUT606',
        'outletId': '9fj47sjd92',
        'outletName': 'Outlet DEF'
      },
      {
        'outletAddress': '707 Đường ABC, Biên Hòa',
        'outletCode': 'OUT707',
        'outletId': '8dj39skd72',
        'outletName': 'Outlet ABC Biên Hòa'
      },
      {
        'outletAddress': '808 Đường XYZ, Buôn Ma Thuột',
        'outletCode': 'OUT808',
        'outletId': '6dj38skd91',
        'outletName': 'Outlet XYZ Buôn Ma Thuột'
      },
      {
        'outletAddress': '909 Đường PQR, Quy Nhơn',
        'outletCode': 'OUT909',
        'outletId': '1kd83js92d',
        'outletName': 'Outlet PQR Quy Nhơn'
      },
      {
        'outletAddress': '010 Đường LMN, Phú Quốc',
        'outletCode': 'OUT010',
        'outletId': '3jd83ks92d',
        'outletName': 'Outlet LMN Phú Quốc'
      },
      {
        'outletAddress': '111 Đường UVW, Đà Lạt',
        'outletCode': 'OUT111',
        'outletId': '4ks92jd83f',
        'outletName': 'Outlet UVW Đà Lạt'
      },
      {
        'outletAddress': '222 Đường STU, Thanh Hóa',
        'outletCode': 'OUT222',
        'outletId': '5hd92ks83d',
        'outletName': 'Outlet STU Thanh Hóa'
      },
      {
        'outletAddress': '333 Đường GHI, Thái Nguyên',
        'outletCode': 'OUT333',
        'outletId': '6jd83ks92d',
        'outletName': 'Outlet GHI Thái Nguyên'
      },
      {
        'outletAddress': '444 Đường MNO, Nam Định',
        'outletCode': 'OUT444',
        'outletId': '7ks92jd83f',
        'outletName': 'Outlet MNO Nam Định'
      },
      {
        'outletAddress': '555 Đường DEF, Vinh',
        'outletCode': 'OUT555',
        'outletId': '8hd92ks83d',
        'outletName': 'Outlet DEF Vinh'
      },
      {
        'outletAddress': '666 Đường ABC, Hạ Long',
        'outletCode': 'OUT666',
        'outletId': '9jd83ks92d',
        'outletName': 'Outlet ABC Hạ Long'
      },
      {
        'outletAddress': '777 Đường XYZ, Long Xuyên',
        'outletCode': 'OUT777',
        'outletId': '0ks92jd83f',
        'outletName': 'Outlet XYZ Long Xuyên'
      }
    ];

    for (var data in outletData) {
      await outlets.add(data);
      print(
          "✅ Added outlet: ${data['outletName']} at ${data['outletAddress']}");
    }
  }

  void addCurrencyCodes() async {
    CollectionReference currencyCodes =
        FirebaseFirestore.instance.collection('currencyCodes');

    List<Map<String, dynamic>> currencyData = [
      {"currencyCode": "AED", "description": "UAE Dirham"},
      {"currencyCode": "AFN", "description": "Afghani"},
      {"currencyCode": "ALL", "description": "Lek"},
      {"currencyCode": "AMD", "description": "Armenian Dram"},
      {"currencyCode": "ANG", "description": "Netherlands Antillian Guilder"},
      {"currencyCode": "AOA", "description": "Kwanza"},
      {"currencyCode": "ARS", "description": "Argentine Peso"},
      {"currencyCode": "AUD", "description": "Australian Dollar"},
      {"currencyCode": "AWG", "description": "Aruban Guilder"},
      {"currencyCode": "AZN", "description": "Azerbaijanian Manat"},
      {"currencyCode": "BAM", "description": "Convertible Marks"},
      {"currencyCode": "BBD", "description": "Barbados Dollar"},
      {"currencyCode": "BDT", "description": "Taka"},
      {"currencyCode": "BGN", "description": "Bulgarian Lev"},
      {"currencyCode": "BHD", "description": "Bahraini Dinar"},
      {"currencyCode": "BIF", "description": "Burundi Franc"},
      {"currencyCode": "BMD", "description": "Bermuda Dollar"},
      {"currencyCode": "BND", "description": "Brunei Dollar"},
      {"currencyCode": "BOB", "description": "Boliviano Mvdol"},
      {"currencyCode": "BRL", "description": "Brazilian Real"},
      {"currencyCode": "BSD", "description": "Bahamian Dollar"},
      {"currencyCode": "BTN", "description": "Ngultrum"},
      {"currencyCode": "BWP", "description": "Pula"},
      {"currencyCode": "BYN", "description": "Belarussian Ruble"},
      {"currencyCode": "BYR", "description": "Belarussian Ruble (obsolete)"},
      {"currencyCode": "BZD", "description": "Belize Dollar"},
      {"currencyCode": "CAD", "description": "Canadian Dollar"},
      {"currencyCode": "CDF", "description": "Congolese Franc"},
      {"currencyCode": "CHF", "description": "Swiss Franc"},
      {"currencyCode": "CLP", "description": "Chilean Peso"},
      {"currencyCode": "CNY", "description": "Yuan Renminbi"},
      {"currencyCode": "COP", "description": "Colombian Peso"},
      {"currencyCode": "CRC", "description": "Costa Rican Colon"},
      {"currencyCode": "CUP", "description": "Cuban Peso"},
      {"currencyCode": "CVE", "description": "Cape Verde Escudo"},
      {"currencyCode": "CZK", "description": "Czech Koruna"},
      {"currencyCode": "DJF", "description": "Djibouti Franc"},
      {"currencyCode": "DKK", "description": "Danish Krone"},
      {"currencyCode": "DOP", "description": "Dominican Peso"},
      {"currencyCode": "DZD", "description": "Algerian Dinar"},
      {"currencyCode": "EGP", "description": "Egyptian Pound"},
      {"currencyCode": "ERN", "description": "Nakfa"},
      {"currencyCode": "ETB", "description": "Ethiopian Birr"},
      {"currencyCode": "EUR", "description": "Euro"},
      {"currencyCode": "FJD", "description": "Fiji Dollar"},
      {"currencyCode": "FKP", "description": "Falkland Islands Pound"},
      {"currencyCode": "GBP", "description": "Pound Sterling"},
      {"currencyCode": "GEL", "description": "Lari"},
      {"currencyCode": "GHS", "description": "Cedi"},
      {"currencyCode": "GIP", "description": "Gibraltar Pound"},
      {"currencyCode": "GMD", "description": "Dalasi"},
      {"currencyCode": "GNF", "description": "Guinea Franc"},
      {"currencyCode": "GTQ", "description": "Quetzal"},
      {"currencyCode": "GYD", "description": "Guyana Dollar"},
      {"currencyCode": "HKD", "description": "Hong Kong Dollar"},
      {"currencyCode": "HNL", "description": "Lempira"},
      {"currencyCode": "HRK", "description": "Croatian Kuna"},
      {"currencyCode": "HTG", "description": "Gourde"},
      {"currencyCode": "HUF", "description": "Forint"},
      {"currencyCode": "IDR", "description": "Rupiah"},
      {"currencyCode": "ILS", "description": "New Israeli Sheqel"},
      {"currencyCode": "INR", "description": "Indian Rupee"},
      {"currencyCode": "IQD", "description": "Iraqi Dinar"},
      {"currencyCode": "IRR", "description": "Iranian Rial"},
      {"currencyCode": "ISK", "description": "Iceland Krona"},
      {"currencyCode": "JMD", "description": "Jamaican Dollar"},
      {"currencyCode": "JOD", "description": "Jordanian Dinar"},
      {"currencyCode": "JPY", "description": "Yen"},
      {"currencyCode": "KES", "description": "Kenyan Shilling"},
      {"currencyCode": "KGS", "description": "Som"},
      {"currencyCode": "KHR", "description": "Riel"},
      {"currencyCode": "KMF", "description": "Comorian Franc"},
      {"currencyCode": "KRW", "description": "Won"},
      {"currencyCode": "KWD", "description": "Kuwaiti Dinar"},
      {"currencyCode": "KYD", "description": "Cayman Islands Dollar"},
      {"currencyCode": "KZT", "description": "Tenge"},
      {"currencyCode": "LAK", "description": "Kip"},
      {"currencyCode": "LBP", "description": "Lebanese Pound"},
      {"currencyCode": "LKR", "description": "Sri Lanka Rupee"},
      {"currencyCode": "LRD", "description": "Liberian Dollar"},
      {"currencyCode": "LSL", "description": "Loti"},
      {"currencyCode": "LTL", "description": "Lithuanian Litas"},
      {"currencyCode": "LVL", "description": "Latvian Lats"},
      {"currencyCode": "LYD", "description": "Libyan Dinar"},
      {"currencyCode": "HNL", "description": "Lempira"}
    ];

    for (var data in currencyData) {
      await currencyCodes.add(data);
      print("✅ Added currency code: ${data['currencyCode']}");
    }
  }

  Future<void> fetchOutlets() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('outlets').get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlets found in Firestore.");
        return;
      }

      List<Map<String, String>> outletList = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'outletId': doc.id, // 🔹 Dùng document ID
          'outletName': data['outletName']?.toString() ?? "Unnamed Outlet",
        };
      }).toList();

      setState(() {
        _outletDisplayList = outletList;
      });
    } catch (e) {
      print("⚠️ Error fetching outlets: $e");
    }
  }

  Future<void> fetchCurrencyCodes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('currencyCodes').get();

      if (querySnapshot.docs.isEmpty) {
        return;
      }

      List<Map<String, String>> currencyList = querySnapshot.docs.map((doc) {
        return {
          'currencyCode': doc['currencyCode'].toString(),
          'description': doc['description'].toString()
        };
      }).toList();

      setState(() {
        _currencyDisplayList = currencyList;
      });
    } catch (e) {
      print("⚠️ Error fetching currency codes: $e");
    }
  }

  Future<void> fetchOutletRates(
      String? outletId, String? fromCurrency, String? toCurrency) async {
    // Kiểm tra đầu vào
    if (outletId == null || fromCurrency == null || toCurrency == null) {
      print("⚠️ Missing required parameters for fetching outlet rates.");
      return;
    }

    try {
      // Truy vấn Firestore với điều kiện outletId, fromCurrency, toCurrency
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('outletRates')
          .where('outletId', isEqualTo: outletId)
          .where('localCurrency', isEqualTo: fromCurrency)
          .where('foreignCurrency', isEqualTo: toCurrency)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlet rates found for $fromCurrency ➡️ $toCurrency");

        // Cập nhật thông báo lỗi
        setState(() {
          _currencyError = "Currency này không hỗ trợ";
        });
        return;
      }

      // Nếu có dữ liệu, đặt lại thông báo lỗi
      setState(() {
        _currencyError = null;
      });

      // Lấy dữ liệu document đầu tiên (nếu có)
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Cập nhật State nếu Widget vẫn đang hiện diện (mounted)
      if (mounted) {
        setState(() {
          sendRate = double.tryParse(data['sendRate'].toString()) ?? 0.0;
          buyRate = double.tryParse(data['buyRate'].toString()) ?? 0.0;
          sellRate = double.tryParse(data['sellRate'].toString()) ?? 0.0;
          localCurrency = data['localCurrency'] ?? '';
          foreignCurrency = data['foreignCurrency'] ?? '';
        });
      }
    } catch (e) {
      print("⚠️ Error fetching outlet rates: $e");
      setState(() {
        _currencyError = "Lỗi khi tải dữ liệu tỉ giá";
      });
    }
  }

  bool _validateNumeric(TextEditingController controller) {
    final input = controller.text;
    // Chỉ cho phép số và dấu chấm
    if (input.isNotEmpty && !RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(input)) {
      setState(() {
        _numericError = "❌ Only numbers are allowed!";
      });
      return false;
    } else {
      setState(() {
        _numericError = null;
      });
      return true;
    }
  }

  void _showOutletPicker(BuildContext context) {
    List<Map<String, String>> filteredOutletList =
        List.from(_outletDisplayList);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateModal) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Outlet',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: searchOutletController,
                      decoration: InputDecoration(
                        hintText: 'Search outlet...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setStateModal(() {
                          String searchKeyword = value.toLowerCase();
                          filteredOutletList = _outletDisplayList.where((item) {
                            final outletName =
                                item['outletName']!.toLowerCase();
                            return outletName.contains(searchKeyword);
                          }).toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: filteredOutletList.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredOutletList.length,
                            itemBuilder: (context, index) {
                              final item = filteredOutletList[index];
                              final outletName = item['outletName']!;
                              return ListTile(
                                title: Text(
                                  outletName,
                                  style: TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    outletId = item['outletId']!;
                                    selectedOutlet = outletId!;
                                  });
                                  print("🔄 Selected Outlet: $selectedOutlet");
                                  Navigator.pop(context);

                                  // Kiểm tra nếu fromCurrency và toCurrency đã được chọn
                                  if (fromCurrency.isNotEmpty &&
                                      toCurrency.isNotEmpty) {
                                    fetchOutletRates(
                                        outletId, fromCurrency, toCurrency);
                                  } else {
                                    print(
                                        "⚠️ Please select both fromCurrency and toCurrency before fetching rates.");
                                  }
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No matching outlets.",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, bool isSender) {
    TextEditingController searchCurrencyController = TextEditingController();

    List<Map<String, String>> filteredCurrencyList =
        List.from(_currencyDisplayList);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Currency',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchCurrencyController,
                    decoration: InputDecoration(
                      hintText: 'Search currency...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setStateModal(() {
                        searchKeyword = value.toLowerCase();
                        filteredCurrencyList =
                            _currencyDisplayList.where((item) {
                          final currencyCode =
                              item['currencyCode']!.toLowerCase();
                          return currencyCode.contains(searchKeyword);
                        }).toList();
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCurrencyList.length,
                    itemBuilder: (context, index) {
                      final item = filteredCurrencyList[index];
                      final currencyCode = item['currencyCode']!;
                      final countryCode = currencyToCountryCode[currencyCode] ??
                          'UN'; // UN: Unknown

                      return ListTile(
                        leading: CircleFlag(
                          countryCode.toLowerCase(),
                          size: 32, // Kích thước lá cờ
                        ),
                        title: Text(
                          "$currencyCode - ${item['description']}",
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            if (isSender) {
                              fromCurrency = currencyCode;
                            } else {
                              toCurrency = currencyCode;
                            }
                          });
                          print(
                              "🔄 Selected Currency: ${isSender ? fromCurrency : toCurrency}");
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    final double padding = isSmallScreen ? 12.0 : 24.0;
    final double fontSize = isSmallScreen ? 14.0 : 18.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressStepper(
              steps: [
                tr('amount'),
                tr('sender'),
                tr('recipient'),
                tr('review'),
                tr('success'),
              ],
              stepIcons: [
                Icons.attach_money,
                Icons.person,
                Icons.people,
                Icons.checklist,
                Icons.verified
              ],
              currentStep: 0,
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: 8,
            ),
            // Input Field: You Send
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildCurrencyInputField(
              tr('you_send'),
              fromCurrency,
              (value) {
                setState(() {
                  fromCurrency = value!;
                  print("🔄 Updated fromCurrency: $fromCurrency");

                  // Gọi fetchOutletRates nếu outletId đã được chọn
                  if (outletId != null) {
                    fetchOutletRates(outletId, fromCurrency, toCurrency);
                  }
                });
              },
              isSmallScreen,
              _sendController,
              isSender: true,
            ),

            _buildCurrencyInputField(
              tr('recipient_gets'),
              toCurrency,
              (value) {
                setState(() {
                  toCurrency = value!;
                  print("🔄 Updated toCurrency: $toCurrency");

                  // Gọi fetchOutletRates nếu outletId đã được chọn
                  if (outletId != null) {
                    fetchOutletRates(outletId, fromCurrency, toCurrency);
                  }
                });
              },
              isSmallScreen,
              _receiveController,
              isSender: false,
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

            Text("Select Outlet"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showOutletPicker(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedOutlet != null && selectedOutlet!.isNotEmpty
                          ? _outletDisplayList.firstWhere(
                                  (item) => item['outletId'] == selectedOutlet,
                                  orElse: () => {
                                        'outletName': 'Select Outlet'
                                      })['outletName'] ??
                              "Select Outlet"
                          : "Select Outlet",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),

            // Send Info
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSendInfo(isSmallScreen, fontSize),

            // Continue Button
            SizedBox(height: isSmallScreen ? 16 : 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // selectedOutlet là kiểu String, không cần sử dụng .text
                  String outletId = selectedOutlet ??
                      ''; // Nếu selectedOutlet là null, sử dụng giá trị mặc định ''

                  // Lưu outletId vào SharedPreferences (searchKeyword)
                  await prefs.setString('searchKeyword', outletId);

                  // Lấy các giá trị tiền từ SharedPreferences
                  String sendAmount = prefs.getString('sendAmount') ?? '0.00';
                  String receiveAmount =
                      prefs.getString('receiveAmount') ?? '0.00';

                  // Tìm outletName từ outletId
                  String? outletName = _outletDisplayList.firstWhere(
                      (item) => item['outletId'] == outletId,
                      orElse: () =>
                          {'outletName': 'No outlet selected'})['outletName'];

                  // Lưu outletName vào SharedPreferences
                  await prefs.setString('selectedOutletName', outletName!);

                  await prefs.setString(
                      'sellRate', sellRate?.toString() ?? '0.0');
                  await prefs.setString(
                      'sendRate', sendRate?.toString() ?? '0.0');

                      

                  // In ra console để kiểm tra
                  print("📤 Số tiền gửi: $sendAmount");
                  print("📥 Số tiền nhận: $receiveAmount");
                  print("📥 Outlet: $outletName"); // In ra outletName
                  print("📥 SendRate: $sendRate"); // In ra sendRate
                  print("📥 SellRate: $sellRate"); // In ra sellRate

                  Navigator.pushNamed(context, Routes.addressDetails);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 600 ? 40 : 80,
                    vertical: screenWidth < 600 ? 12 : 16,
                  ),
                  minimumSize: Size(
                    double.infinity,
                    screenWidth < 600 ? 48 : 56,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      tr('continue'),
                      style: TextStyle(
                        fontSize: screenWidth < 600 ? 16 : 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInputField(
      String label,
      String selectedValue,
      ValueChanged<String?> onChanged,
      bool isSmallScreen,
      TextEditingController controller,
      {bool isSender = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  _showCurrencyPicker(context, isSender);
                },
                child: Row(
                  children: [
                    if (selectedValue.isNotEmpty)
                      CircleFlag(
                        (currencyToCountryCode[selectedValue] ?? 'UN')
                            .toLowerCase(),
                        size: 24,
                      ),
                    SizedBox(width: 4),
                    Text(
                      selectedValue.isNotEmpty ? selectedValue : 'Select',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (isSender) {
                      print("🔢 You Send: ${_sendController.text}");
                    } else {
                      print("🔢 Recipient Gets: ${_receiveController.text}");
                    }
                  },
                  decoration: InputDecoration(
                    hintText: tr('enter_amount'),
                    errorText: _numericError,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Hiển thị thông báo lỗi nếu có
        if (_currencyError != null) ...[
          SizedBox(height: 4),
          Text(
            _currencyError!,
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ]
      ],
    );
  }

  Widget _buildSendInfo(bool isSmallScreen, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          tr('exchange_rate'),
          (sellRate != null) ? "$sellRate " : "Loading...",
          tooltip: tr('exchange_rate_tooltip'),
          fontSize: fontSize,
        ),
        _buildInfoRow(
          tr('fees'),
          (fromCurrency != null && fromCurrency.isNotEmpty)
              ? "$sendRate $fromCurrency"
              : "Loading...",
          fontSize: fontSize,
        ),
        _buildInfoRow(
          tr('total_pay'),
          _calculateTotalPay(),
          isRecipient: true,
          fontSize: fontSize,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String title,
    String value, {
    String? tooltip,
    bool isRecipient = false,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isRecipient ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize,
                ),
              ),
              if (tooltip != null) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: tooltip,
                  child: const Icon(Icons.info_outline, size: 16),
                ),
              ],
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
