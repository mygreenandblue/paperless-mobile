import 'package:bloc_test/bloc_test.dart';
import 'package:paperless_mobile/features/login/cubit/authentication_cubit.dart';

class MockAuthenticationCubit extends MockCubit<AuthenticationState>
    implements AuthenticationCubit {}
