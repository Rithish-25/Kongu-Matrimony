import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:kongu_matrimony/main.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('App mounts successfully and displays main layout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KonguMatrimonyApp());

    // Verify that the logo text "KONGU" is displayed in the main app bar
    expect(find.textContaining('KONGU'), findsWidgets);
  });
}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getUrl || invocation.memberName == #openUrl) {
      return Future.value(MockHttpClientRequest());
    }
    return null;
  }
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #close) {
      return Future.value(MockHttpClientResponse());
    }
    if (invocation.memberName == #headers) {
      return MockHttpHeaders();
    }
    return null;
  }
}

class MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpClientResponse implements HttpClientResponse {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #statusCode) {
      return 200;
    }
    if (invocation.memberName == #compressionState) {
      return HttpClientResponseCompressionState.notCompressed;
    }
    if (invocation.memberName == #contentLength) {
      return transparentImage.length;
    }
    if (invocation.memberName == #headers) {
      return MockHttpHeaders();
    }
    if (invocation.memberName == #listen) {
      final Stream<List<int>> stream = Stream.value(transparentImage);
      return stream.listen(
        invocation.positionalArguments[0] as void Function(List<int>)?,
        onError: invocation.namedArguments[#onError] as Function?,
        onDone: invocation.namedArguments[#onDone] as void Function()?,
        cancelOnError: invocation.namedArguments[#cancelOnError] as bool?,
      );
    }
    return null;
  }
}

final List<int> transparentImage = [
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00,
  0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x21, 0xf9, 0x04, 0x01, 0x00,
  0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00,
  0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3b
];
