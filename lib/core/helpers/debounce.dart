import 'dart:async';

Function debounce(void Function(dynamic) func, {int milliseconds = 500}) {
  Timer? timer;

  return (dynamic args) {
    args = args;
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), () {
      func(args);
      args = null; // Reset args after execution
    });
  };
}


// Example usage
// final debouncedPrint = debounce(() => print('Search triggered'), milliseconds: 1000);
// debouncedPrint(); // Only this call will trigger the function after 1000 milliseconds
