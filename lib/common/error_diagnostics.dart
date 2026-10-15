import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// TEMPORARY — diagnostics for the vendor-review investigation.
///
/// Set to false (or delete this file and its two call sites) once the
/// masked error has been identified.
const bool kErrorDiagnostics = true;

/// Logs the real exception before Flutter's error reporter can obscure it.
///
/// On Flutter web in debug, `WidgetInspectorService._reportStructuredError`
/// renders every reported error to text. That renderer dereferences
/// `node.textTreeConfiguration!` (foundation/diagnostics.dart), which is null
/// for a node styled `DiagnosticsTreeStyle.none` — and it throws
/// "Unexpected null value" from inside `handleDrawFrame`, with no application
/// frame anywhere in the stack. The error that was *being reported* is lost.
///
/// Chaining ahead of that handler is what recovers it: this runs first, logs
/// the original exception and its stack, and only then hands the details on.
void installErrorDiagnostics() {
  if (!kErrorDiagnostics) return;

  final FlutterExceptionHandler? previous = FlutterError.onError;

  FlutterError.onError = (FlutterErrorDetails details) {
    developer.log(
      'Original error: ${details.exception.runtimeType}'
      '${details.library == null ? '' : ' (from ${details.library})'}',
      name: 'Diagnostics',
      error: details.exception,
      stackTrace: details.stack,
    );

    previous?.call(details);
  };
}

/// A stage marker on a path being traced. Carries no user or vendor data.
void logStage(String scope, String message) {
  if (!kErrorDiagnostics) return;
  developer.log(message, name: scope);
}
