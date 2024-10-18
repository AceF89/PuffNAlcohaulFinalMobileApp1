class SavedCards {
  final String? id;
  final String? object;
  final dynamic accountId;
  final dynamic account;
  final dynamic addressCity;
  final dynamic addressCountry;
  final dynamic addressLine1;
  final dynamic addressLine1Check;
  final dynamic addressLine2;
  final dynamic addressState;
  final dynamic addressZip;
  final dynamic addressZipCheck;
  final dynamic availablePayoutMethods;
  final String? brand;
  final String? country;
  final dynamic currency;
  final String? customerId;
  final dynamic customer;
  final String? cvcCheck;
  final dynamic defaultForCurrency;
  final dynamic deleted;
  final dynamic description;
  final dynamic dynamicLast4;
  final int? expMonth;
  final int? expYear;
  final String? fingerprint;
  final String? funding;
  final dynamic iin;
  final dynamic issuer;
  final String? last4;
  final dynamic name;
  final dynamic tokenizationMethod;
  final dynamic rawJObject;
  final dynamic stripeResponse;

  SavedCards({
    this.id,
    this.object,
    this.accountId,
    this.account,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.availablePayoutMethods,
    this.brand,
    this.country,
    this.currency,
    this.customerId,
    this.customer,
    this.cvcCheck,
    this.defaultForCurrency,
    this.deleted,
    this.description,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.iin,
    this.issuer,
    this.last4,
    this.name,
    this.tokenizationMethod,
    this.rawJObject,
    this.stripeResponse,
  });

  SavedCards copyWith({
    String? id,
    String? object,
    dynamic accountId,
    dynamic account,
    dynamic addressCity,
    dynamic addressCountry,
    dynamic addressLine1,
    dynamic addressLine1Check,
    dynamic addressLine2,
    dynamic addressState,
    dynamic addressZip,
    dynamic addressZipCheck,
    dynamic availablePayoutMethods,
    String? brand,
    String? country,
    dynamic currency,
    String? customerId,
    dynamic customer,
    String? cvcCheck,
    dynamic defaultForCurrency,
    dynamic deleted,
    dynamic description,
    dynamic dynamicLast4,
    int? expMonth,
    int? expYear,
    String? fingerprint,
    String? funding,
    dynamic iin,
    dynamic issuer,
    String? last4,
    dynamic name,
    dynamic tokenizationMethod,
    dynamic rawJObject,
    dynamic stripeResponse,
  }) {
    return SavedCards(
      id: id ?? this.id,
      object: object ?? this.object,
      accountId: accountId ?? this.accountId,
      account: account ?? this.account,
      addressCity: addressCity ?? this.addressCity,
      addressCountry: addressCountry ?? this.addressCountry,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine1Check: addressLine1Check ?? this.addressLine1Check,
      addressLine2: addressLine2 ?? this.addressLine2,
      addressState: addressState ?? this.addressState,
      addressZip: addressZip ?? this.addressZip,
      addressZipCheck: addressZipCheck ?? this.addressZipCheck,
      availablePayoutMethods:
          availablePayoutMethods ?? this.availablePayoutMethods,
      brand: brand ?? this.brand,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      customerId: customerId ?? this.customerId,
      customer: customer ?? this.customer,
      cvcCheck: cvcCheck ?? this.cvcCheck,
      defaultForCurrency: defaultForCurrency ?? this.defaultForCurrency,
      deleted: deleted ?? this.deleted,
      description: description ?? this.description,
      dynamicLast4: dynamicLast4 ?? this.dynamicLast4,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      fingerprint: fingerprint ?? this.fingerprint,
      funding: funding ?? this.funding,
      iin: iin ?? this.iin,
      issuer: issuer ?? this.issuer,
      last4: last4 ?? this.last4,
      name: name ?? this.name,
      tokenizationMethod: tokenizationMethod ?? this.tokenizationMethod,
      rawJObject: rawJObject ?? this.rawJObject,
      stripeResponse: stripeResponse ?? this.stripeResponse,
    );
  }

  factory SavedCards.fromJson(Map<String, dynamic> json) {
    return SavedCards(
      id: json["id"],
      object: json["object"],
      accountId: json["accountId"],
      account: json["account"],
      addressCity: json["addressCity"],
      addressCountry: json["addressCountry"],
      addressLine1: json["addressLine1"],
      addressLine1Check: json["addressLine1Check"],
      addressLine2: json["addressLine2"],
      addressState: json["addressState"],
      addressZip: json["addressZip"],
      addressZipCheck: json["addressZipCheck"],
      availablePayoutMethods: json["availablePayoutMethods"],
      brand: json["brand"],
      country: json["country"],
      currency: json["currency"],
      customerId: json["customerId"],
      customer: json["customer"],
      cvcCheck: json["cvcCheck"],
      defaultForCurrency: json["defaultForCurrency"],
      deleted: json["deleted"],
      description: json["description"],
      dynamicLast4: json["dynamicLast4"],
      expMonth: json["expMonth"],
      expYear: json["expYear"],
      fingerprint: json["fingerprint"],
      funding: json["funding"],
      iin: json["iin"],
      issuer: json["issuer"],
      last4: json["last4"],
      name: json["name"],
      tokenizationMethod: json["tokenizationMethod"],
      rawJObject: json["rawJObject"],
      stripeResponse: json["stripeResponse"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "object": object,
      "accountId": accountId,
      "account": account,
      "addressCity": addressCity,
      "addressCountry": addressCountry,
      "addressLine1": addressLine1,
      "addressLine1Check": addressLine1Check,
      "addressLine2": addressLine2,
      "addressState": addressState,
      "addressZip": addressZip,
      "addressZipCheck": addressZipCheck,
      "availablePayoutMethods": availablePayoutMethods,
      "brand": brand,
      "country": country,
      "currency": currency,
      "customerId": customerId,
      "customer": customer,
      "cvcCheck": cvcCheck,
      "defaultForCurrency": defaultForCurrency,
      "deleted": deleted,
      "description": description,
      "dynamicLast4": dynamicLast4,
      "expMonth": expMonth,
      "expYear": expYear,
      "fingerprint": fingerprint,
      "funding": funding,
      "iin": iin,
      "issuer": issuer,
      "last4": last4,
      "name": name,
      "tokenizationMethod": tokenizationMethod,
      "rawJObject": rawJObject,
      "stripeResponse": stripeResponse,
    };
  }
}
