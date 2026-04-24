class BankService {
  // Your JSON data converted to a List of Maps
  final List<Map<String, dynamic>> _banks = [
    {
      "id": 1,
      "bank_name": "ABAY BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "ABAYETAA",
    },
    {
      "id": 2,
      "bank_name": "ADDIS INTERNATIONAL BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "ABSCETAA",
    },
    {
      "id": 3,
      "bank_name": "AFRICAN UNION",
      "location": "ADDIS ABABA",
      "swift_code": "AFUNETAA",
    },
    {
      "id": 4,
      "bank_name": "AHADU BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "AHUUETAA",
    },
    {
      "id": 5,
      "bank_name": "AMHARA BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "AMHRETAA",
    },
    {
      "id": 6,
      "bank_name": "AWASH BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "AWINETAA",
    },
    {
      "id": 7,
      "bank_name": "BANK OF ABYSSINIA",
      "location": "ADDIS ABABA",
      "swift_code": "ABYSETAA",
    },
    {
      "id": 8,
      "bank_name": "BERHAN BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "BERHETAA",
    },
    {
      "id": 9,
      "bank_name": "BUNNA INTERNATIONAL BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "BUNAETAA",
    },
    {
      "id": 10,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAA",
      "branch": "HEAD OFFICE",
    },
    {
      "id": 11,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAAARA",
      "branch": "ARADA GIORGIS",
    },
    {
      "id": 12,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAADIR",
      "branch": "DIRE DAWA MAIN",
    },
    {
      "id": 13,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAAFIN",
      "branch": "FINFINE",
    },
    {
      "id": 14,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAAIBD",
      "branch": "INTERNATIONAL BANKING DEPARTMENT",
    },
    {
      "id": 15,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAAMEH",
      "branch": "MEHAL GEBEYA",
    },
    {
      "id": 16,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAATEM",
      "branch": "TEMENJA YAJ",
    },
    {
      "id": 17,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAADOC",
      "branch": "TRADE SERVICE CENTER",
    },
    {
      "id": 18,
      "bank_name": "COMMERCIAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "CBETETAATRY",
      "branch": "TREASURY DEPARTMENT",
    },
    {
      "id": 19,
      "bank_name": "COOPERATIVE BANK OF OROMIA S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "CBORETAA",
    },
    {
      "id": 20,
      "bank_name": "DASHEN BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "DASHETAA",
    },
    {
      "id": 21,
      "bank_name": "DEVELOPMENT BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "DEETETAA",
    },
    {
      "id": 22,
      "bank_name": "ENAT BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "ENATETAA",
    },
    {
      "id": 23,
      "bank_name": "GADAA BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "GDAAETAA",
    },
    {
      "id": 24,
      "bank_name": "GLOBAL BANK ETHIOPIA S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "DEGAETAA",
      "notes": "Formerly Debub Global Bank S.C.",
    },
    {
      "id": 25,
      "bank_name": "GOH BETOCH BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "GOBTETAA",
    },
    {
      "id": 26,
      "bank_name": "HIBRET BANK SHARE COMPANY",
      "location": "ADDIS ABABA",
      "swift_code": "UNTDETAA",
    },
    {
      "id": 27,
      "bank_name": "HIJRA BANK SHARE COMPANY",
      "location": "ADDIS ABABA",
      "swift_code": "HIJRETAA",
    },
    {
      "id": 28,
      "bank_name": "LION INTERNATIONAL BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "LIBSETAA",
    },
    {
      "id": 29,
      "bank_name": "NATIONAL BANK OF ETHIOPIA",
      "location": "ADDIS ABABA",
      "swift_code": "NBETETAA",
    },
    {
      "id": 30,
      "bank_name": "NIB INTERNATIONAL BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "NIBIETAA",
    },
    {
      "id": 31,
      "bank_name": "OMO BANK SHARE COMPANY",
      "location": "ADDIS ABABA",
      "swift_code": "OSCOETAA",
    },
    {
      "id": 32,
      "bank_name": "OROMIA INTERNATIONAL BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "ORIRETAA",
    },
    {
      "id": 33,
      "bank_name": "RAMMIS BANK SHARE COMPANY",
      "location": "ADDIS ABABA",
      "swift_code": "RMSIETAA",
    },
    {
      "id": 34,
      "bank_name": "RAYS MICRO FINANCE INSTITUTION S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "RMFIETA2",
    },
    {
      "id": 35,
      "bank_name": "SHABELLE BANK SHARE COMPANY",
      "location": "JIJIGA",
      "swift_code": "SBEEETAA",
    },
    {
      "id": 36,
      "bank_name": "SIDAMA BANK S.C.",
      "location": "HAWASSA",
      "swift_code": "SDMAETAA",
    },
    {
      "id": 37,
      "bank_name": "SIINQEE BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "SINQETAA",
    },
    {
      "id": 38,
      "bank_name": "TSEDEY BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "TSDYETAA",
    },
    {
      "id": 39,
      "bank_name": "TSEHAY BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "TSCPETAA",
    },
    {
      "id": 40,
      "bank_name": "WEGAGEN BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "WEGAETAA",
    },
    {
      "id": 41,
      "bank_name": "ZAMZAM BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "ZAMZETAA",
    },
    {
      "id": 42,
      "bank_name": "ZEMEN BANK S.C.",
      "location": "ADDIS ABABA",
      "swift_code": "ZEMEETAA",
    },
  ];

  /// Returns the bank name based on the SWIFT code.
  /// Returns 'Unknown Bank' if no match is found.
  String getBankName(String swiftCode) {
    try {
      final bank = _banks.firstWhere(
        (element) => element['swift_code'] == swiftCode,
      );
      return bank['bank_name'];
    } catch (e) {
      return "Unknown Bank";
    }
  }
}

// Example usage:
void main() {
  BankService service = BankService();

  String name = service.getBankName("ABAYETAA");
  print(name); // Output: ABAY BANK S.C.

  String unknown = service.getBankName("NONEXISTENT");
  print(unknown); // Output: Unknown Bank
}
