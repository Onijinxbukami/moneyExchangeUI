import 'package:circle_flags/circle_flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';

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
  String searchKeyword = '';

  List<DropdownMenuItem<String>> _outletItems = [];
  List<Map<String, String>> _outletDisplayList = [];
  List<String> currencyCodes = [];
  List<Map<String, String>> _currencyDisplayList = [];

  final TextEditingController _numericController = TextEditingController();
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

  String? _numericError;
  @override
  void initState() {
    super.initState();
    fetchOutlets();
    fetchCurrencyCodes();
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
      {'country': 'Afghanistan', 'currencyCode': 'AFA'},
      {'country': 'Albania', 'currencyCode': 'ALL'},
      {'country': 'Algeria', 'currencyCode': 'DZD'},
      {'country': 'Angola', 'currencyCode': 'AOR'},
      {'country': 'Argentina', 'currencyCode': 'ARS'},
      {'country': 'Armenia', 'currencyCode': 'AMD'},
      {'country': 'Aruba', 'currencyCode': 'AWG'},
      {'country': 'Australia', 'currencyCode': 'AUD'},
      {'country': 'Azerbaijan', 'currencyCode': 'AZN'},
      {'country': 'Bahamas', 'currencyCode': 'BSD'},
      {'country': 'Bahrain', 'currencyCode': 'BHD'},
      {'country': 'Bangladesh', 'currencyCode': 'BDT'},
      {'country': 'Barbados', 'currencyCode': 'BBD'},
      {'country': 'Belarus', 'currencyCode': 'BYN'},
      {'country': 'Belize', 'currencyCode': 'BZD'},
      {'country': 'Bermuda', 'currencyCode': 'BMD'},
      {'country': 'Bhutan', 'currencyCode': 'BTN'},
      {'country': 'Bolivia', 'currencyCode': 'BOB'},
      {'country': 'Botswana', 'currencyCode': 'BWP'},
      {'country': 'Brazil', 'currencyCode': 'BRL'},
      {'country': 'United Kingdom', 'currencyCode': 'GBP'},
      {'country': 'Brunei', 'currencyCode': 'BND'},
      {'country': 'Bulgaria', 'currencyCode': 'BGN'},
      {'country': 'Burundi', 'currencyCode': 'BIF'},
      {'country': 'Cambodia', 'currencyCode': 'KHR'},
      {'country': 'Canada', 'currencyCode': 'CAD'},
      {'country': 'Cape Verde', 'currencyCode': 'CVE'},
      {'country': 'Cayman Islands', 'currencyCode': 'KYD'},
      {'country': 'Chile', 'currencyCode': 'CLP'},
      {'country': 'China', 'currencyCode': 'CNY'},
      {'country': 'Colombia', 'currencyCode': 'COP'},
      {'country': 'Comoros', 'currencyCode': 'KMF'},
      {'country': 'Congo', 'currencyCode': 'CDF'},
      {'country': 'Costa Rica', 'currencyCode': 'CRC'},
      {'country': 'Croatia', 'currencyCode': 'HRK'},
      {'country': 'Cuba', 'currencyCode': 'CUP'},
      {'country': 'Czech Republic', 'currencyCode': 'CZK'},
      {'country': 'Denmark', 'currencyCode': 'DKK'},
      {'country': 'Djibouti', 'currencyCode': 'DJF'},
      {'country': 'Dominican Republic', 'currencyCode': 'DOP'},
      {'country': 'East Caribbean', 'currencyCode': 'XCD'},
      {'country': 'Egypt', 'currencyCode': 'EGP'},
      {'country': 'El Salvador', 'currencyCode': 'SVC'},
      {'country': 'Eritrea', 'currencyCode': 'ERN'},
      {'country': 'Estonia', 'currencyCode': 'EEK'},
      {'country': 'Ethiopia', 'currencyCode': 'ETB'},
      {'country': 'Eurozone', 'currencyCode': 'EUR'},
      {'country': 'Falkland Islands', 'currencyCode': 'FKP'},
      {'country': 'Fiji', 'currencyCode': 'FJD'},
      {'country': 'Gambia', 'currencyCode': 'GMD'},
      {'country': 'Georgia', 'currencyCode': 'GEL'},
      {'country': 'Ghana', 'currencyCode': 'GHS'},
      {'country': 'Gibraltar', 'currencyCode': 'GIP'},
      {'country': 'Guatemala', 'currencyCode': 'GTQ'},
      {'country': 'Guinea', 'currencyCode': 'GNF'},
      {'country': 'Guyana', 'currencyCode': 'GYD'},
      {'country': 'Haiti', 'currencyCode': 'HTG'},
      {'country': 'Honduras', 'currencyCode': 'HNL'},
      {'country': 'Hong Kong', 'currencyCode': 'HKD'},
      {'country': 'Hungary', 'currencyCode': 'HUF'},
      {'country': 'Iceland', 'currencyCode': 'ISK'},
      {'country': 'India', 'currencyCode': 'INR'},
      {'country': 'Indonesia', 'currencyCode': 'IDR'},
      {'country': 'Iran', 'currencyCode': 'IRR'},
      {'country': 'Iraq', 'currencyCode': 'IQD'},
      {'country': 'Israel', 'currencyCode': 'ILS'},
      {'country': 'Jamaica', 'currencyCode': 'JMD'},
      {'country': 'Japan', 'currencyCode': 'JPY'},
      {'country': 'Jordan', 'currencyCode': 'JOD'},
      {'country': 'Kazakhstan', 'currencyCode': 'KZT'},
      {'country': 'Kenya', 'currencyCode': 'KES'},
      {'country': 'Kuwait', 'currencyCode': 'KWD'},
      {'country': 'Kyrgyzstan', 'currencyCode': 'KGS'},
      {'country': 'Laos', 'currencyCode': 'LAK'},
      {'country': 'Latvia', 'currencyCode': 'LVL'},
      {'country': 'Lebanon', 'currencyCode': 'LBP'},
      {'country': 'Lesotho', 'currencyCode': 'LSL'},
      {'country': 'Liberia', 'currencyCode': 'LRD'},
      {'country': 'Libya', 'currencyCode': 'LYD'},
      {'country': 'Lithuania', 'currencyCode': 'LTL'},
      {'country': 'Macau', 'currencyCode': 'MOP'},
      {'country': 'Macedonia', 'currencyCode': 'MKD'},
      {'country': 'Madagascar', 'currencyCode': 'MGA'},
      {'country': 'Malawi', 'currencyCode': 'MWK'},
      {'country': 'Malaysia', 'currencyCode': 'MYR'},
      {'country': 'Maldives', 'currencyCode': 'MVR'},
      {'country': 'Vietnam', 'currencyCode': 'VND'},
      {'country': 'United States', 'currencyCode': 'USD'},
      // Thêm các quốc gia còn lại ở đây nếu cần
    ];

    for (var data in currencyData) {
      await currencyCodes.add(data);
      print("✅ Added currency code for ${data['country']}");
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
          'country': doc['country'].toString()
        };
      }).toList();

      setState(() {
        _currencyDisplayList = currencyList;
      });
    } catch (e) {
      print("⚠️ Error fetching currency codes: $e");
    }
  }

  Future<void> fetchOutletRates(String outletId) async {
    try {
      // Truy vấn outletRate có outletId khớp
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('outletRates')
          .where('outletId', isEqualTo: outletId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlet rates found for outletId: $outletId");
        return;
      }

      // Duyệt qua từng document và in dữ liệu ra console
      // Lấy `sendRate` từ document đầu tiên (hoặc tuỳ chỉnh nếu có nhiều document)
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      setState(() {
        setState(() {
          sendRate = double.parse(data['sendRate'].toString());
          localCurrency = data['localCurrency'];
          foreignCurrency = data['foreignCurrency'];
        });
      });

      print("✅ Fetched sendRate: $sendRate");
      print("✅ Fetched sendRate: $localCurrency");
      print("✅ Fetched sendRate: $foreignCurrency");
    } catch (e) {
      print("⚠️ Error fetching outlet rates: $e");
    }
  }

  void _validateNumeric() {
    final input = _numericController.text;
    if (input.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(input)) {
      setState(() {
        _numericError = "Only numbers are allowed!";
      });
    } else {
      setState(() {
        _numericError = null;
      });
    }
  }

  void _showOutletPicker(BuildContext context) {
    TextEditingController searchController = TextEditingController();
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
                      controller: searchController,
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
                                    selectedOutlet = item['outletId']!;
                                  });
                                  print("🔄 Selected Outlet: $selectedOutlet");
                                  Navigator.pop(context);

                                  // 🔹 Gọi hàm fetchOutletRates khi chọn Outlet
                                  fetchOutletRates(selectedOutlet!);
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
    TextEditingController searchController = TextEditingController();

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
                    controller: searchController,
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
                          "$currencyCode - ${item['country']}",
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
                  print("🪙 Current fromCurrency: $fromCurrency");
                });
              },
              isSmallScreen,
              _numericController,
              isSender: true, // 🔹 Người gửi
            ),

            _buildCurrencyInputField(
              tr('recipient_gets'),
              toCurrency,
              (value) {
                setState(() {
                  toCurrency = value!;
                  print("🔄 Updated toCurrency: $toCurrency");
                });
              },
              isSmallScreen,
              _numericController,
              isSender: false, // 🔹 Người nhận
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
                onPressed: () {
                  Navigator.pushNamed(context, Routes.userDetails);
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
                    // 🔹 Hiển thị CircleFlag khi đã chọn currencyCode
                    if (selectedValue.isNotEmpty)
                      CircleFlag(
                        (currencyToCountryCode[selectedValue] ?? 'UN')
                            .toLowerCase(),
                        size: 24,
                      ),
                    SizedBox(width: 4),
                    // 🔹 Hiển thị currencyCode
                    Text(
                      selectedValue,
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
                  onChanged: (value) => _validateNumeric(),
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
      ],
    );
  }

  Widget _buildSendInfo(bool isSmallScreen, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          tr('exchange_rate'),
          exchangeRate,
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
          "549.24",
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
