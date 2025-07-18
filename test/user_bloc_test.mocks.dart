// Mocks generated by Mockito 5.4.6 from annotations
// in helios_tt/test/user_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:helios_tt/models/user_model.dart' as _i5;
import 'package:helios_tt/repositories/user_repository.dart' as _i3;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeClient_0 extends _i1.SmartFake implements _i2.Client {
  _FakeClient_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i3.UserRepository {
  MockUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Client get httpClient =>
      (super.noSuchMethod(
            Invocation.getter(#httpClient),
            returnValue: _FakeClient_0(this, Invocation.getter(#httpClient)),
          )
          as _i2.Client);

  @override
  _i4.Future<List<_i5.User>> fetchUsers(int? page) =>
      (super.noSuchMethod(
            Invocation.method(#fetchUsers, [page]),
            returnValue: _i4.Future<List<_i5.User>>.value(<_i5.User>[]),
          )
          as _i4.Future<List<_i5.User>>);
}
