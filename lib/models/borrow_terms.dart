enum BorrowTerms { free, deposit, cakeCoffee }

extension BorrowTermsX on BorrowTerms {
  String get label => switch (this) {
    BorrowTerms.free => 'Za darmo',
    BorrowTerms.deposit => 'Za kaucją',
    BorrowTerms.cakeCoffee => 'Za symboliczne ciasto/kawę',
  };

  static BorrowTerms? fromStorage(String? value) {
    return switch (value) {
      'free' => BorrowTerms.free,
      'deposit' => BorrowTerms.deposit,
      'cakeCoffee' => BorrowTerms.cakeCoffee,
      _ => null,
    };
  }
}
