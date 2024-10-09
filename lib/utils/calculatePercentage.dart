int calculateDiscountPercentage(String? currentPrice, String? discountPrice) {
  if (currentPrice == null || discountPrice == null) return 0;
  final current = double.tryParse(currentPrice) ?? 0;
  final discount = double.tryParse(discountPrice) ?? 0;
  if (current == 0) return 0;
  return ((current - discount) / current * 100).round();
}