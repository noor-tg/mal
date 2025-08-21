# Mal (مال)
Incomes/Expenses Tracking App

## Tech Stack
- flutter
- riverpod
- flutter_bloc
- sqflite

## Setup
```sh
flutter pub get
```

## Run
```sh
flutter run
```

- run android on emulator
```sh
flutter run --device-id="emulator-5554" | rg -v EGL_emulation
```

- with Helix editor watch changes and hot reload running app (using zellij, fd, entr)
```sh
fd -e dart -e yaml -e yml | entr -cards 'zellij action move-focus-or-tab left && zellij action write-chars "r"'
```
- hot restart
```sh
fd -e dart -e yaml -e yml | entr -cards 'zellij action move-focus-or-tab left && zellij action write-chars "R"'
```

## Testing
### Integration
- run integration tests with patrol and get reports with allure
```sh
  patrol test -d emulator-5554 -t integration_test/**/*_test.dart --no-hide-test-steps
  adb exec-out sh -c 'cd /sdcard/googletest/test_outputfiles && tar cf - allure-results' | tar xvf - -C build/reports
  allure serve ./build/reports/allure-results
```
make sure you have allure cmd installed with
```sh
pnpm i -g allure-commandline
```
### Unit
```sh
  fd -e dart | entr -cards 'flutter test lib/**/*_test.dart --coverage -r github'
```

