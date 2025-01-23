RegExp get replaceSpecialChar {
  return RegExp(r'[^0-9]');
}

mixin ValidationMixin {
  String? nameValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter a name';
    }

    return null;
  }

  String? cardHolderNameValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter the card holder name';
    }

    return null;
  }

  String? cardNumberValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter the card number';
    }

    RegExp regex = RegExp(r'^\d{15,16}$');

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid 15 or 16-digit card number';
    }

    return null;
  }

  String? validUntilValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter the valid until date (MM/YY)';
    }

    // Regular expression to match the format MM/YY
    RegExp regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid MM/YY format';
    }

    return null;
  }

  String? securityCodeValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter the security code';
    }

    RegExp regex = RegExp(r'^\d{3,4}$');

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid 3 or 4-digit security code';
    }

    return null;
  }

  String? tipValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter a tip amount';
    }

    num? tipAmount;
    try {
      tipAmount = num.parse(value);
    } catch (e) {
      return 'Invalid tip amount';
    }

    if (tipAmount > 99) {
      return 'Tip amount must be less than or equal to 99';
    }

    return null;
  }

  String? titleValidation(String? title) {
    if (title == null) return null;

    if (title.isEmpty) {
      return 'Please enter a title';
    }

    if (title.length < 5) {
      return 'Title must be at least 5 characters long';
    }

    if (title.length > 50) {
      return 'Title must not exceed 50 characters';
    }

    return null;
  }

  String? messaageValidation(String? title) {
    if (title == null) return null;

    if (title.isEmpty) {
      return 'Please enter a Message';
    }

    if (title.length < 10) {
      return 'Message must be at least 10 characters long';
    }

    if (title.length > 100) {
      return 'Message must not exceed 100 characters';
    }

    return null;
  }

  String? descriptionValidation(String? description) {
    if (description == null) return null;

    if (description.isEmpty) {
      return 'Please enter a description';
    }

    if (description.length < 10) {
      return 'Description must be at least 10 characters long';
    }

    if (description.length > 500) {
      return 'Description must not exceed 500 characters';
    }

    return null;
  }

  String? clientNameValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the client\'s name';
    }

    var v = value.trim();
    if (v.length < 3) {
      return 'Client\'s name must be at least 3 characters long';
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) {
      return 'Client\'s name can only contain alphabets and spaces';
    }

    return null;
  }

  String? productNameValidation(String? productName) {
    if (productName == null) return null;

    if (productName.isEmpty) {
      return 'Please enter a Product Name';
    }

    if (productName.length < 5) {
      return 'Product Name must be at least 5 characters long';
    }

    if (productName.length > 100) {
      return 'Product Name must not exceed 100 characters';
    }

    return null;
  }

  String? priceValidation(String? priceString) {
    if (priceString == null) return null;

    priceString = priceString.trim();

    if (priceString.isEmpty) {
      return 'Please enter a price';
    }

    if (!isNumeric(priceString)) {
      return 'Price must be a valid number';
    }

    double price = double.parse(priceString);

    if (price < 0) {
      return 'Price must be non-negative';
    }

    return null;
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  String? textValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter a info';
    }

    return null;
  }

  String? passwordValidation(String? password) {
    if (password?.isEmpty ?? false) {
      return 'Please enter a password';
    }
    return null;
  }

  String? newPasswordValidation(String? password) {
    if (password?.isEmpty ?? false) {
      return 'Please enter a new password';
    }
    return null;
  }

  String? confirmPasswordValidation(String? password, String newPassword) {
    if (password?.isEmpty ?? false) {
      return 'Please enter a confirm password';
    } else {
      if (password == newPassword) {
        return null;
      } else {
        return 'Confirm password does not match';
      }
    }
  }

  String? otpValidation(String? password) {
    if (password?.isEmpty ?? false) {
      return 'Please enter otp';
    }
    if (password!.length > 4 || password.length < 4) {
      return 'OTP Should be at least 4 characters';
    }
    return null;
  }

  String? otpValidation5(String? password) {
    if (password?.isEmpty ?? false) {
      return 'Please enter otp';
    }
    if (password!.length > 5 || password.length < 5) {
      return 'OTP Should be at least 5 characters';
    }
    return null;
  }

  String? otpAppointmentValidation(String? value) {
    if (value == null) return null;

    if (value.trim().isEmpty) return 'OTP is Mandatory';

    if (value.trim().length > 6 || value.trim().length < 4) {
      return 'OTP must be 5 characters long ';
    }

    return null;
  }

  String? emailAddressValidation(String? value) {
    if (value == null) return null;

    if (value.isNotEmpty) {
      if (isEmailValid(value)) {
        return null;
      } else {
        return 'Please enter valid email address';
      }
    } else {
      return 'Please enter an email address';
    }
  }

  String? emailPhoneValidation(String? value) {
    if (value == null) return null;

    if (value.isNotEmpty) {
      try {
        num.parse(value);
        return phoneNumberValidation(value);
      } catch (e) {
        if (isEmailValid(value)) {
          return null;
        } else {
          return 'Please enter valid email address';
        }
      }
    } else {
      return 'Please enter an email address';
    }
  }

  String? areaValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an area name';
    }
    return null;
  }

  String? addressValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  String? landmarkValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an landmark';
    }
    return null;
  }

  String? cityValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an city';
    }
    return null;
  }

  String? districtValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an District';
    }
    return null;
  }

  String? pincodeValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an Pincode';
    }
    return null;
  }

  String? stateValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an State';
    }
    return null;
  }

  String? countryValidation(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Please enter an Country';
    }
    return null;
  }

  String? restaurantNameValidation(String? name) {
    if (name?.isEmpty ?? false) {
      return 'Please enter the restaurant name';
    }
    if (name!.length < 5) {
      return 'Restaurant name should be at least 5 characters';
    }

    return null;
  }

  String? restaurantDetailsValidation(String? details) {
    if (details?.isEmpty ?? false) {
      return 'Please enter restaurant details';
    }
    if (details!.length < 5) {
      return 'Restaurant details should be at least 5 characters';
    }

    return null;
  }

  String? zipCodeValidation(String? zipCode) {
    if (zipCode?.isEmpty ?? false) {
      return 'Please enter ZIP code';
    }
    if (zipCode!.length < 5) {
      return 'ZIP code cannot be less than 5 digits';
    }

    return null;
  }

  String? phoneNumberValidation(String? value) {
    if (value == null) return null;

    var v = value.replaceAll(replaceSpecialChar, '');
    if (v.isEmpty) {
      return 'Please enter phone number';
    }

    if (v.length != 10) {
      return 'Please enter valid phone number';
    }
    return null;
  }

  String? phoneNumberNotMandatoryValidation(String? value) {
    if (value == null || value.isEmpty) return null;

    var v = value.replaceAll(replaceSpecialChar, '');
    if (v.isEmpty) {
      return 'Please enter phone number';
    }

    if (v.length != 10) {
      return 'Please enter valid phone number';
    }
    return null;
  }

  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
