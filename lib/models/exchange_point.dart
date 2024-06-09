class ExchangePoint {
  final int id;
  final int accountId;
  final int residentialQuarterId;
  final Account account;

  ExchangePoint({
    required this.id,
    required this.accountId,
    required this.residentialQuarterId,
    required this.account,
  });

  factory ExchangePoint.fromJson(Map<String, dynamic> json) {
    return ExchangePoint(
      id: json['id'],
      accountId: json['account_id'],
      residentialQuarterId: json['residentialQuarter_id'],
      account: Account.fromJson(json['account']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'residentialQuarter_id': residentialQuarterId,
      'account': account.toJson(),
    };
  }
}

class Account {
  final int id;
  final String userName;

  Account({
    required this.id,
    required this.userName,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
    };
  }
}
