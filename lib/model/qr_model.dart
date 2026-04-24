class QrData {
  final Map<String, dynamic> rawTags;

  QrData(this.rawTags);

  // Helper to get nested Tag 62 sub-tags
  Map<dynamic, dynamic> get tag62 => rawTags['62'] ?? {};

  String? get merchantName => rawTags['59'];
  String? get merchantBankName => rawTags['28']['01'];
  String? get merchantCode => rawTags['28']['02'];
  String? get amount => rawTags['54'];
  String? get tipIndicator => rawTags['55']; // 01, 02, or 03
  String? get fixedTip => rawTags['56'];
  String? get percentageTip => rawTags['57'];
  String? get consumerReq => tag62['09']; // M, E, A
}
