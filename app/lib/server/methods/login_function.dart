class login_check_data_input {
  bool emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }

  bool passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }

  bool confirmPasswordValidator(String? password, conform) {
    if (conform != conform) {
      return false;
    }
    return true;
  }
}
