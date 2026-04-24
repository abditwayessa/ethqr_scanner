import 'package:eth_qr_scanner/services/bank_service.dart';
import 'package:flutter/material.dart';
import './model/qr_model.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PaymentScreen({super.key, required this.data});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late QrData qr;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _billController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  BankService bankService = BankService();

  double totalAmount = 0.0;
  bool _isSubmitting = false;
  String selectedAccount = "Default Savings - **** 1234";

  @override
  void initState() {
    super.initState();
    qr = QrData(widget.data);

    // Logic for Tag 54 (Amount)
    if (qr.amount != null) {
      _amountController.text = qr.amount!;
    }

    // Logic for Tag 62 -> 01 (Bill Number)
    if (qr.tag62['01'] != null && qr.tag62['01'] != '***') {
      _billController.text = qr.tag62['01'];
    }

    _calculateTotal();
  }

  void _calculateTotal() {
    double base = double.tryParse(_amountController.text) ?? 0.0;
    double tip = 0.0;

    if (qr.tipIndicator == '01') {
      tip = double.tryParse(_tipController.text) ?? 0.0;
    } else if (qr.tipIndicator == '02') {
      tip = double.tryParse(qr.fixedTip ?? '0') ?? 0.0;
    } else if (qr.tipIndicator == '03') {
      double pct = double.tryParse(qr.percentageTip ?? '0') ?? 0.0;
      tip = base * (pct / 100);
    }

    setState(() {
      totalAmount = base + tip;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAmountLocked = qr.amount != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildGradientAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION 1: FROM ACCOUNT ---
                  const Text(
                    "From Account",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _buildAccountPickerReplacement(),
                  const SizedBox(height: 20),

                  // --- SECTION 2: MERCHANT INFO (Recipient Box) ---
                  const Text(
                    "Merchant Bank",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _buildMerchantBankBox(),
                  const SizedBox(height: 8),
                  const Text(
                    "Merchant Code",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _buildMerchantCodeBox(),
                  const SizedBox(height: 8),
                  const Text(
                    "Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _buildMerchantBox(),
                  const SizedBox(height: 20),

                  // --- SECTION 3: AMOUNT INPUT ---
                  const Text(
                    "Transaction Amount",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    readOnly: isAmountLocked,
                    onChanged: (_) => _calculateTotal(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      prefixText: "ETB ",
                      filled: isAmountLocked,
                      fillColor: isAmountLocked
                          ? Colors.grey.shade100
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  // --- SECTION 4: TIP LOGIC ---
                  if (qr.tipIndicator != null) ...[
                    const SizedBox(height: 16),
                    _buildTipWidget(),
                  ],

                  // --- SECTION 5: BILL NUMBER ---
                  if (qr.tag62['01'] != null) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Bill Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _billController,
                      readOnly: qr.tag62['01'] != '***',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: qr.tag62['01'] != '***',
                        fillColor: qr.tag62['01'] != '***'
                            ? Colors.grey.shade50
                            : Colors.white,
                      ),
                    ),
                  ],

                  // --- SECTION 6: CONSUMER INFO ---
                  if (qr.consumerReq != null) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Required Information",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (qr.consumerReq!.contains('M')) ...[
                      const SizedBox(height: 8),
                      _buildSimpleField("Mobile Number", Icons.phone),
                    ],
                    if (qr.consumerReq!.contains('E')) ...[
                      const SizedBox(height: 8),
                      _buildSimpleField("Email Address", Icons.email),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomActionSection(),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  PreferredSizeWidget _buildGradientAppBar() {
    return AppBar(
      title: const Text(
        "Confirm Payment",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00AEDF), Color(0xFF0078D4)],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMerchantBox() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront,
              color: Color(0xFF00AEDF),
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qr.merchantName ?? "Merchant",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                // Text(
                //   "${qr.rawTags['60'] ?? 'City'}, ${qr.rawTags['58'] ?? 'ET'}",
                //   style: TextStyle(color: Colors.blue.shade800, fontSize: 14),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantCodeBox() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pin, color: Color(0xFF00AEDF), size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qr.merchantCode ?? "Merchant",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantBankBox() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance,
              color: Color(0xFF00AEDF),
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankService.getBankName("${qr.merchantBankName}"),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipWidget() {
    if (qr.tipIndicator == '01') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Tip",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _tipController,
            onChanged: (_) => _calculateTotal(),
            decoration: InputDecoration(
              hintText: "Enter amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixText: "ETB ",
            ),
          ),
        ],
      );
    }
    String label = qr.tipIndicator == '02'
        ? "Fixed Fee: ETB ${qr.fixedTip}"
        : "Service Fee: ${qr.percentageTip}%";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.orange.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomActionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Payable",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "ETB ${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00AEDF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () => setState(() => _isSubmitting = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AEDF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  _isSubmitting ? "PROCESSING..." : "PAY NOW",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountPickerReplacement() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet, color: Color(0xFF00AEDF)),
          const SizedBox(width: 12),
          Text(
            selectedAccount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _buildSimpleField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import './model/qr_model.dart';

// class PaymentScreen extends StatefulWidget {
//   final Map<String, dynamic> data;
//   const PaymentScreen({super.key, required this.data});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late QrData qr;
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _tipController = TextEditingController();
//   final TextEditingController _billController = TextEditingController();

//   double totalAmount = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     qr = QrData(widget.data);

//     // Logic for Tag 54 (Amount)
//     if (qr.amount != null) {
//       _amountController.text = qr.amount!;
//     }

//     // Logic for Tag 62 -> 01 (Bill Number)
//     if (qr.tag62['01'] != null && qr.tag62['01'] != '***') {
//       _billController.text = qr.tag62['01'];
//     }

//     _calculateTotal();
//   }

//   void _calculateTotal() {
//     double base = double.tryParse(_amountController.text) ?? 0.0;
//     double tip = 0.0;

//     if (qr.tipIndicator == '01') {
//       tip = double.tryParse(_tipController.text) ?? 0.0;
//     } else if (qr.tipIndicator == '02') {
//       tip = double.tryParse(qr.fixedTip ?? '0') ?? 0.0;
//     } else if (qr.tipIndicator == '03') {
//       double pct = double.tryParse(qr.percentageTip ?? '0') ?? 0.0;
//       tip = base * (pct / 100);
//     }

//     setState(() {
//       totalAmount = base + tip;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Confirm Payment")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Merchant Info Section (Tag 59, 60)
//             Card(
//               child: ListTile(
//                 title: Text(
//                   qr.merchantName ?? "Unknown Merchant",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(
//                   "${qr.rawTags['60'] ?? 'City'}, ${qr.rawTags['58'] ?? 'ET'}",
//                 ),
//                 leading: const Icon(Icons.storefront),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Amount Input (Tag 54)
//             const Text("Transaction Amount"),
//             TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               readOnly: qr.amount != null,
//               onChanged: (_) => _calculateTotal(),
//               decoration: InputDecoration(
//                 prefixText: "ETB ",
//                 filled: qr.amount != null,
//                 border: const OutlineInputBorder(),
//               ),
//             ),

//             // Tip Section (Tags 55, 56, 57)
//             if (qr.tipIndicator != null) ...[
//               const SizedBox(height: 20),
//               _buildTipWidget(),
//             ],

//             // Prompted Bill Section (Tag 62 -> 01)
//             if (qr.tag62['01'] != null) ...[
//               const SizedBox(height: 20),
//               const Text("Bill Number"),
//               TextField(
//                 controller: _billController,
//                 readOnly: qr.tag62['01'] != '***',
//                 decoration: const InputDecoration(border: OutlineInputBorder()),
//               ),
//             ],

//             // Consumer Data (Tag 62 -> 09)
//             if (qr.consumerReq != null) ...[
//               const SizedBox(height: 20),
//               const Text("Required Consumer Info"),
//               if (qr.consumerReq!.contains('M'))
//                 const TextField(
//                   decoration: InputDecoration(labelText: "Mobile Number"),
//                 ),
//               if (qr.consumerReq!.contains('E'))
//                 const TextField(
//                   decoration: InputDecoration(labelText: "Email"),
//                 ),
//             ],

//             const Divider(height: 40),

//             // Total Display
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Total Payable:", style: TextStyle(fontSize: 18)),
//                 Text(
//                   "ETB ${totalAmount.toStringAsFixed(2)}",
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => /* Handle Payment Submission */
//                     print("Paying..."),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.all(15),
//                 ),
//                 child: const Text("PAY NOW"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTipWidget() {
//     if (qr.tipIndicator == '01') {
//       return TextField(
//         controller: _tipController,
//         onChanged: (_) => _calculateTotal(),
//         decoration: const InputDecoration(
//           labelText: "Enter Tip Amount",
//           border: OutlineInputBorder(),
//         ),
//       );
//     } else if (qr.tipIndicator == '02') {
//       return Text(
//         "Fixed Fee: ETB ${qr.fixedTip}",
//         style: const TextStyle(color: Colors.grey),
//       );
//     } else {
//       return Text(
//         "Percentage Fee: ${qr.percentageTip}%",
//         style: const TextStyle(color: Colors.grey),
//       );
//     }
//   }
// }
